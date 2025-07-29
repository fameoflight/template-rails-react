defmodule TemplatePhoenixApi.Repo do
  use Ecto.Repo,
    otp_app: :template_phoenix_api,
    adapter: Ecto.Adapters.Postgres
end
