module ScriptGenerator
  module ForBloomy
    module ShortComplexScript
      class Generator
        include Interactor::Organizer

        organize ExtractSceneRecords, CreateImagePrompts, GenerateFirstImage
      end
    end
  end
end
