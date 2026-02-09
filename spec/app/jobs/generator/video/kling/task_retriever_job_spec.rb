require "rails_helper"

describe Generator::Video::Kling::TaskRetrieverJob do
  it_behaves_like "video task retriever job", processor: "kling_2_1_pro"
end
