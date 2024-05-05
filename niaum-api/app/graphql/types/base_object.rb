# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::BaseConnection)
    field_class Types::BaseField

    include Helpers::ActiveStorage

    extend Helpers::EnumHelpers
    include Helpers::Authorization

    def load_record(model_klass, id_or_ids)
      loader_instance = dataloader.with(RecordSource, model_klass)

      if id_or_ids.is_a?(Array)
        loader_instance.load_all(id_or_ids)
      else
        loader_instance.load(id_or_ids)
      end
    end

    def self.loader_field(name, graphql_name, **)
      assert graphql_name < Types::BaseModelObject, 'loader_field must be a BaseModelObject' unless graphql_name.is_a?(String)

      field(name, graphql_name, **)

      define_method(name) do
        graphql_klazz = graphql_name

        graphql_klazz = graphql_klazz.constantize if graphql_klazz.is_a?(String)

        load_record(graphql_klazz.model, object.send(:"#{name}_id"))
      end
    end

    def self.passthrough_field(name, graphql_klazz, **)
      field(name, graphql_klazz, **)

      define_method(name) do
        name # some truthy value
      end
    end

    def self.icon_field(name, **kwargs)
      # maximum 1 week allowed by active storage
      expires_in = kwargs.delete(:expires_in) || 1.day

      field name, Types::Model::AttachmentType, null: true

      field "#{name}_url", String, **kwargs

      define_method(:"#{name}_url") do
        service_url(object.send(name), expires_in:) || object.try("#{name}_url")
      end
    end
  end
end
