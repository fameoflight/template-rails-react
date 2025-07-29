defmodule TemplatePhoenixApi.Services.GoogleLogin do
  @moduledoc """
  Service for handling Google OAuth login
  """

  require Logger

  @google_userinfo_url "https://www.googleapis.com/oauth2/v1/userinfo"

  def get_user_info(access_token) do
    url = "#{@google_userinfo_url}?alt=json&access_token=#{access_token}"

    case Req.get(url) do
      {:ok, %{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %{status: status, body: body}} ->
        Logger.error("Google OAuth API error: #{status} - #{inspect(body)}")
        {:error, "Something went wrong while trying to login with Google"}

      {:error, reason} ->
        Logger.error("Google OAuth API request failed: #{inspect(reason)}")
        {:error, "Failed to connect to Google OAuth API"}
    end
  end

  def find_or_create_user(google_user) do
    email = google_user["email"]
    name = google_user["name"]

    case TemplatePhoenixApi.Accounts.get_user_by_email(email) do
      nil ->
        # Create new user with random password and auto-confirm
        password = generate_random_password()
        
        user_attrs = %{
          email: email,
          name: name,
          password: password,
          confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second)
        }

        case TemplatePhoenixApi.Accounts.create_user(user_attrs) do
          {:ok, user} -> {:ok, user}
          {:error, changeset} -> {:error, changeset}
        end

      user ->
        # Return existing user
        {:ok, user}
    end
  end

  defp generate_random_password do
    :crypto.strong_rand_bytes(16) |> Base.encode64()
  end
end