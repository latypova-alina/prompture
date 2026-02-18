class Token < ApplicationRecord
  belongs_to :user, optional: true

  def expired?
    expires_at < Date.current
  end
end
