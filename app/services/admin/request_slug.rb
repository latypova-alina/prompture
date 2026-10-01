module Admin
  # Maps request classes to the URL type segment ("CommandPromptToImageRequest" <-> "prompt_to_image")
  # and back, only ever resolving against a given whitelist of classes - never constantizing params.
  module RequestSlug
    def self.for(class_name)
      class_name.sub(/\A(Command|Button)/, "").delete_suffix("Request").underscore
    end

    def self.resolve(slug, types)
      types.find { |klass| self.for(klass.name) == slug }
    end
  end
end
