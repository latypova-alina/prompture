module Retryable
  def with_retries(max_attempts:, on: StandardError)
    attempt = 1

    begin
      yield
    rescue on
      raise if attempt >= max_attempts

      attempt += 1
      sleep(attempt)
      retry
    end
  end
end
