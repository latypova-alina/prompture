module MediaGenerator
  module CommandHandler
    class HandleCommand
      include Interactor
      include Memery

      delegate :command, :chat_id, to: :context

      def call
        context.fail!(error: CommandUnknownError) unless command_request_class

        command_request_class.create!(chat_id:, user:)
      end

      private

      memoize def command_request_class
        CommandRequestClassResolver.new(command:, user:).call
      end

      memoize def user
        User.find_by!(chat_id:)
      end
    end
  end
end
