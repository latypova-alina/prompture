module MiniApp
  class InitDataValidator
    include Memery

    def initialize(init_data:)
      @init_data = init_data
    end

    def valid?
      provided_hash.present? && ActiveSupport::SecurityUtils.secure_compare(computed_hash, provided_hash)
    end

    private

    attr_reader :init_data

    delegate :provided_hash, to: :provided_hash_reader
    delegate :computed_hash, to: :computed_hash_builder

    memoize def params
      URI.decode_www_form(init_data.to_s).to_h
    end

    memoize def provided_hash_reader
      Validator::ProvidedHashReader.new(params:)
    end

    memoize def computed_hash_builder
      Validator::ComputedHashBuilder.new(params:)
    end
  end
end
