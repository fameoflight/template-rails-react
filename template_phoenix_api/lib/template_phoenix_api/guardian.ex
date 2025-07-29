defmodule TemplatePhoenixApi.Guardian do
  use Guardian, otp_app: :template_phoenix_api

  alias TemplatePhoenixApi.Accounts

  def subject_for_token(%{id: id}, _claims) do
    {:ok, to_string(id)}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user(id) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, user}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end

  def authenticate(email, password) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        create_token(user)

      {:error, _reason} ->
        {:error, :unauthorized}
    end
  end

  def create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user, %{}, ttl: {12, :days})
    {:ok, user, token}
  end

  def decode_token(token) do
    case decode_and_verify(token) do
      {:ok, claims} -> 
        case resource_from_claims(claims) do
          {:ok, user} -> {:ok, user, claims}
          error -> error
        end
      {:error, reason} -> {:error, reason}
    end
  end
end