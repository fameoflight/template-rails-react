defmodule TemplatePhoenixApiWeb.Internal.UsersController do
  use TemplatePhoenixApiWeb, :controller

  alias TemplatePhoenixApi.Services.GoogleLogin
  alias TemplatePhoenixApi.Guardian

  def options(conn, _params) do
    # Handle CORS preflight requests
    conn
    |> put_status(200)
    |> json(%{})
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

  def avatar(conn, %{"avatar" => _avatar_params}) do
    _user = conn.assigns[:current_user]
    
    # TODO: Implement avatar upload functionality
    # This would use the file attachment system we created earlier
    
    conn
    |> put_status(:not_implemented)
    |> json(%{
      error: %{
        message: "Avatar upload not yet implemented"
      }
    })
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