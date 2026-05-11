module ScriptGenerator
  class ExtractTemplateName
    include Interactor

    delegate :message_body, to: :context

    def call
      context.fail!(error: TemplateNameError) if template_name.blank?

      context.template_name = template_name
    end

    private

    def text
      @text ||= message_body.dig("message", "text").to_s
    end

    def template_name
      @template_name ||= text.split(" ", 2)[1].presence
    end
  end
end
