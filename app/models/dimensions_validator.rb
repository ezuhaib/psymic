class DimensionsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return true if !value.queued_for_write[:original] #validates only if image changed
    dimensions = Paperclip::Geometry.from_file(value.queued_for_write[:original].path)
    width = options[:width]
    height = options[:height]

    if dimensions.width < 50 && dimensions.height < 50
      record.errors[attribute] << "Must be atleast #{width}x#{height}px"
    end
  end
end