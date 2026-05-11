module ScriptGenerator
  class GenerateScript
    include Interactor::Organizer

    organize ExtractTemplateName, PerformJob
  end
end
