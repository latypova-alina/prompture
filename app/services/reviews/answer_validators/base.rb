module Reviews
  module AnswerValidators
    # Validates one answer against its question. #error returns nil when valid, otherwise an error
    # key (:required, :too_short, :too_long, :invalid_option, :other_too_short) for the client.
    # #value is the normalized answer to store, so the raw payload never reaches the database.
    class Base
      MAX_TEXT_LENGTH = 2000

      def initialize(question:, answer:)
        @question = question
        @answer = answer
      end

      def error
        raise NotImplementedError
      end

      def value
        raise NotImplementedError
      end

      private

      attr_reader :question, :answer

      def too_short?(text)
        text.to_s.strip.length < question.min_length.to_i
      end

      def too_long?(text)
        text.to_s.strip.length > MAX_TEXT_LENGTH
      end
    end
  end
end
