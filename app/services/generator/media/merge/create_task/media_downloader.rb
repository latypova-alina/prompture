module Generator
  module Media
    module Merge
      module CreateTask
        class MediaDownloader
          def initialize(url, ext)
            @url = url
            @ext = ext
          end

          def tempfile
            write_to_tmp

            tmp
          end

          private

          attr_reader :url, :ext

          def write_to_tmp
            tmp.binmode
            URI.open(url) { |io| tmp.write(io.read) } # rubocop:disable Security/Open
            tmp.rewind
          end

          memoize def tmp
            Tempfile.new(["media", ext])
          end
        end
      end
    end
  end
end
