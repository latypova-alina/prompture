module CartoonCharacter
  class Name
    def self.call
      ENV.fetch("CHARACTER_NAME")
    end
  end
end
