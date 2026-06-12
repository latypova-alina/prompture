module Generator
  module Media
    module StoredMedia
      class MergedVideoUploader < VideoUploader
        private

        def folder
          ContentCategory.merged_video_bucket_folder(category)
        end
      end
    end
  end
end
