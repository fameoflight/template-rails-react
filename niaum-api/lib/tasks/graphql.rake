# frozen_string_literal: true

require 'deepsort' if Rails.env.development?

class SchemaHelpers
  def self.execute_introspection_query
    json = JSON.parse(NiaumApiSchema.execute(GraphQL::Introspection::INTROSPECTION_QUERY).to_json)
    JSON.pretty_generate(json)
  end

  def self.dump_schema(schema_path)
    introspection_query = SchemaHelpers.execute_introspection_query

    File.write(schema_path, introspection_query)

    puts "Writing schema to #{schema_path}"
  end
end

namespace :graphql do
  namespace :schema do
    project_name = Rails.root.split[-1].to_s.split('-')[0]

    schema_dirs = [
      Rails.root.join('data'), # main folder
      Rails.root.join('..', "#{project_name}-web", 'data') # webapp folder
    ].freeze

    desc 'Write or Update graphql schema'
    task dump: :environment do
      schema_dirs.each do |schema_dir|
        FileUtils.mkdir_p schema_dir
        schema_path = File.join(schema_dir, 'schema.json')
        SchemaHelpers.dump_schema schema_path
      end
    end
  end
end
