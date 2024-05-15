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

    result = RateBeezApiSchema.execute(
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
    RateBeezApiSchema.id_from_object(object, type, context)
  end
end
