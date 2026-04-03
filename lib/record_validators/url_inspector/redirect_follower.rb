module RecordValidators
  module UrlInspector
    class RedirectFollower
      include Memery

      MAX_REDIRECTS = 3

      def follow(context)
        return nil if context.redirects > MAX_REDIRECTS

        redirected_uri = redirect_url_resolver.resolve(
          current_uri: context.current_uri,
          location: context.response.headers["location"]
        )
        return nil unless redirected_uri

        Requester.new(uri: redirected_uri, method: context.method_type, headers: context.headers)
          .run(redirects: context.redirects + 1)
      end

      private

      memoize def redirect_url_resolver
        RedirectUrlResolver.new
      end
    end
  end
end
