require "rails_helper"

describe Generator::Image::Imagen::TaskRetrieverJob do
  it_behaves_like "image task retriever job", processor: "imagen"
end
