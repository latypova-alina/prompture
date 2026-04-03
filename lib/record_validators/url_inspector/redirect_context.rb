module RecordValidators
  module UrlInspector
    RedirectContext = Struct.new(
      :response,
      :current_uri,
      :method_type,
      :headers,
      :redirects,
      keyword_init: true
    )
  end
end
