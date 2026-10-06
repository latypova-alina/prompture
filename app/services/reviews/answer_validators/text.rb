module Reviews
  module AnswerValidators
    class Text < Base
      def error
        return :required if value.empty?
        return :too_short if too_short?(value)

        :too_long if too_long?(value)
      end

      def value
        answer.is_a?(String) ? answer.strip : ""
      end
    end
  end
end
