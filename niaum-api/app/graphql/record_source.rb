# frozen_string_literal: true

class RecordSource < GraphQL::Dataloader::Source
  def initialize(model_class)
    @model_class = model_class

    super()
  end

  def fetch(ids)
    records = @model_class.where(id: ids).to_a
    # return a list with `nil` for any ID that wasn't found
    ids.map { |id| records.find { |r| r.id == id.to_i } }
  end
end
