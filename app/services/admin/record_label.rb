module Admin
  module RecordLabel
    def self.call(record)
      self.for(record.class.name, record.id)
    end

    def self.for(class_name, id)
      "#{class_name}##{id}"
    end
  end
end
