module Reviews
  # The thank-you reward for a completed review. Behind the flipper_review_bonus flag: while it's off
  # nobody is rewarded and nothing mentions a reward.
  module Reward
    CREDITS = 50

    def self.enabled_for?(user)
      Flipper.enabled?(:flipper_review_bonus, user)
    end
  end
end
