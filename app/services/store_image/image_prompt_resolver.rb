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
    delegate :image_prompt, to: :command_request, prefix: true

    def image_prompt_from_button_request
      return unless CommandEditImageRequest.cartoon_script_edit_image?(command_request:)

      command_request_image_prompt
    end
  end
end
