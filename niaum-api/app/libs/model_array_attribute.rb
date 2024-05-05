# frozen_string_literal: true

module ModelArrayAttribute
  # -- public interface --- #
  def model_array(name, model_class:)
    define_method(:"#{name}s") do
      object_ids = send(:"#{name}_ids")

      object_ids.nil? ? nil : model_class.where(id: object_ids)
    end

    define_method(:"#{name}s=") do |objects|
      self["#{name}_ids"] = self.class.object_ids!(objects, model_class)
    end

    define_method(:"#{name}_ids=") do |object_ids|
      objects = model_class.where(id: object_ids).to_a unless object_ids.nil?

      super(self.class.object_ids!(objects, model_class))
    end

    validate :"validate_#{name}s"

    define_method(:"validate_#{name}s") do
      return if send(:"#{name}_ids").nil?

      # ids are unique
      ids = send(:"#{name}_ids")

      errors.add(name, 'must be unique') if ids.nil? || ids.uniq.size != ids.size
    end
  end

  def object_ids!(objects, model_class)
    return nil if objects.nil?

    return [] if objects.empty?

    raise TypeError, 'objects must be an array' unless objects.is_a?(Array)

    object_classes = objects.map(&:class).uniq

    assert object_classes.size == 1

    raise TypeError, "objects must be of type #{model_class}" unless objects.first.is_a?(model_class)

    objects.map(&:id)
  end
end
