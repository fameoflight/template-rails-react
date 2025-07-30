defmodule TemplatePhoenixApiWeb.AbsintheSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: TemplatePhoenixApiWeb.Schema

  alias TemplatePhoenixApi.Guardian

  def connect(%{"token" => token}, socket, _connect_info) do
    case Guardian.decode_and_verify(token) do
      {:ok, %{"sub" => user_id}} ->
        user = TemplatePhoenixApi.Accounts.get_user!(user_id)
        socket = assign(socket, :current_user, user)
        {:ok, socket}

      {:error, _} ->
        :error
    end
  end

  def connect(_params, _socket, _connect_info), do: :error

  def id(socket), do: "absinthe_socket:#{socket.assigns.current_user.id}"
end