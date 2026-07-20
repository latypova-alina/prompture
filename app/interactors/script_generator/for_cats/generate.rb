module ScriptGenerator
  module ForCats
    class Generate
      include Interactor::Organizer

      organize ExtractTemplateName, PerformJob
    end
  end
end
