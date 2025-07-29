defmodule TemplatePhoenixApi.Seeds.Content do
  @moduledoc """
  Seeds for content data (blog posts, comments, attachments)
  """
  
  alias TemplatePhoenixApi.Repo
  alias TemplatePhoenixApi.Content.{BlogPost, Comment, Attachment, ModelAttachment}
  alias TemplatePhoenixApi.Accounts.User
  
  def seed do
    IO.puts("📝 Creating content...")
    
    # Get users for content creation
    admin_user = Repo.get_by!(User, email: "admin@test.com")
    regular_user = Repo.get_by!(User, email: "user@test.com")
    
    # Create blog posts
    published_post = create_blog_post(%{
      title: "Welcome to Our Platform",
      rich_text_content: %{
        "format" => "markdown",
        "content" => "# Welcome!\n\nThis is our first blog post. We're excited to share our thoughts with you."
      },
      status: "published",
      published_at: DateTime.utc_now() |> DateTime.truncate(:second),
      tags: ["welcome", "announcement"],
      short_id: "welcome"
    })
    
    _draft_post = create_blog_post(%{
      title: "Draft Post",
      rich_text_content: %{
        "format" => "markdown", 
        "content" => "This is a draft post that hasn't been published yet."
      },
      status: "draft",
      tags: ["draft"],
      short_id: "draft-post"
    })
    
    IO.puts("  ✓ Created blog posts")
    
    # Create comments
    create_comment(published_post, admin_user, %{
      rich_text_content: %{
        "format" => "plain",
        "content" => "Great post! Looking forward to more content."
      },
      rating: 5.0,
      tags: ["positive", "feedback"]
    })
    
    create_comment(published_post, regular_user, %{
      rich_text_content: %{
        "format" => "plain", 
        "content" => "Thanks for sharing this!"
      },
      rating: 4.5
    })
    
    IO.puts("  ✓ Created comments")
    
    # Create sample attachments
    create_sample_attachments()
    
    IO.puts("  ✓ Created sample attachments")
  end
  
  # Private helper functions
  
  defp create_blog_post(attrs) do
    case Repo.get_by(BlogPost, short_id: attrs.short_id) do
      nil ->
        %BlogPost{}
        |> BlogPost.changeset(attrs)
        |> Repo.insert!()
        
      existing ->
        existing
        |> BlogPost.changeset(attrs)
        |> Repo.update!()
    end
  end
  
  defp create_comment(commentable, user, attrs) do
    comment_attrs = Map.merge(attrs, %{
      commentable_id: commentable.id,
      commentable_type: commentable.__struct__ |> Module.split() |> List.last(),
      user_id: user.id
    })
    
    %Comment{}
    |> Comment.changeset(comment_attrs)
    |> Repo.insert!(on_conflict: :nothing)
  end
  
  defp create_sample_attachments do
    # Create some sample attachment records
    # Note: These won't have actual files, just database records
    
    # Get some real record IDs to use
    admin_user = Repo.get_by!(User, email: "admin@test.com")
    regular_user = Repo.get_by!(User, email: "user@test.com")
    blog_posts = Repo.all(BlogPost)
    blog_post = if length(blog_posts) > 0, do: List.first(blog_posts), else: nil
    
    sample_attachments = [
      %{
        name: "sample-image.jpg",
        content_type: "image/jpeg",
        record_type: "User",
        record_id: admin_user.id,
        url: "/uploads/sample-image.jpg"
      },
      %{
        name: "avatar.png",
        content_type: "image/png", 
        record_type: "User",
        record_id: regular_user.id,
        url: "/uploads/avatar.png"
      }
    ]
    
    # Add blog post attachment if blog post exists
    sample_attachments = if blog_post do
      sample_attachments ++ [%{
        name: "document.pdf", 
        content_type: "application/pdf",
        record_type: "BlogPost",
        record_id: blog_post.id,
        url: "/uploads/document.pdf"
      }]
    else
      sample_attachments
    end
    
    Enum.each(sample_attachments, fn attrs ->
      %Attachment{}
      |> Attachment.changeset(attrs)
      |> Repo.insert!(on_conflict: :nothing)
    end)
    
    # Create model attachments linking to blog posts
    blog_posts = Repo.all(BlogPost)
    attachments = Repo.all(Attachment)
    
    if length(blog_posts) > 0 and length(attachments) > 0 do
      blog_post = List.first(blog_posts)
      attachment = List.first(attachments)
      
      %ModelAttachment{
        name: "featured_image",
        owner_id: blog_post.id,
        owner_type: "BlogPost", 
        attachment_id: attachment.id
      }
      |> Repo.insert!(on_conflict: :nothing)
    end
  end
end