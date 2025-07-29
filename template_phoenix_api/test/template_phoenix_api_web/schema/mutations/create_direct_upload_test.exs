defmodule TemplatePhoenixApiWeb.Schema.Mutations.CreateDirectUploadTest do
  use TemplatePhoenixApi.DataCase
  import TemplatePhoenixApi.Factory

  describe "createDirectUpload mutation" do
    @valid_file_params %{
      filename: "test_image.png",
      content_type: "image/png",
      byte_size: 1024,
      checksum: "abc123def456"
    }

    test "requires authentication" do
      query = """
      mutation CreateDirectUpload($input: CreateDirectUploadInput!) {
        createDirectUpload(input: $input) {
          directUpload {
            id
            signedId
            directUploadUrl
            publicUrl
          }
          errors
        }
      }
      """

      variables = %{
        input: @valid_file_params
      }

      assert {:ok, result} = graphql_execute(query, variables)
      assert result["createDirectUpload"]["directUpload"] == nil
      assert "Authentication required" in result["createDirectUpload"]["errors"]
    end

    test "creates direct upload with valid parameters" do
      user = insert(:user)

      query = """
      mutation CreateDirectUpload($input: CreateDirectUploadInput!) {
        createDirectUpload(input: $input) {
          directUpload {
            id
            signedId
            filename
            directUploadUrl
            publicUrl
          }
          errors
        }
      }
      """

      variables = %{
        input: @valid_file_params
      }

      assert {:ok, result} = graphql_execute_with_user(query, variables, user)
      
      direct_upload = result["createDirectUpload"]["directUpload"]
      assert direct_upload != nil
      assert direct_upload["id"] != nil
      assert direct_upload["signedId"] != nil
      assert direct_upload["filename"] == "test_image.png"
      assert direct_upload["directUploadUrl"] != nil
      assert direct_upload["publicUrl"] != nil
      assert result["createDirectUpload"]["errors"] == []
    end

    test "validates file size limit" do
      user = insert(:user)

      query = """
      mutation CreateDirectUpload($input: CreateDirectUploadInput!) {
        createDirectUpload(input: $input) {
          directUpload {
            id
          }
          errors
        }
      }
      """

      # File size too large (50MB + 1)
      large_file_params = Map.put(@valid_file_params, :byte_size, 50 * 1024 * 1024 + 1)

      variables = %{
        input: large_file_params
      }

      assert {:ok, result} = graphql_execute_with_user(query, variables, user)
      
      assert result["createDirectUpload"]["directUpload"] == nil
      assert "File size is too large" in result["createDirectUpload"]["errors"]
    end

    test "validates file type" do
      user = insert(:user)

      query = """
      mutation CreateDirectUpload($input: CreateDirectUploadInput!) {
        createDirectUpload(input: $input) {
          directUpload {
            id
          }
          errors
        }
      }
      """

      # Unsupported file type
      invalid_file_params = Map.put(@valid_file_params, :content_type, "application/x-executable")

      variables = %{
        input: invalid_file_params
      }

      assert {:ok, result} = graphql_execute_with_user(query, variables, user)
      
      assert result["createDirectUpload"]["directUpload"] == nil
      assert "File type is not allowed" in result["createDirectUpload"]["errors"]
    end

    test "validates required parameters" do
      user = insert(:user)

      query = """
      mutation CreateDirectUpload($input: CreateDirectUploadInput!) {
        createDirectUpload(input: $input) {
          directUpload {
            id
          }
          errors
        }
      }
      """

      # Test with zero byte size (invalid)
      invalid_params = Map.put(@valid_file_params, :byte_size, 0)

      variables = %{
        input: invalid_params
      }

      assert {:ok, result} = graphql_execute_with_user(query, variables, user)
      
      assert result["createDirectUpload"]["directUpload"] == nil
      assert length(result["createDirectUpload"]["errors"]) > 0
    end

    test "stores user metadata" do
      user = insert(:user, email: "test@example.com")

      query = """
      mutation CreateDirectUpload($input: CreateDirectUploadInput!) {
        createDirectUpload(input: $input) {
          directUpload {
            id
            signedId
          }
          errors
        }
      }
      """

      variables = %{
        input: @valid_file_params
      }

      assert {:ok, result} = graphql_execute_with_user(query, variables, user)
      
      direct_upload = result["createDirectUpload"]["directUpload"]
      assert direct_upload != nil

      # Verify blob was created with user metadata
      blob = TemplatePhoenixApi.Storage.get_blob_by_signed_id(direct_upload["signedId"])
      assert blob != nil
      assert blob.metadata["user_id"] == user.id
      assert blob.metadata["uploaded_by"] == "test@example.com"
    end
  end
end