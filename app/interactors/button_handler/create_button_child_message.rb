module ButtonHandler
  class CreateButtonChildMessage
    include Interactor

    delegate :button_request_record, :button_parent_message, to: :context

    def call
      ButtonChildMessage.create!(
        request: button_request_record,
        button_parent_message:
      )
    end
  end
end
