class Scene < ApplicationRecord
  belongs_to :script
  belongs_to :video_prompt, optional: true
  belongs_to :image_prompt, optional: true
end
