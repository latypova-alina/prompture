module HasOriginPrompt
  extend ActiveSupport::Concern

  def parent_prompt
    respond_to?(:prompt) ? prompt : origin_prompt
  end

  private

  def origin_prompt
    each_parent_request do |req|
      return req.prompt if prompt_present?(req)
    end

    nil
  end

  def each_parent_request
    req = self

    while req
      yield req

      req = parent_request_of(req)
    end
  end

  def parent_request_of(req)
    req.respond_to?(:parent_request) ? req.parent_request : nil
  end

  def prompt_present?(req)
    req.respond_to?(:prompt) && req.prompt.present?
  end
end
