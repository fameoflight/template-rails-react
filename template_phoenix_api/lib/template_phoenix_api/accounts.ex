defmodule TemplatePhoenixApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias TemplatePhoenixApi.Repo
  alias TemplatePhoenixApi.Accounts.{User, ApiAccessToken}

  def list_users do
    Repo.all(User)
  end

  def search_users(term) when is_binary(term) do
    search_term = "%#{term}%"
    from(u in User,
      where: ilike(u.name, ^search_term) or ilike(u.email, ^search_term),
      order_by: [asc: u.name]
    )
    |> Repo.all()
  end

  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def authenticate_user(email, password) do
    case get_user_by_email(email) do
      nil ->
        Bcrypt.no_user_verify()
        {:error, :invalid_credentials}

      user ->
        if User.verify_password_with_otp(user, password) do
          update_sign_in_info(user)
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  defp update_sign_in_info(user) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    
    user
    |> Ecto.Changeset.change(%{
      last_sign_in_at: user.current_sign_in_at,
      current_sign_in_at: now,
      sign_in_count: (user.sign_in_count || 0) + 1
    })
    |> Repo.update()
  end

  def generate_confirmation_token(user) do
    token = :crypto.strong_rand_bytes(32) |> Base.url_encode64()
    
    user
    |> Ecto.Changeset.change(%{
      confirmation_token: token,
      confirmation_sent_at: DateTime.utc_now() |> DateTime.truncate(:second)
    })
    |> Repo.update()
  end

  def confirm_user(token) do
    case Repo.get_by(User, confirmation_token: token) do
      nil ->
        {:error, :invalid_token}

      user ->
        user
        |> Ecto.Changeset.change(%{
          confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second),
          confirmation_token: nil
        })
        |> Repo.update()
    end
  end

  def generate_reset_password_token(email) do
    case get_user_by_email(email) do
      nil ->
        {:error, :user_not_found}

      user ->
        token = :crypto.strong_rand_bytes(32) |> Base.url_encode64()
        
        user
        |> Ecto.Changeset.change(%{
          reset_password_token: token,
          reset_password_sent_at: DateTime.utc_now() |> DateTime.truncate(:second)
        })
        |> Repo.update()
        |> case do
          {:ok, user} -> {:ok, user, token}
          error -> error
        end
    end
  end

  def reset_password(token, new_password) do
    case Repo.get_by(User, reset_password_token: token) do
      nil ->
        {:error, :invalid_token}

      user ->
        # Check if token is not expired (24 hours)
        if DateTime.diff(DateTime.utc_now(), user.reset_password_sent_at, :second) > 86400 do
          {:error, :token_expired}
        else
          user
          |> User.changeset(%{password: new_password})
          |> Ecto.Changeset.change(%{
            reset_password_token: nil,
            reset_password_sent_at: nil
          })
          |> Repo.update()
        end
    end
  end

  # OTP Functions

  def enable_otp(user) do
    otp_secret = User.generate_otp_secret()
    
    user
    |> Ecto.Changeset.change(%{otp_secret: otp_secret})
    |> Repo.update()
    |> case do
      {:ok, updated_user} -> 
        otp_uri = User.generate_otp_uri(updated_user)
        {:ok, updated_user, otp_uri}
      error -> error
    end
  end

  def disable_otp(user) do
    user
    |> Ecto.Changeset.change(%{otp_secret: nil})
    |> Repo.update()
  end

  def verify_otp_setup(user, otp_code1, otp_code2, otp_secret) do
    test_user = %{user | otp_secret: otp_secret}
    
    valid1 = User.valid_otp?(test_user, otp_code1)
    valid2 = User.valid_otp?(test_user, otp_code2)
    
    if valid1 and valid2 do
      user
      |> Ecto.Changeset.change(%{otp_secret: otp_secret})
      |> Repo.update()
    else
      errors = []
      errors = if not valid1, do: ["Invalid OTP code 1" | errors], else: errors
      errors = if not valid2, do: ["Invalid OTP code 2" | errors], else: errors
      {:error, errors}
    end
  end

  # API Access Tokens

  @doc """
  Returns the list of api_access_tokens for a user.
  """
  def list_user_api_access_tokens(user_id) do
    ApiAccessToken
    |> where([t], t.user_id == ^user_id)
    |> Repo.all()
  end

  @doc """
  Gets a single api_access_token.
  """
  def get_api_access_token!(id), do: Repo.get!(ApiAccessToken, id)

  @doc """
  Gets an api_access_token by token.
  """
  def get_api_access_token_by_token(token) do
    Repo.get_by(ApiAccessToken, token: token)
  end

  @doc """
  Creates a api_access_token.
  """
  def create_api_access_token(attrs \\ %{}) do
    %ApiAccessToken{}
    |> ApiAccessToken.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a api_access_token.
  """
  def update_api_access_token(%ApiAccessToken{} = api_access_token, attrs) do
    api_access_token
    |> ApiAccessToken.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a api_access_token.
  """
  def delete_api_access_token(%ApiAccessToken{} = api_access_token) do
    Repo.delete(api_access_token)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking api_access_token changes.
  """
  def change_api_access_token(%ApiAccessToken{} = api_access_token, attrs \\ %{}) do
    ApiAccessToken.changeset(api_access_token, attrs)
  end
end