module BuildMysticImage
  class CreateTask
    include Memery
    include Interactor

    delegate :prompt, to: :context

    def call
      context.task_id = task_id
    end

    private

    delegate :task_id, to: :mystic_client

    memoize def mystic_client
      Clients::Mystic::TaskCreator.new(prompt)
    end
  end
end
