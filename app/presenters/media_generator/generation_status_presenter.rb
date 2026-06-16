module MediaGenerator
  class GenerationStatusPresenter
    def initialize(request)
      @request = request
    end

    def inline_keyboard
      [[check_status_button, cancel_button]]
    end

    private

    attr_reader :request

    def check_status_button
      {
        text: I18n.t("errors.check_status_button"),
        callback_data: "#{ButtonActions::CHECK_GENERATION_STATUS}:#{request.id}:#{request.class.name}"
      }
    end

    def cancel_button
      {
        text: I18n.t("errors.cancel_generation_button"),
        callback_data: "#{ButtonActions::CANCEL_GENERATION}:#{request.id}:#{request.class.name}"
      }
    end
  end
end
