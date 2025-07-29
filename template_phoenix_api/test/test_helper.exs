# Start the application and all dependencies
{:ok, _} = Application.ensure_all_started(:template_phoenix_api)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(TemplatePhoenixApi.Repo, :manual)

{:ok, _} = Application.ensure_all_started(:ex_machina)
