defmodule TemplatePhoenixApiWeb.Schema.Types.ModelInterface do
  use Absinthe.Schema.Notation

  @desc "An object with an ID."
  interface :model_interface do
    interface :node
    
    field :id, non_null(:id), description: "ID of the object."
    field :model_id, non_null(:integer) do
      resolve fn model, _, _ ->
        # Extract integer representation of the binary ID
        case model.id do
          id when is_binary(id) ->
            # Create a consistent integer from UUID for Rails compatibility
            {:ok, :crypto.hash(:md5, id) |> :binary.decode_unsigned() |> rem(2147483647)}
          _ ->
            {:ok, 0}
        end
      end
    end
    field :created_at, non_null(:iso8601_datetime) do
      resolve fn model, _, _ ->
        {:ok, model.inserted_at}
      end
    end
    field :updated_at, non_null(:iso8601_datetime) do
      resolve fn model, _, _ ->
        {:ok, model.updated_at}
      end
    end

    resolve_type fn
      %TemplatePhoenixApi.Accounts.User{}, _ -> :user
      %TemplatePhoenixApi.Accounts.ApiAccessToken{}, _ -> :api_access_token
      %TemplatePhoenixApi.Content.Attachment{}, _ -> :attachment
      %TemplatePhoenixApi.Content.BlogPost{}, _ -> :blog_post
      %TemplatePhoenixApi.Content.Comment{}, _ -> :comment
      %TemplatePhoenixApi.Admin.SuperUser{}, _ -> :super_user
      %TemplatePhoenixApi.Jobs.JobRecord{}, _ -> :job_record
      %TemplatePhoenixApi.Audit.Version{}, _ -> :version
      _, _ -> nil
    end
  end
end