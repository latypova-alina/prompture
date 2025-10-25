module BuildVideo
  class CreateTask
    include Memery
    include Interactor

    TASK_CREATOR = {
      "kling_2_1_pro_image_to_video" => Clients::Generator::Video::Kling::TaskCreator
    }.freeze

    delegate :image_url, :processor_type, to: :context

    def call
      context.task_id = task_id
    end

    private

    delegate :task_id, to: :client

    memoize def client
      TASK_CREATOR[processor_type].new(image_url)
    end
  end
end
