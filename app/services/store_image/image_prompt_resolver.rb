module StoreImage
  class ImagePromptResolver
    def self.call(...)
      new(...).call
    end

    def initialize(record:)
      @record = record
    end

    def call
      case record
      when ButtonImageProcessingRequest
        image_prompt_from_button_request
      end
    end

    private

    attr_reader :record

    delegate :command_request, to: :record
    delegate :image_prompt, :category, to: :command_request, prefix: true

    def image_prompt_from_button_request
      return unless cartoon_script_edit_request?

      command_request_image_prompt
    end

    def cartoon_script_edit_request?
      command_request.is_a?(CommandEditImageRequest) &&
        command_request_category == ContentCategory::CARTOON_SCRIPT
    end
  end
end
