module ScriptGenerator
  class Connection
    def self.call
      Faraday.new(
        url: ENV.fetch("SCRIPT_GENERATOR_API_URL"),
        headers: {
          "Content-Type" => "application/json",
          "Authorization" => "Bearer #{ENV.fetch('SCRIPT_GENERATOR_API_KEY')}"
        }
      )
    end
  end
end
