module HasOriginVideoPrompt
  # which cartoon scene am I part of?

  extend ActiveSupport::Concern

  def origin_video_prompt
    each_video_prompt_parent_request do |req|
      video_prompt = video_prompt_for(req)
      return video_prompt if video_prompt.present?
    end

    nil
  end

  private

  def each_video_prompt_parent_request
    req = parent_request_of(self)

    while req
      yield req

      req = parent_request_of(req)
    end
  end

  def parent_request_of(req)
    req.respond_to?(:parent_request) ? req.parent_request : nil
  end

  def video_prompt_for(req)
    return unless req.is_a?(PromptMessage)

    req.video_prompt
  end
end
