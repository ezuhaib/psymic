class DimensionsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    temp_file = value.queued_for_write[:original]
    return true if !temp_file #validates only if image changed
    width = options[:width]
    height = options[:height]

  # ensures validator not run if image doesn't pass paperclip's default validators
    unless record.errors.any?
      dimensions = Paperclip::Geometry.from_file(temp_file.path)
      if dimensions.width < width || dimensions.height < height
        record.errors[attribute] << "Must be atleast #{width}x#{height}px"
      end
    end
  end
end