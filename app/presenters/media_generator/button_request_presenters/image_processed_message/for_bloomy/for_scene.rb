module MediaGenerator
  module ButtonRequestPresenters
    module ImageProcessedMessage
      module ForBloomy
        class ForScene < ForEditImage
          def inline_keyboard
            Buttons::ForImageMessage::ForScene.build(locale:, processor:)
          end
        end
      end
    end
  end
end
