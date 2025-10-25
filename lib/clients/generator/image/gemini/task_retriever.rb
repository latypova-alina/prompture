module Clients
  module Generator
    module Image
      module Gemini
        class TaskRetriever < ::Clients::Generator::Image::BaseTaskRetriever
          API_URL = "https://api.freepik.com/v1/ai/gemini-2-5-flash-image-preview".freeze
        end
      end
    end
  end
end
