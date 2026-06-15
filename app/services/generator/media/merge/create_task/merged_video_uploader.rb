module Generator
  module Media
    module Merge
      module CreateTask
        class MergedVideoUploader
          include Memery

          def initialize(tmp:, request:)
            @tmp = tmp
            @request = request
          end

          def stored_url
            facade.upload

            facade.stored_url
          end

          private

          attr_reader :tmp, :request

          delegate :command_request, to: :request
          delegate :category, to: :command_request

          def facade
            @facade ||= StoreMedia::Upload::Facade.new(
              bytes: read_bytes,
              filename:,
              folder:
            )
          end

          def read_bytes
            tmp.rewind
            tmp.binmode
            tmp.read
          end

          memoize def filename
            "merged_#{request.id}.mp4"
          end

          memoize def folder
            ContentCategory.merged_video_bucket_folder(category)
          end
        end
      end
    end
  end
end
