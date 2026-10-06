module Reviews
  module AnswerValidators
    class Rating < Base
      RANGE = (1..5)

      def error
        :required unless answer.is_a?(Integer) && RANGE.cover?(answer)
      end

      def value
        answer
      end
    end
  end
end
