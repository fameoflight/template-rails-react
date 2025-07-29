defmodule TemplatePhoenixApiWeb.Schema.Types.AdditionalInterfaces do
  use Absinthe.Schema.Notation

  @desc "An object with an ID."
  interface :comment_interface do
    field :comment_count, non_null(:integer)
    field :comments, non_null(list_of(non_null(:comment)))
    field :created_at, non_null(:iso8601_datetime)
    field :id, non_null(:id), description: "ID of the object."
    field :model_id, non_null(:integer)
    field :updated_at, non_null(:iso8601_datetime)

    resolve_type fn
      _, _ -> nil # TODO: implement based on actual types that implement this interface
    end
  end

  @desc "An object with an ID."
  interface :model_attachment_interface do
    interface :model_interface
    interface :node
    
    field :attachments, non_null(list_of(non_null(:model_attachment)))
    field :created_at, non_null(:iso8601_datetime)
    field :id, non_null(:id), description: "ID of the object."
    field :model_id, non_null(:integer)
    field :updated_at, non_null(:iso8601_datetime)

    resolve_type fn
      _, _ -> nil # TODO: implement based on actual types that implement this interface
    end
  end
end