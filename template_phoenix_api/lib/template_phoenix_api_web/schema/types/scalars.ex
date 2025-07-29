defmodule TemplatePhoenixApiWeb.Schema.Types.Scalars do
  use Absinthe.Schema.Notation

  @desc "An ISO 8601-encoded datetime"
  scalar :iso8601_datetime, name: "ISO8601DateTime" do
    serialize(&DateTime.to_iso8601/1)
    parse(&parse_datetime/1)
  end

  @desc "Represents untyped JSON"
  scalar :json, name: "JSON" do
    serialize(&Jason.encode!/1)
    parse(&parse_json/1)
  end

  @desc "Untyped JSON Input used for Store Model"
  scalar :store_json_input, name: "StoreJsonInput" do
    serialize(&Jason.encode!/1)
    parse(&parse_json/1)
  end

  defp parse_datetime(%Absinthe.Blueprint.Input.String{value: value}) do
    case DateTime.from_iso8601(value) do
      {:ok, datetime, _offset} -> {:ok, datetime}
      {:error, _} -> :error
    end
  end

  defp parse_datetime(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end

  defp parse_datetime(_), do: :error

  defp parse_json(%Absinthe.Blueprint.Input.String{value: value}) do
    case Jason.decode(value) do
      {:ok, result} -> {:ok, result}
      {:error, _} -> :error
    end
  end

  defp parse_json(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end

  defp parse_json(value), do: {:ok, value}
end