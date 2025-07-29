defmodule TemplatePhoenixApiWeb.Schema.Types.Auth do
  use Absinthe.Schema.Notation
  alias TemplatePhoenixApi.{Accounts, Guardian}

  input_object :register_input do
    field :email, non_null(:string)
    field :name, non_null(:string)
    field :password, non_null(:string)
    field :nickname, :string
  end

  input_object :login_input do
    field :email, non_null(:string)
    field :password, non_null(:string)
  end

  object :auth_payload do
    field :user, non_null(:user)
    field :token, non_null(:string)
  end

  object :auth_queries do
    field :env, non_null(:string) do
      resolve fn _, _, _ ->
        {:ok, to_string(Mix.env())}
      end
    end
  end

  object :auth_mutations do
    field :register, :auth_payload do
      arg :input, non_null(:register_input)

      resolve fn _, %{input: input}, _ ->
        case Accounts.create_user(input) do
          {:ok, user} ->
            {:ok, user, token} = Guardian.create_token(user)
            {:ok, %{user: user, token: token}}

          {:error, changeset} ->
            errors = Enum.map(changeset.errors, fn {field, {message, _}} ->
              "#{field}: #{message}"
            end)
            {:error, errors}
        end
      end
    end

    field :login, :auth_payload do
      arg :input, non_null(:login_input)

      resolve fn _, %{input: %{email: email, password: password}}, _ ->
        case Guardian.authenticate(email, password) do
          {:ok, user, token} ->
            {:ok, %{user: user, token: token}}

          {:error, :unauthorized} ->
            {:error, "Invalid email or password"}
        end
      end
    end
  end
end