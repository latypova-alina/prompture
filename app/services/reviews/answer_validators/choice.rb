module Reviews
  module AnswerValidators
    # single_choice and multi_choice answers look like { "selected" => [...], "other" => "..." }.
    class Choice < Base
      include Memery

      OTHER = "other".freeze

      def error
        return :required if selected.empty?
        return :invalid_option if invalid_selection?
        return unless other_selected?
        return :other_too_short if too_short?(other_text)

        :too_long if too_long?(other_text)
      end

      def value
        other_selected? ? { "selected" => selected, "other" => other_text } : { "selected" => selected }
      end

      private

      memoize def selected
        raw = answer.is_a?(Hash) ? answer["selected"] : nil
        Array(raw).map(&:to_s).uniq
      end

      memoize def other_text
        raw = answer.is_a?(Hash) ? answer["other"] : nil
        raw.is_a?(String) ? raw.strip : ""
      end

      def invalid_selection?
        (selected - allowed_options).any? || (question.type == :single_choice && selected.size > 1)
      end

      def allowed_options
        question.other ? question.options + [OTHER] : question.options
      end

      def other_selected?
        selected.include?(OTHER)
      end
    end
  end
end
