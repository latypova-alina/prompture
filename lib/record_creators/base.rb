module RecordCreators
  class Base
    include RecordCreators::Interface

    attr_reader :parent_request, :image_url, :command_request

    def initialize(parent_request, command_request)
      @parent_request = parent_request
      @command_request = command_request
    end
  end
end
