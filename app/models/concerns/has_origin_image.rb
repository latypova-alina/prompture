module HasOriginImage
  extend ActiveSupport::Concern

  def origin_image_url
    each_parent_request do |req|
      return req.resolved_image_url if image_present?(req)
    end

    nil
  end

  private

  def each_parent_request
    req = parent_request_of(self)

    while req
      yield req

      req = parent_request_of(req)
    end
  end

  def parent_request_of(req)
    req.respond_to?(:parent_request) ? req.parent_request : nil
  end

  def image_present?(req)
    req.respond_to?(:resolved_image_url) && req.resolved_image_url.present?
  end
end
