defmodule TemplatePhoenixApi.GraphqlHelpers do
  def graphql_execute(query, variables \\ %{}, context \\ %{}) do
    # Convert atom keys to string keys for variables
    variables = convert_keys_to_strings(variables)
    
    case Absinthe.run(query, TemplatePhoenixApiWeb.Schema, 
      variables: variables, 
      context: context
    ) do
      {:ok, %{data: data, errors: nil}} -> {:ok, data}
      {:ok, %{data: data, errors: []}} -> {:ok, data}
      {:ok, %{data: _data, errors: errors}} -> {:error, errors}
      {:ok, %{errors: errors}} -> {:error, errors}
      {:ok, result} -> {:ok, result[:data] || result["data"]}
      error -> error
    end
  end

  def graphql_execute_with_user(query, variables \\ %{}, user) do
    context = %{current_user: user}
    graphql_execute(query, variables, context)
  end

  def extract_result(result) do
    case result do
      {:ok, %{data: data}} -> {:ok, data}
      {:ok, %{errors: errors}} -> {:error, errors}
      error -> error
    end
  end

  # Convert nested map keys to strings for GraphQL variables
  defp convert_keys_to_strings(map) when is_map(map) do
    map
    |> Enum.map(fn {key, value} ->
      {to_string(key), convert_keys_to_strings(value)}
    end)
    |> Enum.into(%{})
  end
  
  defp convert_keys_to_strings(list) when is_list(list) do
    Enum.map(list, &convert_keys_to_strings/1)
  end
  
  defp convert_keys_to_strings(value), do: value
end