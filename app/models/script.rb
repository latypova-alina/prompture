class Script < ApplicationRecord
  belongs_to :video_prompt, optional: true
  belongs_to :image_prompt, optional: true
end
