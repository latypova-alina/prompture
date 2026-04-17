module Generator
  module Media
    module Image
      module RetrieveTask
        class ApiUrlFetcher < Generator::Media::RetrieveTask::ApiUrlFetcherBase
          API_URLS = {
            "gemini_image" => "https://api.freepik.com/v1/ai/gemini-2-5-flash-image-preview".freeze,
            "mystic_image" => "https://api.freepik.com/v1/ai/mystic".freeze,
            "flux_image" => "https://api.freepik.com/v1/ai/text-to-image/flux-2-pro".freeze,
            "imagen_image" => "https://api.freepik.com/v1/ai/text-to-image/imagen3".freeze
          }.freeze
        end
      end
    end
  end
end
