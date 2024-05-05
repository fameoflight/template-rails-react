# frozen_string_literal: true

module ModelTextProcessing
  def auto_strip(*attributes)
    setup_attribute_processing(*attributes) do |value|
      value.try(:squish) || value
    end
  end

  def auto_lowercase(*attributes)
    setup_attribute_processing(*attributes) do |value|
      value.try(:downcase) || value
    end
  end

  private

  def setup_attribute_processing(*attributes)
    options = {}

    options = options.merge(attributes.pop) if attributes.last.is_a?(Hash)

    # option `:virtual` is needed because we want to guarantee that
    # getter/setter methods for an attribute will _not_ be invoked by default
    virtual = options.delete(:virtual)

    attributes.each do |attribute|
      before_validation(options) do |record|
        value = if virtual
                  record.public_send(attribute)
                else
                  record[attribute]
                end

        value = yield(value)

        if virtual
          record.public_send(:"#{attribute}=", value)
        else
          record[attribute] = value
        end
      end
    end
  end
end
