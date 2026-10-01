module Admin
  # A button request's cost from its class and processor alone - cost isn't a column, each model
  # computes it from COSTS - so refs can be sorted by cost without loading records.
  module ButtonRequestCost
    def self.call(klass, processor)
      return klass.new.cost unless klass.column_names.include?("processor")
      return if processor.nil?

      klass.new(processor:).cost
    end
  end
end
