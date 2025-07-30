defmodule TemplatePhoenixApiWeb.Schema.Types.User do
  use TemplatePhoenixApiWeb.Schema.BaseObject

  object :user do
    # Implement model interface (includes node interface)
    model_interface()
    
    # Implement all required interface fields
    model_fields()
    
    # User-specific fields matching Rails schema
    field :api_access_tokens, list_of(:api_access_token) do
      resolve fn user, _, _ ->
        tokens = TemplatePhoenixApi.Accounts.list_user_api_access_tokens(user.id)
        {:ok, tokens}
      end
    end
    field :avatar, :attachment do
      resolve fn user, _, _ ->
        attachments = TemplatePhoenixApi.Content.list_attachments_for_record(user.id, "User")
        avatar = Enum.find(attachments, fn attachment -> 
          String.contains?(attachment.name || "", ["avatar", "profile"]) 
        end)
        {:ok, avatar}
      end
    end
    field :canny_token, :string do
      resolve fn _user, _, _ ->
        # Generate a simple token for Canny integration
        # In a real app, this would be stored and managed properly
        {:ok, nil}
      end
    end
    field :confirmed_at, :iso8601_datetime do
      resolve fn user, _, _ ->
        {:ok, user.confirmed_at}
      end
    end
    # Essential authentication fields
    field :email, non_null(:string)
    field :name, :string
    field :nickname, :string
    field :confirmed, non_null(:boolean) do
      resolve fn user, _, _ ->
        {:ok, TemplatePhoenixApi.Accounts.User.confirmed?(user)}
      end
    end
    field :first_name, non_null(:string) do
      resolve fn user, _, _ ->
        {:ok, TemplatePhoenixApi.Accounts.User.first_name(user)}
      end
    end
    field :otp_enabled, non_null(:boolean) do
      resolve fn user, _, _ ->
        {:ok, TemplatePhoenixApi.Accounts.User.otp_enabled?(user)}
      end
    end
    field :otp_provisioning_uri, non_null(:string) do
      resolve fn _user, _, _ ->
        {:ok, ""} # TODO: implement OTP provisioning URI
      end
    end
    field :spoof, non_null(:boolean) do
      resolve fn _user, _, _ ->
        {:ok, false} # TODO: implement spoof functionality
      end
    end
  end

  object :user_queries do
    field :current_user, :user do
      resolve fn 
        _, _, %{context: %{current_user: user}} ->
          {:ok, user}
        _, _, _ ->
          {:error, "Not authenticated"}
      end
    end

    field :users, list_of(:user) do
      resolve fn 
        _, _, %{context: %{current_user: _user}} ->
          {:ok, TemplatePhoenixApi.Accounts.list_users()}
        _, _, _ ->
          {:error, "Not authenticated"}
      end
    end
  end
end