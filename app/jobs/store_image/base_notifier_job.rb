module StoreImage
  class BaseNotifierJob < ApplicationJob
    include Memery

    def perform(record_type, record_id, error_class_name = nil)
      @record_type = record_type
      @record_id = record_id
      @error_class_name = error_class_name

      with_locale(locale) do
        notify
      end
    end

    private

    attr_reader :record_type, :record_id, :error_class_name

    memoize def image_record
      record_type.constantize.find(record_id)
    end

    def locale
      image_record.command_request.user.locale
    end

    def notify
      raise NotImplementedError
    end
  end
end
