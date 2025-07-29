defmodule TemplatePhoenixApiWeb.Schema.Types.Node do
  use Absinthe.Schema.Notation

  @desc "An object with an ID."
  interface :node do
    field :id, non_null(:id), description: "ID of the object."

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