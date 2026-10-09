module Admin
  # Moderation of what a button request was generated from, per input record: its parent (a prompt, an uploaded
  # picture, or the generated image it animates) and, when the parent is a prompt, the picture that prompt
  # was written for.
  class ButtonRequestInputModerations
    include Memery

    def self.call(...)
      new(...).call
    end

    def initialize(button_request)
      @button_request = button_request
    end

    def call
      input_records.to_h { |record| [record, results_by_record.fetch(key(record), [])] }.compact_blank
    end

    private

    attr_reader :button_request

    delegate :parent_request, :command_request, to: :button_request

    memoize def input_records
      [parent_request, prompt_source].compact
    end

    def prompt_source
      return unless parent_request.is_a?(PromptMessage)

      source = parent_request.parent_request
      source unless source == command_request
    end

    memoize def results_by_record
      ModerationResult.where(moderatable: input_records).order(:created_at)
                      .group_by { |result| [result.moderatable_type, result.moderatable_id] }
    end

    def key(record)
      [record.class.polymorphic_name, record.id]
    end
  end
end
