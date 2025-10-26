module Clients
  module Generator
    module Image
      module Mystic
        class TaskCreator < ::Clients::Generator::Image::BaseTaskCreator
          API_URL = "https://api.freepik.com/v1/ai/mystic".freeze

          private

          def payload
            JSON.parse(
              File.read(Rails.root.join("config/payloads/mystic/zen_payload.json"))
            ).merge(prompt:)
          end
        end
      end
    end
  end
end
