module Clients
  module ImageGenerator
    class GeminiTaskRetriever < BaseTaskRetriever
      API_URL = "https://api.freepik.com/v1/ai/gemini-2-5-flash-image-preview".freeze
    end
  end
end
