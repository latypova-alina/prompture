module Generator
  module Media
    module StoredMedia
      class FolderResolver
        def initialize(record:)
          @record = record
        end

        def folder
          return subcategory_folder if origin_subcategory.present?

          category_folder
        end

        private

        attr_reader :record

        delegate :origin_subcategory, to: :record
        delegate :category, to: :command_request
        delegate :command_request, to: :record

        def subcategory_folder
          "videos/#{category}/#{origin_subcategory}"
        end

        def category_folder
          "videos/#{ContentCategory.bucket_folder(category)}"
        end
      end
    end
  end
end
