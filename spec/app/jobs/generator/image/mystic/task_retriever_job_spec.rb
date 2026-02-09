require "rails_helper"

describe Generator::Image::Mystic::TaskRetrieverJob do
  it_behaves_like "image task retriever job", processor: "mystic"
end
