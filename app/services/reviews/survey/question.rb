module Reviews
  module Survey
    # One survey question. `options` are option ids for choice questions; `other` adds an "Other"
    # option whose free text must be at least `min_length` characters.
    Question = Struct.new(:id, :type, :required, :min_length, :options, :other, keyword_init: true) do
      def choice?
        %i[single_choice multi_choice].include?(type)
      end
    end
  end
end
