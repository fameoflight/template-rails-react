defmodule TemplatePhoenixApi.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  alias TemplatePhoenixApi.Repo

  alias TemplatePhoenixApi.Content.{BlogPost, Comment, Attachment, ModelAttachment, Message, Notification}

  @doc """
  Returns the list of blog_posts.
  """
  def list_blog_posts do
    Repo.all(BlogPost)
  end

  @doc """
  Returns the list of blog_posts by status.
  """
  def list_blog_posts_by_status(status) do
    BlogPost
    |> BlogPost.by_status(status)
    |> Repo.all()
  end

  @doc """
  Gets a single blog_post by short_id.
  """
  def get_blog_post_by_short_id(short_id) do
    Repo.get_by(BlogPost, short_id: short_id)
  end

  @doc """
  Gets a single blog_post.
  """
  def get_blog_post!(id), do: Repo.get!(BlogPost, id)

  @doc """
  Creates a blog_post.
  """
  def create_blog_post(attrs \\ %{}) do
    %BlogPost{}
    |> BlogPost.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a blog_post.
  """
  def update_blog_post(%BlogPost{} = blog_post, attrs) do
    blog_post
    |> BlogPost.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a blog_post.
  """
  def delete_blog_post(%BlogPost{} = blog_post) do
    Repo.delete(blog_post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking blog_post changes.
  """
  def change_blog_post(%BlogPost{} = blog_post, attrs \\ %{}) do
    BlogPost.changeset(blog_post, attrs)
  end

  # Comments

  @doc """
  Returns the list of comments.
  """
  def list_comments do
    Comment
    |> Comment.not_discarded()
    |> Repo.all()
  end

  @doc """
  Returns the list of comments for a commentable.
  """
  def list_comments_for_commentable(commentable_id, commentable_type) do
    Comment
    |> Comment.for_commentable(commentable_id, commentable_type)
    |> Comment.not_discarded()
    |> Repo.all()
  end

  @doc """
  Gets a single comment.
  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Creates a comment.
  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.
  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Discards a comment.
  """
  def discard_comment(%Comment{} = comment) do
    comment
    |> Comment.discard_changeset()
    |> Repo.update()
  end

  @doc """
  Deletes a comment.
  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.
  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end

  # Attachments

  @doc """
  Returns the list of attachments.
  """
  def list_attachments do
    Repo.all(Attachment)
  end

  @doc """
  Returns the list of attachments for a record.
  """
  def list_attachments_for_record(record_id, record_type) do
    Attachment
    |> Attachment.for_record(record_id, record_type)
    |> Repo.all()
  end

  @doc """
  Gets a single attachment.
  """
  def get_attachment!(id), do: Repo.get!(Attachment, id)

  @doc """
  Creates a attachment.
  """
  def create_attachment(attrs \\ %{}) do
    %Attachment{}
    |> Attachment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a attachment.
  """
  def update_attachment(%Attachment{} = attachment, attrs) do
    attachment
    |> Attachment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a attachment.
  """
  def delete_attachment(%Attachment{} = attachment) do
    Repo.delete(attachment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking attachment changes.
  """
  def change_attachment(%Attachment{} = attachment, attrs \\ %{}) do
    Attachment.changeset(attachment, attrs)
  end

  # Model Attachments

  @doc """
  Returns the list of model attachments for an owner.
  """
  def list_model_attachments_for_owner(owner_id, owner_type) do
    ModelAttachment.for_owner(owner_id, owner_type)
    |> Repo.all()
  end

  @doc """
  Gets a named model attachment for an owner.
  """
  def get_model_attachment_for_owner(owner_id, owner_type, name) do
    ModelAttachment.for_owner_with_name(owner_id, owner_type, name)
    |> Repo.one()
  end

  @doc """
  Gets a single model attachment.
  """
  def get_model_attachment!(id), do: Repo.get!(ModelAttachment, id)

  @doc """
  Creates a model attachment.
  """
  def create_model_attachment(attrs \\ %{}) do
    %ModelAttachment{}
    |> ModelAttachment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a model attachment.
  """
  def update_model_attachment(%ModelAttachment{} = model_attachment, attrs) do
    model_attachment
    |> ModelAttachment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a model attachment.
  """
  def delete_model_attachment(%ModelAttachment{} = model_attachment) do
    Repo.delete(model_attachment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking model attachment changes.
  """
  def change_model_attachment(%ModelAttachment{} = model_attachment, attrs \\ %{}) do
    ModelAttachment.changeset(model_attachment, attrs)
  end

  # Messages

  @doc """
  Returns the list of messages for a room.
  """
  def list_messages_for_room(room_id, limit \\ 50) do
    Message
    |> Message.for_room(room_id)
    |> Message.with_user()
    |> Message.recent()
    |> limit(^limit)
    |> order_by([m], asc: m.inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a single message.
  """
  def get_message!(id) do
    Message
    |> Message.with_user()
    |> Repo.get!(id)
  end

  @doc """
  Creates a message.
  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.
  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.
  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.
  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  # Notifications

  @doc """
  Returns the list of notifications for a user.
  """
  def list_notifications_for_user(user_id, limit \\ 50) do
    Notification
    |> Notification.for_user(user_id)
    |> Notification.with_user()
    |> Notification.recent()
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Returns the list of unread notifications for a user.
  """
  def list_unread_notifications_for_user(user_id, limit \\ 50) do
    Notification
    |> Notification.for_user(user_id)
    |> Notification.unread()
    |> Notification.with_user()
    |> Notification.recent()
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Gets the count of unread notifications for a user.
  """
  def get_unread_notification_count(user_id) do
    Notification
    |> Notification.for_user(user_id)
    |> Notification.unread()
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Gets a single notification.
  """
  def get_notification!(id) do
    Notification
    |> Notification.with_user()
    |> Repo.get!(id)
  end

  @doc """
  Creates a notification.
  """
  def create_notification(attrs \\ %{}) do
    %Notification{}
    |> Notification.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a notification.
  """
  def update_notification(%Notification{} = notification, attrs) do
    notification
    |> Notification.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Marks a notification as read.
  """
  def mark_notification_as_read(%Notification{} = notification) do
    update_notification(notification, %{read_at: DateTime.utc_now()})
  end

  @doc """
  Marks all notifications for a user as read.
  """
  def mark_all_notifications_as_read(user_id) do
    Notification
    |> Notification.for_user(user_id)
    |> Notification.unread()
    |> Repo.update_all(set: [read_at: DateTime.utc_now(), updated_at: DateTime.utc_now()])
  end

  @doc """
  Deletes a notification.
  """
  def delete_notification(%Notification{} = notification) do
    Repo.delete(notification)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking notification changes.
  """
  def change_notification(%Notification{} = notification, attrs \\ %{}) do
    Notification.changeset(notification, attrs)
  end
end