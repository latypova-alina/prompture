require "rails_helper"

describe Generator::Video::Kling::TaskCreatorJob do
  it_behaves_like "video task creator job", processor: "kling_2_1_pro"
end
