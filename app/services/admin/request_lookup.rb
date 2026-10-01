module Admin
  class RequestLookup
    def self.call(...)
      new(...).call
    end

    def initialize(types:, slug:, id:)
      @types = types
      @slug = slug
      @id = id
    end

    def call
      raise ActiveRecord::RecordNotFound, "Unknown request type: #{slug}" if klass.nil?

      klass.find(id)
    end

    private

    attr_reader :types, :slug, :id

    def klass
      Admin::RequestSlug.resolve(slug, types)
    end
  end
end
