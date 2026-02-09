require "rails_helper"

describe Generator::Image::Mystic::TaskCreatorJob do
  it_behaves_like "image task creator job", processor: "mystic"
end
