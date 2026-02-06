require "rails_helper"

describe Generator::Image::Imagen::TaskCreatorJob do
  it_behaves_like "image task creator job", processor: "imagen"
end
