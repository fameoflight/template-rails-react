# frozen_string_literal: true

module GraphqlSpecHelpers
  def graphql_execute(query, **kwargs)
    logging = kwargs[:logging].nil? ? true : kwargs.delete(:logging)

    variables = kwargs[:variables]

    user = kwargs[:user]

    context = kwargs[:context] || {}

    context = context.merge(
      {
        ip: '::test',
        host: 'http://localhost:5001',
        user_context: UserContext.new(user)
      }
    )

    result = TemplateApiSchema.execute(
      query,
      variables:,
      context:
    )

    resp = result.to_h

    if logging
      (resp['errors'] || []).each do |error|
        log "GraphQL Error: #{error['message']}", color: :red
      end
    end

    resp
  end

  def graphql_execute_mutation(mutation, **kwargs)
    logging = kwargs[:logging].nil? ? true : kwargs[:logging]

    mutation_name = mutation.to_s
    query = kwargs.delete(:query).to_s

    namespace = kwargs.delete(:namespace)

    mutation_query = "
      #{mutation_name}(input:$input) {
        clientMutationId
        #{query}
      }
    "

    input_name = "#{mutation_name.classify}Input"

    if namespace
      mutation_query = "#{namespace} { #{mutation_query} }"

      input_name = "#{namespace.classify}#{mutation_name.classify}Input"
    end

    query = "
      mutation #{mutation_name}Mutation($input:#{input_name}!) {
        #{mutation_query}
      }
    "

    resp = graphql_execute(query, **kwargs)

    object = nil

    if resp['data']
      object = namespace ? resp['data'][namespace][mutation_name] : resp['data'][mutation_name]
    end

    {
      errors: resp['errors'],
      object:
    }.with_indifferent_access
  end

  def graphql_id(object, type, context: nil)
    TemplateApiSchema.id_from_object(object, type, context)
  end

  def upload_file_fixture(fixture_name, **kwargs)
    user = kwargs[:user]

    fixture = if fixture_name.is_a?(String)
                fixture_file_upload(fixture_name)
              else
                fixture_name
              end

    extension = File.extname(fixture.original_filename).delete('.')

    extension_content_type = {
      'png' => 'image/png',
      'jpg' => 'image/jpeg',
      'jpeg' => 'image/jpeg',
      'gif' => 'image/gif',
      'pdf' => 'application/pdf',
      'doc' => 'application/msword',
      'docx' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'xls' => 'application/vnd.ms-excel',
      'xlsx' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'ppt' => 'application/vnd.ms-powerpoint',
      'pptx' => 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
      'txt' => 'text/plain',
      'rtf' => 'application/rtf'
    }

    variables = {
      input: {
        filename: fixture.original_filename,
        contentType: extension_content_type[extension],
        byteSize: File.size(fixture.path),
        checksum: Digest::MD5.base64digest(File.read(fixture.path))
      }
    }

    query = 'directUpload { id, signedId, directUploadUrl, publicUrl }'

    graphql_execute_mutation('createDirectUpload', variables:, query:, user:)
  end
end
