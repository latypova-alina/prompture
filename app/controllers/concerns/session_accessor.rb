module SessionAccessor
  extend ActiveSupport::Concern

  private

  def safe_session
    session.to_h.symbolize_keys
  end

  def session_parser
    SessionParser.new(**safe_session)
  end
end
