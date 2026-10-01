module Admin
  module RecordLabel
    def self.call(record)
      "#{record.class.name}##{record.id}"
    end
  end
end
