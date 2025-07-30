defmodule TemplatePhoenixApiWeb.Schema.Types.Message do
  use TemplatePhoenixApiWeb.Schema.BaseObject

  @desc "A chat message"
  object :message do
    # Standard fields (id, created_at, updated_at, model_id)
    standard_fields()
    
    # Message-specific fields
    field :content, non_null(:string)
    field :room_id, non_null(:string)
    
    field :user, non_null(:user) do
      resolve fn message, _args, _context ->
        # The user should already be preloaded via Ecto.preload in our queries
        case message.user do
          %Ecto.Association.NotLoaded{} -> {:error, "User not loaded"}
          user -> {:ok, user}
        end
      end
    end
  end

  @desc "Input for creating a message"
  input_object :message_input do
    field :content, non_null(:string)
    field :room_id, non_null(:string)
  end

  @desc "Response for creating a message"
  object :message_create_response do
    field :message, :message
    field :errors, list_of(:string)
  end
end