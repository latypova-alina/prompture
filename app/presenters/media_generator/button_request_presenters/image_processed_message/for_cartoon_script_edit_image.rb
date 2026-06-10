module MediaGenerator
  module ButtonRequestPresenters
    module ImageProcessedMessage
      class ForCartoonScriptEditImage < ForEditImage
        def inline_keyboard
          Buttons::ForImageMessage::ForCartoonScriptEditImage.build(locale:, processor:)
        end
      end
    end
  end
end
