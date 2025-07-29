defmodule TemplatePhoenixApiWeb.Schema.Types.PlaceholderTypes do
  use Absinthe.Schema.Notation

  # Implemented types to match Rails schema structure

  object :api_access_token do
    interface :model_interface  
    interface :comment_interface
    interface :node
    
    field :id, non_null(:id)
    field :model_id, non_null(:integer)
    field :created_at, non_null(:iso8601_datetime)
    field :updated_at, non_null(:iso8601_datetime)
    
    field :active, non_null(:boolean)
    field :description, :string
    field :expires_at, :iso8601_datetime
    field :name, non_null(:string)
    field :token, non_null(:string)
    field :user, non_null(:user) do
      resolve fn token, _, _ ->
        user = TemplatePhoenixApi.Accounts.get_user!(token.user_id)
        {:ok, user}
      end
    end
    field :comment_count, non_null(:integer) do
      resolve fn token, _, _ ->
        count = TemplatePhoenixApi.Repo.one(
          TemplatePhoenixApi.Content.Comment.count_for_commentable(token.id, "ApiAccessToken")
        )
        {:ok, count || 0}
      end
    end
    field :comments, non_null(list_of(non_null(:comment))) do
      resolve fn token, _, _ ->
        comments = TemplatePhoenixApi.Content.list_comments_for_commentable(token.id, "ApiAccessToken")
        {:ok, comments}
      end
    end
  end

  object :attachment do
    interface :model_interface
    interface :node
    
    field :id, non_null(:id)
    field :model_id, non_null(:integer)
    field :created_at, non_null(:iso8601_datetime)
    field :updated_at, non_null(:iso8601_datetime)
    
    field :content_type, :string
    field :name, non_null(:string)
    field :record_id, non_null(:integer)
    field :record_type, non_null(:string)
    field :url, :string
  end

  object :blog_post do
    interface :model_interface
    interface :model_attachment_interface
    interface :node
    
    field :id, non_null(:id)
    field :model_id, non_null(:integer)
    field :created_at, non_null(:iso8601_datetime)
    field :updated_at, non_null(:iso8601_datetime)
    
    field :published_at, :iso8601_datetime
    field :rich_text_content, non_null(:rich_text_json) do
      resolve fn blog_post, _, _ ->
        content = %{
          content: blog_post.rich_text_content["content"],
          content_html: blog_post.rich_text_content["content_html"],
          content_markdown: blog_post.rich_text_content["content_markdown"],
          format: String.downcase(blog_post.rich_text_content["format"] || "plain")
        }
        {:ok, content}
      end
    end
    field :short_id, non_null(:string)
    field :status, non_null(:blog_post_status_enum) do
      resolve fn blog_post, _, _ ->
        {:ok, String.upcase(blog_post.status)}
      end
    end
    field :tags, non_null(list_of(non_null(:string)))
    field :title, non_null(:string)
    field :attachments, non_null(list_of(non_null(:model_attachment))) do
      resolve fn blog_post, _, _ ->
        attachments = TemplatePhoenixApi.Content.list_attachments_for_record(blog_post.id, "BlogPost")
        model_attachments = Enum.map(attachments, fn attachment ->
          %{
            id: attachment.id,
            model_id: :crypto.hash(:md5, attachment.id) |> :binary.decode_unsigned() |> rem(2147483647),
            created_at: attachment.inserted_at,
            updated_at: attachment.updated_at,
            attachment: attachment,
            name: attachment.name
          }
        end)
        {:ok, model_attachments}
      end
    end
    field :comments, non_null(list_of(non_null(:comment))) do
      resolve fn blog_post, _, _ ->
        comments = TemplatePhoenixApi.Content.list_comments_for_commentable(blog_post.id, "BlogPost")
        {:ok, comments}
      end
    end
  end

  object :comment do
    interface :model_interface
    interface :node
    
    field :id, non_null(:id)
    field :model_id, non_null(:integer)
    field :created_at, non_null(:iso8601_datetime)
    field :updated_at, non_null(:iso8601_datetime)
    
    field :discarded_at, :iso8601_datetime
    field :rating, :float
    field :rich_text_content, non_null(:rich_text_json) do
      resolve fn comment, _, _ ->
        content = %{
          content: comment.rich_text_content["content"],
          content_html: comment.rich_text_content["content_html"],
          content_markdown: comment.rich_text_content["content_markdown"],
          format: String.downcase(comment.rich_text_content["format"] || "plain")
        }
        {:ok, content}
      end
    end
    field :tags, non_null(list_of(non_null(:string)))
    field :user, non_null(:user)
  end

  object :rich_text_json do
    field :content, :string
    field :content_html, :string
    field :content_markdown, :string
    field :format, non_null(:rich_text_json_format_enum)
  end

  enum :rich_text_json_format_enum do
    # Match Rails enum values exactly with lowercase names for frontend compatibility
    value :plain, name: "plain"
    value :markdown, name: "markdown"  
    value :lexical, name: "lexical"
  end

  enum :blog_post_status_enum do
    value :draft
    value :published
  end

  object :super_user do
    interface :model_interface
    interface :node
    
    field :id, non_null(:id)
    field :model_id, non_null(:integer)
    field :created_at, non_null(:iso8601_datetime)
    field :updated_at, non_null(:iso8601_datetime)
    
    field :name, :string
    
    field :users, non_null(list_of(non_null(:user))) do
      arg :term, :string, default_value: nil
      resolve fn _super_user, %{term: term}, _ ->
        users = if term do
          # Simple search by name or email
          TemplatePhoenixApi.Accounts.search_users(term)
        else
          TemplatePhoenixApi.Accounts.list_users()
        end
        {:ok, Enum.take(users, 100)}
      end
    end
    
    field :job_records, non_null(list_of(non_null(:job_record))) do
      resolve fn _, _, _ ->
        # Return empty list for now - job_records would need to be implemented
        # based on the background job system or audit logs
        {:ok, []}
      end
    end
  end

  object :job_record do
    interface :model_interface
    interface :node
    
    field :id, non_null(:id)
    field :model_id, non_null(:integer)
    field :created_at, non_null(:iso8601_datetime)
    field :updated_at, non_null(:iso8601_datetime)
    
    field :active_job_id, :string
    field :concurrency_key, :string
    field :cron_at, :iso8601_datetime
    field :cron_key, :string
    field :error, :string
    field :finished_at, :iso8601_datetime
    field :performed_at, :iso8601_datetime
    field :priority, :integer
    field :queue_name, :string
    field :retried_good_job_id, :string
    field :scheduled_at, :iso8601_datetime
    field :serialized_params, :json
  end

  object :version do
    interface :model_interface
    interface :node
    
    field :id, non_null(:id)
    field :model_id, non_null(:integer)
    field :created_at, non_null(:iso8601_datetime)
    field :updated_at, non_null(:iso8601_datetime)
    
    field :changes, non_null(list_of(non_null(:version_change)))
    field :event, non_null(:string)
    field :item_id, non_null(:integer)
    field :item_type, non_null(:string)
    field :metadata, :json
    field :user, :user
    field :whodunnit, :string
  end

  object :version_change do
    field :label, non_null(:string)
    field :new_value, :string
    field :previous_value, :string
  end
end