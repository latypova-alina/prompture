module Generator
  module Media
    module Video
      module RetrieveTask
        class ApiUrlFetcher < Generator::Media::RetrieveTask::ApiUrlFetcherBase
          API_URLS = {
            "kling_2_1_pro_image_to_video" => "https://api.freepik.com/v1/ai/image-to-video/kling-v2-1".freeze,
            "seedance_1_5_pro_image_to_video" => "https://api.freepik.com/v1/ai/video/seedance-1-5-pro-720p".freeze,
            "wan_2_2_image_to_video" => "https://api.freepik.com/v1/ai/image-to-video/wan-v2-2-720p".freeze
          }.freeze
        end
      end
    end
  end
end
