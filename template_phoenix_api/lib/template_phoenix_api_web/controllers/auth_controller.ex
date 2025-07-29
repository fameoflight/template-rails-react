defmodule TemplatePhoenixApiWeb.AuthController do
  use TemplatePhoenixApiWeb, :controller

  alias TemplatePhoenixApi.Accounts
  alias TemplatePhoenixApi.Guardian
  alias TemplatePhoenixApi.Workers.EmailWorker
  alias TemplatePhoenixApi.Services.GoogleLogin

  def options(conn, _params) do
    # Handle CORS preflight requests
    conn
    |> put_status(200)
    |> json(%{})
  end

  def register(conn, params) do
    # Extract invite_code similar to Rails controller
    invite_code = params["inviteCode"] || params["invite_code"]
    user_params = params["user"] || params
    
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        # Update user with invite_code if provided (similar to Rails)
        user = if invite_code do
          {:ok, updated_user} = Accounts.update_user(user, %{invite_code: invite_code})
          updated_user
        else
          user
        end

        # Send confirmation email if user is not confirmed
        if not TemplatePhoenixApi.Accounts.User.confirmed?(user) do
          {:ok, user_with_token} = Accounts.generate_confirmation_token(user)
          EmailWorker.send_confirmation_instructions(user_with_token, user_with_token.confirmation_token)
        end

        {:ok, user, token} = Guardian.create_token(user)

        conn
        |> put_status(:created)
        |> json(%{
          data: %{
            user: %{
              id: user.id,
              email: user.email,
              name: user.name,
              nickname: user.nickname,
              confirmed: TemplatePhoenixApi.Accounts.User.confirmed?(user)
            },
            token: token
          }
        })

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          errors: translate_errors(changeset)
        })
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Guardian.authenticate(email, password) do
      {:ok, user, token} ->
        # Auto-confirm user on sign-in if confirm_on_sign_in is true (similar to Rails)
        user = if is_nil(user.confirmed_at) && user.confirm_on_sign_in do
          {:ok, updated_user} = Accounts.update_user(user, %{
            confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second),
            confirm_on_sign_in: false
          })
          updated_user
        else
          user
        end

        conn
        |> put_resp_header("access-token", token)
        |> put_resp_header("token-type", "Bearer")
        |> put_resp_header("client", "default")
        |> put_resp_header("expiry", (System.system_time(:second) + 2_592_000) |> to_string()) # 30 days
        |> put_resp_header("uid", user.email)
        |> json(%{
          data: %{
            user: %{
              id: user.id,
              email: user.email,
              name: user.name,
              nickname: user.nickname,
              confirmed: TemplatePhoenixApi.Accounts.User.confirmed?(user)
            }
          }
        })

      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{
          error: %{
            message: "Invalid email or password"
          }
        })
    end
  end

  def me(conn, _params) do
    user = conn.assigns[:current_user]

    conn
    |> json(%{
      data: %{
        user: %{
          id: user.id,
          email: user.email,
          name: user.name,
          nickname: user.nickname,
          confirmed: TemplatePhoenixApi.Accounts.User.confirmed?(user)
        }
      }
    })
  end

  def logout(conn, _params) do
    conn
    |> json(%{data: %{message: "Logged out successfully"}})
  end

  def validate_token(conn, _params) do
    user = conn.assigns[:current_user]
    
    if user do
      conn
      |> put_resp_header("access-token", get_req_header(conn, "access-token") |> List.first() || "")
      |> put_resp_header("token-type", "Bearer")
      |> put_resp_header("client", get_req_header(conn, "client") |> List.first() || "default")
      |> put_resp_header("expiry", get_req_header(conn, "expiry") |> List.first() || "")
      |> put_resp_header("uid", user.email)
      |> json(%{
        data: %{
          id: user.id,
          email: user.email,
          name: user.name,
          nickname: user.nickname,
          confirmed: TemplatePhoenixApi.Accounts.User.confirmed?(user)
        }
      })
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{
        errors: ["Invalid authentication credentials"]
      })
    end
  end

  def confirm(conn, %{"token" => token}) do
    case Accounts.confirm_user(token) do
      {:ok, user} ->
        conn
        |> json(%{
          data: %{
            message: "Email confirmed successfully",
            user: %{
              id: user.id,
              email: user.email,
              name: user.name,
              confirmed: true
            }
          }
        })

      {:error, :invalid_token} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          error: %{
            message: "Invalid confirmation token"
          }
        })
    end
  end

  def resend_confirmation(conn, %{"email" => email}) do
    case Accounts.get_user_by_email(email) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{
          error: %{
            message: "User not found"
          }
        })

      user ->
        if TemplatePhoenixApi.Accounts.User.confirmed?(user) do
          conn
          |> put_status(:unprocessable_entity)
          |> json(%{
            error: %{
              message: "Email is already confirmed"
            }
          })
        else
          {:ok, user_with_token} = Accounts.generate_confirmation_token(user)
          EmailWorker.send_confirmation_instructions(user_with_token, user_with_token.confirmation_token)

          conn
          |> json(%{
            data: %{
              message: "Confirmation email sent"
            }
          })
        end
    end
  end

  def forgot_password(conn, %{"email" => email}) do
    case Accounts.generate_reset_password_token(email) do
      {:ok, user, token} ->
        EmailWorker.send_reset_password_instructions(user, token)

        conn
        |> json(%{
          data: %{
            message: "Password reset instructions sent to your email"
          }
        })

      {:error, :user_not_found} ->
        # For security, don't reveal if email exists
        conn
        |> json(%{
          data: %{
            message: "Password reset instructions sent to your email"
          }
        })
    end
  end

  def reset_password(conn, %{"token" => token, "password" => password}) do
    case Accounts.reset_password(token, password) do
      {:ok, user} ->
        EmailWorker.send_password_change(user)

        conn
        |> json(%{
          data: %{
            message: "Password reset successfully"
          }
        })

      {:error, :invalid_token} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          error: %{
            message: "Invalid or expired reset token"
          }
        })

      {:error, :token_expired} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          error: %{
            message: "Reset token has expired"
          }
        })

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          errors: translate_errors(changeset)
        })
    end
  end

  def google_login(conn, %{"access_token" => access_token, "token_type" => token_type, "scope" => _scope}) do
    if token_type != "Bearer" do
      conn
      |> put_status(:unprocessable_entity)
      |> json(%{
        error: %{
          message: "Invalid token type: #{token_type}"
        }
      })
    else
      case GoogleLogin.get_user_info(access_token) do
        {:ok, google_user} ->
          case GoogleLogin.find_or_create_user(google_user) do
            {:ok, user} ->
              {:ok, user, token} = Guardian.create_token(user)

              conn
              |> json(%{
                data: %{
                  user: %{
                    id: user.id,
                    email: user.email,
                    name: user.name,
                    nickname: user.nickname,
                    confirmed: TemplatePhoenixApi.Accounts.User.confirmed?(user)
                  },
                  token: token
                }
              })

            {:error, changeset} ->
              conn
              |> put_status(:unprocessable_entity)
              |> json(%{
                errors: translate_errors(changeset)
              })
          end

        {:error, message} ->
          conn
          |> put_status(:unprocessable_entity)
          |> json(%{
            error: %{
              message: message
            }
          })
      end
    end
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  defp translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end