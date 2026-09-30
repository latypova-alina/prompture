module Admin
  module ButtonRequestEagerLoad
    def self.call(klass)
      relation = klass.includes(command_request: :user)
      association = Admin::ButtonRequestTypes.media_association_for(klass)
      association ? relation.includes(association) : relation
    end
  end
end
