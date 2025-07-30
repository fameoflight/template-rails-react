defmodule TemplatePhoenixApiWeb.Schema.Mutations.MessageCreate do
  use Absinthe.Schema.Notation
  
  alias TemplatePhoenixApi.Content
  
  require Logger

  object :message_create_mutation do
    @desc "Create a new chat message"
    field :message_create, :message_create_response do
      arg :content, non_null(:string)
      arg :room_id, non_null(:string)
      
      resolve fn %{content: content, room_id: room_id}, %{context: %{current_user: current_user}} ->
        Logger.info("🚀 GraphQL MessageCreate called with content: '#{content}', room_id: '#{room_id}'")
        Logger.info("👤 Current user in mutation: #{current_user.id}")
        
        message_attrs = %{
          content: content,
          room_id: room_id,
          user_id: current_user.id
        }
        
        case Content.create_message(message_attrs) do
          {:ok, message} ->
            Logger.info("✅ Message saved: #{message.id}")
            
            # Reload the message with user association
            message = Content.get_message!(message.id)
            Logger.info("📄 Message reloaded with user: #{message.user.name} (ID: #{message.user.id})")
            
            # Broadcast message via Phoenix channels using BroadcastService
            TemplatePhoenixApi.Services.BroadcastService.broadcast_message(room_id, message)
            
            {:ok, %{
              message: message,
              errors: []
            }}
            
          {:error, changeset} ->
            Logger.error("❌ Failed to create message: #{inspect(changeset.errors)}")
            errors = format_changeset_errors_list(changeset)
            {:ok, %{
              message: nil,
              errors: errors
            }}
        end
      end
      
      resolve fn _args, _context ->
        {:error, "You must be signed in to send messages"}
      end
    end
  end

  defp format_changeset_errors_list(changeset) do
    changeset.errors
    |> Enum.map(fn {field, {message, _}} ->
      "#{field}: #{message}"
    end)
  end
end