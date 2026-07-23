module MediaGenerator
  module ButtonHandler
    module ForBloomy
      module ShortComplexScript
        class CreditsValidator
          def initialize(user:, total_cost:)
            @user = user
            @total_cost = total_cost
          end

          def enough_credits?
            user.balance.credits >= total_cost
          end

          private

          attr_reader :user, :total_cost
        end
      end
    end
  end
end
