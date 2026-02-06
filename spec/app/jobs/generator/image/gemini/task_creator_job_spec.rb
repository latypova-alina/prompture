require "rails_helper"

describe Generator::Image::Gemini::TaskCreatorJob do
  it_behaves_like "image task creator job", processor: "gemini"
end
