module OriginImageUrl
  module_function

  def resolve(record)
    return if record.blank?

    record = record.reload if record.is_a?(ActiveRecord::Base)

    direct_image_url(record) || ancestor_image_url(record)
  end

  def direct_image_url(record)
    return unless record.respond_to?(:resolved_image_url)

    record.resolved_image_url.presence
  end

  def ancestor_image_url(record)
    return unless record.respond_to?(:origin_image_url)

    record.origin_image_url.presence
  end
end
