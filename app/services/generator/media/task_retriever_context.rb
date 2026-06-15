module Generator
  module Media
    module TaskRetrieverContext
      def self.for(params:)
        context_class(params[:processor]).new(params:)
      end

      def self.context_class(processor)
        return FalImageTaskRetrieverContext if Generator::Processors::ALL_IMAGE.include?(processor)
        return FalVideoTaskRetrieverContext if video_processor?(processor)
        return FalAudioTaskRetrieverContext if Generator::Processors::AUDIO.include?(processor)

        raise ArgumentError, "Unknown processor: #{processor}"
      end

      def self.video_processor?(processor)
        Generator::Processors::VIDEO.include?(processor) ||
          Generator::Processors::MERGE.include?(processor)
      end
    end
  end
end
