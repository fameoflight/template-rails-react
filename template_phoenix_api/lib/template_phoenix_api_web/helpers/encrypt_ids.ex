defmodule TemplatePhoenixApiWeb.Helpers.EncryptIds do
  @moduledoc """
  Helper for encrypting and decrypting GraphQL object IDs
  """

  @separator "&"
  
  # In production, these should come from environment variables or config
  @encryption_key :crypto.hash(:sha256, "your-graphql-encryption-key") |> binary_part(0, 32)
  @encryption_iv :crypto.hash(:sha256, "your-graphql-encryption-secret") |> binary_part(0, 16)

  def encrypted_object_id(object, graphql_type) do
    parts = [
      object.__struct__ |> to_string(),
      graphql_type |> to_string(),
      object.id |> to_string()
    ]

    # Validate that parts don't contain separator
    for part <- parts do
      if String.contains?(part, @separator) do
        raise ArgumentError, "type contain #{@separator}"
      end
    end

    unique_name = Enum.join(parts, @separator)
    encrypt_and_sign(unique_name)
  end

  def object_from_encrypted_id(encrypted_id_with_hints) do
    if encrypted_id_with_hints == "" do
      nil
    else
      try do
        encoded_id_with_hint = decrypt_and_verify(encrypted_id_with_hints)
        id_parts = String.split(encoded_id_with_hint, @separator)

        [model_class_string, _graphql_class_string, item_id] = id_parts

        # Convert class string to actual module
        model_class = case model_class_string do
          "Elixir.TemplatePhoenixApi.Accounts.User" -> TemplatePhoenixApi.Accounts.User
          "Elixir.TemplatePhoenixApi.Accounts.ApiAccessToken" -> TemplatePhoenixApi.Accounts.ApiAccessToken
          "Elixir.TemplatePhoenixApi.Content.BlogPost" -> TemplatePhoenixApi.Content.BlogPost
          "Elixir.TemplatePhoenixApi.Content.Comment" -> TemplatePhoenixApi.Content.Comment
          "Elixir.TemplatePhoenixApi.Content.Attachment" -> TemplatePhoenixApi.Content.Attachment
          "Elixir.TemplatePhoenixApi.Admin.SuperUser" -> TemplatePhoenixApi.Admin.SuperUser
          "Elixir.TemplatePhoenixApi.Jobs.JobRecord" -> TemplatePhoenixApi.Jobs.JobRecord
          "Elixir.TemplatePhoenixApi.Audit.Version" -> TemplatePhoenixApi.Audit.Version
          _ -> nil
        end

        if model_class do
          case get_model_object(model_class, item_id) do
            nil -> nil
            object -> object
          end
        else
          nil
        end
      rescue
        _ -> nil
      end
    end
  end

  defp get_model_object(TemplatePhoenixApi.Accounts.User, id), do: TemplatePhoenixApi.Accounts.get_user(id)
  defp get_model_object(TemplatePhoenixApi.Accounts.ApiAccessToken, id), do: TemplatePhoenixApi.Accounts.get_api_access_token!(id)
  defp get_model_object(TemplatePhoenixApi.Content.BlogPost, id), do: TemplatePhoenixApi.Content.get_blog_post!(id)
  defp get_model_object(TemplatePhoenixApi.Content.Comment, id), do: TemplatePhoenixApi.Content.get_comment!(id)
  defp get_model_object(TemplatePhoenixApi.Content.Attachment, id), do: TemplatePhoenixApi.Content.get_attachment!(id)
  defp get_model_object(TemplatePhoenixApi.Admin.SuperUser, id), do: TemplatePhoenixApi.Admin.get_super_user!(id)
  defp get_model_object(TemplatePhoenixApi.Jobs.JobRecord, id), do: TemplatePhoenixApi.Jobs.get_job_record!(id)
  defp get_model_object(TemplatePhoenixApi.Audit.Version, id), do: TemplatePhoenixApi.Audit.get_version!(id)
  defp get_model_object(_, _), do: nil

  defp encrypt_and_sign(plain_text) do
    :crypto.crypto_one_time(:aes_256_cbc, @encryption_key, @encryption_iv, plain_text, true)
    |> Base.url_encode64(padding: false)
  end

  defp decrypt_and_verify(encrypted_text) do
    encrypted_text
    |> Base.url_decode64!(padding: false)
    |> then(&:crypto.crypto_one_time(:aes_256_cbc, @encryption_key, @encryption_iv, &1, false))
  end
end