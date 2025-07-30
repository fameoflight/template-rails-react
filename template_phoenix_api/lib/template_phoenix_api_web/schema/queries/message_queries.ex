defmodule TemplatePhoenixApiWeb.Schema.Queries.MessageQueries do
  use Absinthe.Schema.Notation
  
  alias TemplatePhoenixApi.Content
  
  object :message_queries do
    @desc "Get messages for a room"
    field :messages, list_of(:message) do
      arg :room_id, non_null(:string)
      arg :limit, :integer, default_value: 50
      
      resolve fn args, context ->
        case context do
          %{context: %{current_user: _current_user}} ->
            %{room_id: room_id, limit: limit} = args
            messages = Content.list_messages_for_room(room_id, limit)
            {:ok, messages}
          _ ->
            {:error, "You must be signed in to view messages"}
        end
      end
    end

    @desc "Get a single message"
    field :message, :message do
      arg :id, non_null(:id)
      
      resolve fn args, context ->
        case context do
          %{context: %{current_user: _current_user}} ->
            %{id: id} = args
            case Content.get_message!(id) do
              nil -> {:error, "Message not found"}
              message -> {:ok, message}
            end
          _ ->
            {:error, "You must be signed in to view messages"}
        end
      end
    end
  end
end