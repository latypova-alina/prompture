module Admin
  # Moderation results for a command's inputs: per input record, plus text prompts with no record of
  # their own (blocked prompts never become a PromptMessage; edit-image prompts live on the command).
  # Results for generated images (button requests) are left out.
  class InputModerations
    include Memery

    def initialize(command_request)
      @command_request = command_request
    end

    def for(input)
      by_input.fetch([input.class.name, input.id], [])
    end

    memoize def unlinked_prompts
      results.select { |result| result.moderatable_type.nil? && result.input_text.present? }
    end

    private

    attr_reader :command_request

    memoize def by_input
      results.select(&:moderatable_type).group_by { |result| [result.moderatable_type, result.moderatable_id] }
    end

    memoize def results
      ModerationResult.where(command_request:)
                      .where("moderatable_type IS NULL OR moderatable_type NOT LIKE 'Button%'")
                      .order(:created_at).to_a
    end
  end
end
