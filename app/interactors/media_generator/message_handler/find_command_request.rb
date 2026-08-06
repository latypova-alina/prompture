module MediaGenerator
  module MessageHandler
    class FindCommandRequest
      include Interactor
      include Memery

      delegate :chat_id, :command, to: :context

      def call
        context.fail!(error: CommandUnknownError) unless command_request_class
        context.fail!(error: CommandRequestForgottenError) unless command_request

        context.command_request = command_request
      end

      private

      memoize def command_request
        command_request_class.where(chat_id:).order(created_at: :desc).first
      end

      memoize def command_request_class
        return unless user

        CommandRequestClassResolver.new(command:, user:).call
      end

      memoize def user
        User.find_by(chat_id:)
      end
    end
  end
end
