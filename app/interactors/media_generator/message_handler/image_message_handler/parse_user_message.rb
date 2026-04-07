module MediaGenerator
  module MessageHandler
    module ImageMessageHandler
      class ParseUserMessage
        include Interactor
        include Memery

        delegate :user_message, to: :context

        def call
          parsed_attributes.each { |key, value| context.public_send("#{key}=", value) }
        end

        private

        delegate :message_text, :picture_id, :chat_id, :image_url, to: :message_parser

        memoize def message_parser
          MessageParser.new(user_message)
        end

        memoize def largest_photo
          Array(user_message["photo"]).max_by { |photo| photo["file_size"].to_i }
        end

        def parsed_attributes
          {
            message_text:,
            chat_id:,
            picture_id:,
            image_url:,
            width:,
            height:,
            size_bytes:
          }
        end

        def width
          largest_photo&.dig("width")
        end

        def height
          largest_photo&.dig("height")
        end

        def size_bytes
          largest_photo&.dig("file_size")
        end
      end
    end
  end
end
