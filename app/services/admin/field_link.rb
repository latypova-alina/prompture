module Admin
  # A field value that should render as a link with its own text (e.g. fal_request_id -> fal dashboard).
  FieldLink = Struct.new(:text, :url)
end
