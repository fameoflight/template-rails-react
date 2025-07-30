defmodule TemplatePhoenixApiWeb.Schema.Types.ExtendedMutations do
  use Absinthe.Schema.Notation

  object :extended_mutations do
    field :api_access_token_create_update, :api_access_token_create_update_payload do
      arg :input, non_null(:api_access_token_create_update_input), description: "Parameters for ApiAccessTokenCreateUpdate"
      resolve fn 
        _, %{input: input}, %{context: %{current_user: current_user}} ->
          attrs = %{
            name: input.name,
            user_id: current_user.id,
            active: input.active
          }
          
          attrs = if input.description, do: Map.put(attrs, :description, input.description), else: attrs
          attrs = if input.expires_at, do: Map.put(attrs, :expires_at, input.expires_at), else: attrs
          
          if input.object_id do
            # Update existing token
            case TemplatePhoenixApiWeb.Schema.object_from_id(input.object_id, nil) do
              %TemplatePhoenixApi.Accounts.ApiAccessToken{} = token ->
                # Check permission - users can only update their own tokens
                if token.user_id == current_user.id do
                  case TemplatePhoenixApi.Accounts.update_api_access_token(token, attrs) do
                    {:ok, updated_token} ->
                      {:ok, %{
                        api_access_token: updated_token,
                        user: current_user,
                        errors: [],
                        client_mutation_id: input[:client_mutation_id]
                      }}
                    
                    {:error, changeset} ->
                      errors = Enum.map(changeset.errors, fn {field, {message, _}} ->
                        "#{field}: #{message}"
                      end)
                      
                      {:ok, %{
                        api_access_token: nil,
                        user: current_user,
                        errors: errors,
                        client_mutation_id: input[:client_mutation_id]  
                      }}
                  end
                else
                  {:ok, %{
                    api_access_token: nil,
                    user: current_user,
                    errors: ["You don't have permission to update this token."],
                    client_mutation_id: input[:client_mutation_id]
                  }}
                end
                
              _ ->
                {:ok, %{
                  api_access_token: nil,
                  user: current_user,
                  errors: ["Token not found"],
                  client_mutation_id: input[:client_mutation_id]
                }}
            end
          else
            # Create new token
            case TemplatePhoenixApi.Accounts.create_api_access_token(attrs) do
              {:ok, new_token} ->
                {:ok, %{
                  api_access_token: new_token,
                  user: current_user,
                  errors: [],
                  client_mutation_id: input[:client_mutation_id]
                }}
              
              {:error, changeset} ->
                errors = Enum.map(changeset.errors, fn {field, {message, _}} ->
                  "#{field}: #{message}"
                end)
                
                {:ok, %{
                  api_access_token: nil,
                  user: current_user,
                  errors: errors,
                  client_mutation_id: input[:client_mutation_id]
                }}
            end
          end
          
        _, %{input: input}, _ ->
          {:ok, %{
            api_access_token: nil,
            user: nil,
            errors: ["Authentication required"],
            client_mutation_id: input[:client_mutation_id]
          }}
      end
    end

    field :comment_create_update, :comment_create_update_payload do
      arg :input, non_null(:comment_create_update_input), description: "Parameters for CommentCreateUpdate"
      resolve fn 
        _, %{input: input}, %{context: %{current_user: current_user}} ->
          attrs = %{
            user_id: current_user.id,
            rich_text_content: input.rich_text_content
          }
          
          attrs = if input.tags, do: Map.put(attrs, :tags, input.tags), else: attrs
          attrs = if input.rating, do: Map.put(attrs, :rating, input.rating), else: attrs
          attrs = if input.commentable_id, do: Map.put(attrs, :commentable_id, input.commentable_id), else: attrs
          
          if input.object_id do
            # Update existing comment
            case TemplatePhoenixApiWeb.Schema.object_from_id(input.object_id, nil) do
              %TemplatePhoenixApi.Content.Comment{} = comment ->
                # Check permission - users can only update their own comments
                if comment.user_id == current_user.id do
                  case TemplatePhoenixApi.Content.update_comment(comment, attrs) do
                    {:ok, updated_comment} ->
                      {:ok, %{
                        comment: updated_comment,
                        user: current_user,
                        errors: [],
                        client_mutation_id: input[:client_mutation_id]
                      }}
                    
                    {:error, changeset} ->
                      errors = Enum.map(changeset.errors, fn {field, {message, _}} ->
                        "#{field}: #{message}"
                      end)
                      
                      {:ok, %{
                        comment: nil,
                        user: current_user,
                        errors: errors,
                        client_mutation_id: input[:client_mutation_id]
                      }}
                  end
                else
                  {:ok, %{
                    comment: nil,
                    user: current_user,
                    errors: ["You don't have permission to update this comment."],
                    client_mutation_id: input[:client_mutation_id]
                  }}
                end
                
              _ ->
                {:ok, %{
                  comment: nil,
                  user: current_user,
                  errors: ["Comment not found"],
                  client_mutation_id: input[:client_mutation_id]
                }}
            end
          else
            # Create new comment
            case TemplatePhoenixApi.Content.create_comment(attrs) do
              {:ok, new_comment} ->
                {:ok, %{
                  comment: new_comment,
                  user: current_user,
                  errors: [],
                  client_mutation_id: input[:client_mutation_id]
                }}
              
              {:error, changeset} ->
                errors = Enum.map(changeset.errors, fn {field, {message, _}} ->
                  "#{field}: #{message}"
                end)
                
                {:ok, %{
                  comment: nil,
                  user: current_user,
                  errors: errors,
                  client_mutation_id: input[:client_mutation_id]
                }}
            end
          end
          
        _, %{input: input}, _ ->
          {:ok, %{
            comment: nil,
            user: nil,
            errors: ["Authentication required"],
            client_mutation_id: input[:client_mutation_id]
          }}
      end
    end

    field :create_direct_upload, :create_direct_upload_payload do
      arg :input, non_null(:create_direct_upload_input), description: "Parameters for CreateDirectUpload"
      resolve fn 
        _, %{input: input}, %{context: %{current_user: user}} ->
          # Validate upload parameters
          case TemplatePhoenixApi.Storage.validate_upload_params(input) do
            {:ok, _validated_params} ->
              # Add user metadata
              attrs = Map.merge(input, %{
                metadata: %{
                  user_id: user.id,
                  uploaded_by: user.email
                }
              })

              case TemplatePhoenixApi.Storage.create_blob_for_direct_upload(attrs) do
                {:ok, blob} ->
                  direct_upload = %{
                    id: blob.signed_id,
                    signed_id: blob.signed_id,
                    filename: blob.filename,
                    direct_upload_url: TemplatePhoenixApi.Storage.Blob.service_url_for_direct_upload(blob),
                    direct_upload_headers: TemplatePhoenixApi.Storage.Blob.service_headers_for_direct_upload(blob),
                    public_url: TemplatePhoenixApi.Storage.Blob.public_url(blob)
                  }
                  
                  {:ok, %{
                    direct_upload: direct_upload,
                    errors: [],
                    client_mutation_id: input[:client_mutation_id]
                  }}

                {:error, changeset} ->
                  errors = Enum.map(changeset.errors, fn {field, {message, _}} ->
                    "#{field}: #{message}"
                  end)
                  
                  {:ok, %{
                    direct_upload: nil,
                    errors: errors,
                    client_mutation_id: input[:client_mutation_id]
                  }}
              end

            {:error, errors} ->
              {:ok, %{
                direct_upload: nil,
                errors: errors,
                client_mutation_id: input[:client_mutation_id]
              }}
          end
        
        _, %{input: input}, _ ->
          {:ok, %{
            direct_upload: nil,
            errors: ["Authentication required"],
            client_mutation_id: input[:client_mutation_id]
          }}
      end
    end

    field :destroy_object, :destroy_object_payload do
      arg :input, non_null(:destroy_object_input), description: "Parameters for DestroyObject"
      resolve fn 
        _, %{input: input}, %{context: %{current_user: current_user}} ->
          case TemplatePhoenixApiWeb.Schema.object_from_id(input.object_id, nil) do
            %TemplatePhoenixApi.Content.Comment{} = comment ->
              if comment.user_id == current_user.id do
                case TemplatePhoenixApi.Content.delete_comment(comment) do
                  {:ok, _} ->
                    {:ok, %{
                      errors: [],
                      client_mutation_id: input[:client_mutation_id]
                    }}
                  {:error, _} ->
                    {:ok, %{
                      errors: ["Failed to delete comment"],
                      client_mutation_id: input[:client_mutation_id]
                    }}
                end
              else
                {:ok, %{
                  errors: ["You don't have permission to delete this object."],
                  client_mutation_id: input[:client_mutation_id]
                }}
              end
              
            %TemplatePhoenixApi.Accounts.ApiAccessToken{} = token ->
              if token.user_id == current_user.id do
                case TemplatePhoenixApi.Accounts.delete_api_access_token(token) do
                  {:ok, _} ->
                    {:ok, %{
                      errors: [],
                      client_mutation_id: input[:client_mutation_id]
                    }}
                  {:error, _} ->
                    {:ok, %{
                      errors: ["Failed to delete token"],
                      client_mutation_id: input[:client_mutation_id]
                    }}
                end
              else
                {:ok, %{
                  errors: ["You don't have permission to delete this object."],
                  client_mutation_id: input[:client_mutation_id]
                }}
              end
              
            _ ->
              {:ok, %{
                errors: ["Object not found or not supported for deletion"],
                client_mutation_id: input[:client_mutation_id]
              }}
          end
          
        _, %{input: input}, _ ->
          {:ok, %{
            errors: ["Authentication required"],
            client_mutation_id: input[:client_mutation_id]
          }}
      end
    end

    field :discard_object, :discard_object_payload do
      arg :input, non_null(:discard_object_input), description: "Parameters for DiscardObject"
      resolve fn 
        _, %{input: input}, %{context: %{current_user: current_user}} ->
          case TemplatePhoenixApiWeb.Schema.object_from_id(input.object_id, nil) do
            %TemplatePhoenixApi.Content.Comment{} = comment ->
              if comment.user_id == current_user.id do
                case TemplatePhoenixApi.Content.discard_comment(comment) do
                  {:ok, _} ->
                    {:ok, %{
                      errors: [],
                      client_mutation_id: input[:client_mutation_id]
                    }}
                  {:error, _} ->
                    {:ok, %{
                      errors: ["Failed to discard comment"],
                      client_mutation_id: input[:client_mutation_id]
                    }}
                end
              else
                {:ok, %{
                  errors: ["You don't have permission to discard this object."],
                  client_mutation_id: input[:client_mutation_id]
                }}
              end
              
            _ ->
              {:ok, %{
                errors: ["Object not found or not supported for discard"],
                client_mutation_id: input[:client_mutation_id]
              }}
          end
          
        _, %{input: input}, _ ->
          {:ok, %{
            errors: ["Authentication required"],
            client_mutation_id: input[:client_mutation_id]
          }}
      end
    end

    field :model_attachment_create_update, :model_attachment_create_update_payload do
      arg :input, non_null(:model_attachment_create_update_input), description: "Parameters for ModelAttachmentCreateUpdate"
      resolve fn 
        _, %{input: input}, %{context: %{current_user: current_user}} ->
          # Get the owner object to attach to
          case TemplatePhoenixApiWeb.Schema.object_from_id(input.owner_id, nil) do
            owner_object when not is_nil(owner_object) ->
              attrs = %{
                name: input.name,
                record_id: input.owner_id,
                record_type: owner_object.__struct__ |> to_string() |> String.replace("Elixir.", "")
              }
              
              # Handle attachment_signed_id if provided
              attrs = if input.attachment_signed_id do
                case TemplatePhoenixApi.Storage.get_blob_by_signed_id(input.attachment_signed_id) do
                  nil -> attrs
                  blob -> Map.put(attrs, :blob_id, blob.id)
                end
              else
                attrs
              end
              
              if input.object_id do
                # Update existing attachment
                case TemplatePhoenixApiWeb.Schema.object_from_id(input.object_id, nil) do
                  %TemplatePhoenixApi.Content.Attachment{} = attachment ->
                    # Check if user owns the parent object (simplified permission check)
                    case TemplatePhoenixApi.Content.update_attachment(attachment, attrs) do
                      {:ok, updated_attachment} ->
                        {:ok, %{
                          model_attachment: updated_attachment,
                          user: current_user,
                          errors: [],
                          client_mutation_id: input[:client_mutation_id]
                        }}
                      
                      {:error, changeset} ->
                        errors = Enum.map(changeset.errors, fn {field, {message, _}} ->
                          "#{field}: #{message}"
                        end)
                        
                        {:ok, %{
                          model_attachment: nil,
                          user: current_user,
                          errors: errors,
                          client_mutation_id: input[:client_mutation_id]
                        }}
                    end
                    
                  _ ->
                    {:ok, %{
                      model_attachment: nil,
                      user: current_user,
                      errors: ["Attachment not found"],
                      client_mutation_id: input[:client_mutation_id]
                    }}
                end
              else
                # Create new attachment
                case TemplatePhoenixApi.Content.create_attachment(attrs) do
                  {:ok, new_attachment} ->
                    {:ok, %{
                      model_attachment: new_attachment,
                      user: current_user,
                      errors: [],
                      client_mutation_id: input[:client_mutation_id]
                    }}
                  
                  {:error, changeset} ->
                    errors = Enum.map(changeset.errors, fn {field, {message, _}} ->
                      "#{field}: #{message}"
                    end)
                    
                    {:ok, %{
                      model_attachment: nil,
                      user: current_user,
                      errors: errors,
                      client_mutation_id: input[:client_mutation_id]
                    }}
                end
              end
              
            _ ->
              {:ok, %{
                model_attachment: nil,
                user: current_user,
                errors: ["Owner object not found"],
                client_mutation_id: input[:client_mutation_id]
              }}
          end
          
        _, %{input: input}, _ ->
          {:ok, %{
            model_attachment: nil,
            user: nil,
            errors: ["Authentication required"],
            client_mutation_id: input[:client_mutation_id]
          }}
      end
    end

    field :super_user_update, :super_user_update_payload do
      arg :input, non_null(:super_user_update_input), description: "Parameters for SuperUserUpdate"
      resolve fn 
        _, %{input: input}, %{context: %{current_user: current_user}} ->
          # This is for user spoofing functionality - only super users can do this
          # For now, we'll implement a basic version
          case TemplatePhoenixApiWeb.Schema.object_from_id(input.object_id, nil) do
            %TemplatePhoenixApi.Admin.SuperUser{} = super_user ->
              # TODO: Check if current_user is actually a super user
              # For now, just update the spoof_id
              attrs = %{}
              attrs = if input.spoof_id, do: Map.put(attrs, :spoof_id, input.spoof_id), else: attrs
              
              case TemplatePhoenixApi.Admin.update_super_user(super_user, attrs) do
                {:ok, _updated_super_user} ->
                  # If spoofing a user, return that user instead
                  user_to_return = if input.spoof_id do
                    case TemplatePhoenixApiWeb.Schema.object_from_id(input.spoof_id, nil) do
                      %TemplatePhoenixApi.Accounts.User{} = spoofed_user -> spoofed_user
                      _ -> current_user
                    end
                  else
                    current_user
                  end
                  
                  {:ok, %{
                    user: user_to_return,
                    errors: [],
                    client_mutation_id: input[:client_mutation_id]
                  }}
                
                {:error, changeset} ->
                  errors = Enum.map(changeset.errors, fn {field, {message, _}} ->
                    "#{field}: #{message}"
                  end)
                  
                  {:ok, %{
                    user: current_user,
                    errors: errors,
                    client_mutation_id: input[:client_mutation_id]
                  }}
              end
              
            _ ->
              {:ok, %{
                user: current_user,
                errors: ["Super user not found"],
                client_mutation_id: input[:client_mutation_id]
              }}
          end
          
        _, %{input: input}, _ ->
          {:ok, %{
            user: nil,
            errors: ["Authentication required"],
            client_mutation_id: input[:client_mutation_id]
          }}
      end
    end

    field :user_otp_update, :user_otp_update_payload do
      arg :input, non_null(:user_otp_update_input), description: "Parameters for UserOtpUpdate"
      resolve fn 
        _, %{input: input}, %{context: %{current_user: current_user}} ->
          # Get the user to update from object_id
          case TemplatePhoenixApiWeb.Schema.object_from_id(input.object_id, nil) do
            %TemplatePhoenixApi.Accounts.User{} = user ->
              # Check permission - users can only update themselves
              if user.id == current_user.id do
                case TemplatePhoenixApi.Accounts.verify_otp_setup(user, input.otp_code1, input.otp_code2, input.otp_key) do
                  {:ok, updated_user} ->
                    {:ok, %{
                      user: updated_user,
                      errors: [],
                      client_mutation_id: input[:client_mutation_id]
                    }}
                  
                  {:error, errors} when is_list(errors) ->
                    {:ok, %{
                      user: nil,
                      errors: errors,
                      client_mutation_id: input[:client_mutation_id]
                    }}
                    
                  {:error, changeset} ->
                    errors = Enum.map(changeset.errors, fn {field, {message, _}} ->
                      "#{field}: #{message}"
                    end)
                    
                    {:ok, %{
                      user: nil,
                      errors: errors,
                      client_mutation_id: input[:client_mutation_id]
                    }}
                end
              else
                {:ok, %{
                  user: nil,
                  errors: ["You don't have permission to update this user."],
                  client_mutation_id: input[:client_mutation_id]
                }}
              end
              
            _ ->
              {:ok, %{
                user: nil,
                errors: ["User not found"],
                client_mutation_id: input[:client_mutation_id]
              }}
          end
          
        _, %{input: input}, _ ->
          {:ok, %{
            user: nil,
            errors: ["Authentication required"],
            client_mutation_id: input[:client_mutation_id]
          }}
      end
    end

    field :user_update, :user_update_payload do
      arg :input, non_null(:user_update_input), description: "Parameters for UserUpdate"
      resolve fn 
        _, %{input: input}, %{context: %{current_user: current_user}} ->
          # Get the user to update from object_id
          case TemplatePhoenixApiWeb.Schema.object_from_id(input.object_id, nil) do
            %TemplatePhoenixApi.Accounts.User{} = user ->
              # Check permission - users can only update themselves
              if user.id == current_user.id do
                attrs = %{}
                attrs = if Map.has_key?(input, :name) && input.name, do: Map.put(attrs, :name, input.name), else: attrs
                attrs = if Map.has_key?(input, :nickname) && input.nickname, do: Map.put(attrs, :nickname, input.nickname), else: attrs
                
                case TemplatePhoenixApi.Accounts.update_user(user, attrs) do
                  {:ok, updated_user} ->
                    {:ok, %{
                      user: updated_user,
                      errors: [],
                      client_mutation_id: input[:client_mutation_id]
                    }}
                  
                  {:error, changeset} ->
                    errors = Enum.map(changeset.errors, fn {field, {message, _}} ->
                      "#{field}: #{message}"
                    end)
                    
                    {:ok, %{
                      user: nil,
                      errors: errors,
                      client_mutation_id: input[:client_mutation_id]
                    }}
                end
              else
                {:ok, %{
                  user: nil,
                  errors: ["You don't have permission to update this user."],
                  client_mutation_id: input[:client_mutation_id]
                }}
              end
              
            _ ->
              {:ok, %{
                user: nil,
                errors: ["User not found"],
                client_mutation_id: input[:client_mutation_id]
              }}
          end
          
        _, %{input: input}, _ ->
          {:ok, %{
            user: nil,
            errors: ["Authentication required"],
            client_mutation_id: input[:client_mutation_id]
          }}
      end
    end

    import_fields :message_create_mutation
  end

  # Input types for mutations
  input_object :api_access_token_create_update_input do
    @desc "Autogenerated input type of ApiAccessTokenCreateUpdate"
    field :client_mutation_id, :string, description: "A unique identifier for the client performing the mutation."
    field :name, non_null(:string)
    field :description, :string, default_value: nil
    field :active, non_null(:boolean)
    field :expires_at, :iso8601_datetime, default_value: nil
    field :object_id, :id
  end

  input_object :comment_create_update_input do
    @desc "Autogenerated input type of CommentCreateUpdate"
    field :client_mutation_id, :string, description: "A unique identifier for the client performing the mutation."
    field :tags, list_of(non_null(:string)), default_value: nil
    field :rating, :float, default_value: nil
    field :object_id, :id
    field :rich_text_content, non_null(:store_json_input)
    field :commentable_id, :id
    field :attachment_signed_id, :string, description: "Signed blob ID generated via `createDirectUpload` mutation"
  end

  input_object :create_direct_upload_input do
    @desc "Autogenerated input type of CreateDirectUpload"
    field :client_mutation_id, :string, description: "A unique identifier for the client performing the mutation."
    field :byte_size, non_null(:integer)
    field :checksum, non_null(:string)
    field :content_type, non_null(:string)
    field :filename, non_null(:string)
  end

  input_object :destroy_object_input do
    @desc "Autogenerated input type of DestroyObject"
    field :client_mutation_id, :string, description: "A unique identifier for the client performing the mutation."
    field :object_id, non_null(:id)
  end

  input_object :discard_object_input do
    @desc "Autogenerated input type of DiscardObject"
    field :client_mutation_id, :string, description: "A unique identifier for the client performing the mutation."
    field :object_id, non_null(:id)
  end

  input_object :model_attachment_create_update_input do
    @desc "Autogenerated input type of ModelAttachmentCreateUpdate"
    field :client_mutation_id, :string, description: "A unique identifier for the client performing the mutation."
    field :name, non_null(:string)
    field :object_id, :id
    field :owner_id, non_null(:id)
    field :attachment_signed_id, :string, description: "Signed blob ID generated via `createDirectUpload` mutation"
  end

  input_object :super_user_update_input do
    @desc "Autogenerated input type of SuperUserUpdate"
    field :client_mutation_id, :string, description: "A unique identifier for the client performing the mutation."
    field :object_id, :id
    field :spoof_id, :id
  end

  input_object :user_otp_update_input do
    @desc "Autogenerated input type of UserOtpUpdate"
    field :client_mutation_id, :string, description: "A unique identifier for the client performing the mutation."
    field :object_id, non_null(:id)
    field :otp_code1, non_null(:string)
    field :otp_code2, non_null(:string)
    field :otp_key, non_null(:string)
  end

  input_object :user_update_input do
    @desc "Autogenerated input type of UserUpdate"
    field :client_mutation_id, :string, description: "A unique identifier for the client performing the mutation."
    field :name, :string, default_value: nil
    field :nickname, :string, default_value: nil
    field :object_id, non_null(:id)
    field :avatar_signed_id, :string, description: "Signed blob ID generated via `createDirectUpload` mutation"
    field :send_confirmation_instructions, :boolean
  end

  # Payload types for mutations
  object :api_access_token_create_update_payload do
    @desc "Autogenerated return type of ApiAccessTokenCreateUpdate."
    field :api_access_token, :api_access_token
    field :client_mutation_id, :string, description: "A unique identifier for the client performing the mutation."
    field :errors, non_null(list_of(non_null(:string)))
    field :user, :user
  end

  object :comment_create_update_payload do
    @desc "Autogenerated return type of CommentCreateUpdate."
    field :client_mutation_id, :string, description: "A unique identifier for the client performing the mutation."
    field :comment, :comment
    field :errors, non_null(list_of(non_null(:string)))
    field :user, :user
  end

  object :create_direct_upload_payload do
    @desc "Autogenerated return type of CreateDirectUpload."
    field :client_mutation_id, :string, description: "A unique identifier for the client performing the mutation."
    field :direct_upload, :direct_upload
    field :errors, non_null(list_of(non_null(:string)))
  end

  object :destroy_object_payload do
    @desc "Autogenerated return type of DestroyObject."
    field :client_mutation_id, :string, description: "A unique identifier for the client performing the mutation."
    field :errors, non_null(list_of(non_null(:string)))
  end

  object :discard_object_payload do
    @desc "Autogenerated return type of DiscardObject."
    field :client_mutation_id, :string, description: "A unique identifier for the client performing the mutation."
    field :errors, non_null(list_of(non_null(:string)))
  end

  object :model_attachment_create_update_payload do
    @desc "Autogenerated return type of ModelAttachmentCreateUpdate."
    field :client_mutation_id, :string, description: "A unique identifier for the client performing the mutation."
    field :errors, non_null(list_of(non_null(:string)))
    field :model_attachment, :model_attachment
    field :user, :user
  end

  object :super_user_update_payload do
    @desc "Autogenerated return type of SuperUserUpdate."
    field :client_mutation_id, :string, description: "A unique identifier for the client performing the mutation."
    field :errors, non_null(list_of(non_null(:string)))
    field :user, :user
  end

  object :user_otp_update_payload do
    @desc "Autogenerated return type of UserOtpUpdate."
    field :client_mutation_id, :string, description: "A unique identifier for the client performing the mutation."
    field :errors, non_null(list_of(non_null(:string)))
    field :user, :user
  end

  object :user_update_payload do
    @desc "Autogenerated return type of UserUpdate."
    field :client_mutation_id, :string, description: "A unique identifier for the client performing the mutation."
    field :errors, non_null(list_of(non_null(:string)))
    field :user, :user
  end

  object :direct_upload do
    field :direct_upload_headers, non_null(:json)
    field :direct_upload_url, non_null(:string)
    field :filename, non_null(:string)
    field :id, non_null(:string)
    field :public_url, non_null(:string)
    field :signed_id, non_null(:string)
  end

  object :model_attachment do
    interface :model_interface
    interface :node
    
    field :id, non_null(:id)
    field :model_id, non_null(:integer)
    field :created_at, non_null(:iso8601_datetime)
    field :updated_at, non_null(:iso8601_datetime)
    
    field :attachment, :attachment
    field :name, non_null(:string)
  end
end