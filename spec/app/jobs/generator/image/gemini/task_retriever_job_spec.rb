require "rails_helper"

describe Generator::Image::Gemini::TaskRetrieverJob do
  it_behaves_like "image task retriever job", processor: "gemini"
end
