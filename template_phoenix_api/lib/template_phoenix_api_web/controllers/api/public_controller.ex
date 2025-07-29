defmodule TemplatePhoenixApiWeb.Api.PublicController do
  use TemplatePhoenixApiWeb, :controller

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
end