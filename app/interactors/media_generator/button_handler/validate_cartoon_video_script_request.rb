module MediaGenerator
  module ButtonHandler
    class ValidateCartoonVideoScriptRequest
      include Interactor
      include Memery

      delegate :command_request, :parent_request, to: :context

      def call
        context.script = script
        context.video_prompt = origin_video_prompt

        return if command_request.cartoon_script? && script.present?

        context.fail!(error: CommandUnknownError)
      end

      delegate :origin_video_prompt, to: :parent_request, allow_nil: true
      delegate :script, to: :origin_video_prompt, allow_nil: true

      memoize :origin_video_prompt, :script
    end
  end
end
