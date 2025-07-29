defmodule TemplatePhoenixApi.AuthHelpers do
  alias TemplatePhoenixApi.Guardian

  def auth_headers(user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    [{"authorization", "Bearer #{token}"}]
  end

  def create_auth_token(user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    token
  end
end