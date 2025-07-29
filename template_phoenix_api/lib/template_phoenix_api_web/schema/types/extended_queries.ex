defmodule TemplatePhoenixApiWeb.Schema.Types.ExtendedQueries do
  use Absinthe.Schema.Notation

  object :extended_queries do
    field :blog_post, :blog_post do
      arg :short_id, non_null(:string)
      resolve fn _, %{short_id: short_id}, _ ->
        case TemplatePhoenixApi.Content.get_blog_post_by_short_id(short_id) do
          nil -> {:ok, nil}
          blog_post -> {:ok, blog_post}
        end
      end
    end

    field :blog_posts, list_of(non_null(:blog_post)) do
      arg :status, non_null(:blog_posts_status_enum)
      resolve fn _, %{status: status}, _ ->
        status_string = String.downcase(Atom.to_string(status))
        blog_posts = TemplatePhoenixApi.Content.list_blog_posts_by_status(status_string)
        {:ok, blog_posts}
      end
    end

    field :custom_node, :node do
      arg :name, non_null(:string)
      arg :id, non_null(:id)
      resolve fn _, _, _ ->
        {:ok, nil} # TODO: implement custom node query
      end
    end

    @desc "Fetches an object given its ID."
    field :node, :node do
      arg :id, non_null(:id), description: "ID of the object."
      resolve fn _, %{id: id}, context ->
        case TemplatePhoenixApiWeb.Schema.object_from_id(id, context) do
          nil -> {:ok, nil}
          object -> {:ok, object}
        end
      end
    end

    @desc "Fetches a list of objects given a list of IDs."
    field :nodes, list_of(:node) do
      arg :ids, list_of(non_null(:id)), description: "IDs of the objects."
      resolve fn _, %{ids: ids}, context ->
        objects = Enum.map(ids, fn id ->
          TemplatePhoenixApiWeb.Schema.object_from_id(id, context)
        end)
        {:ok, objects}
      end
    end

    field :spoof, non_null(:boolean) do
      resolve fn _, _, _ ->
        {:ok, false} # TODO: implement spoof query
      end
    end

    field :super_user, non_null(:super_user) do
      resolve fn _, _, _ ->
        # For demo purposes, create or get the first super user
        case TemplatePhoenixApi.Repo.one(TemplatePhoenixApi.Admin.SuperUser) do
          nil ->
            {:ok, super_user} = TemplatePhoenixApi.Repo.insert(%TemplatePhoenixApi.Admin.SuperUser{name: "Super User"})
            {:ok, super_user}
          super_user ->
            {:ok, super_user}
        end
      end
    end
  end

  enum :blog_posts_status_enum do
    # Match Rails enum values exactly (lowercase)
    value :all, name: "all"
    value :draft, name: "draft"
    value :published, name: "published"  
  end
end