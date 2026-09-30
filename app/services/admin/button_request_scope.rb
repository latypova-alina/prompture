module Admin
  class ButtonRequestScope
    def self.call(...)
      new(...).call
    end

    def initialize(klass:, filters:, user: nil)
      @klass = klass
      @user = user
      @filters = filters
    end

    def call
      relation = scoped_by_command_type
      relation = apply_status(relation)
      apply_processor(relation)
    end

    private

    attr_reader :klass, :user, :filters

    delegate :status, :processor, :command_type, :user_search, to: :filters

    def command_types
      matched = Admin::CommandRequestsQuery::TYPES.select { |command_klass| command_klass.name == command_type }
      matched.presence || Admin::CommandRequestsQuery::TYPES
    end

    def scoped_by_command_type
      command_types.reduce(klass.none) do |rel, command_klass|
        rel.or(
          klass.where(command_request_type: command_klass.name,
                      command_request_id: command_scope(command_klass).select(:id))
        )
      end
    end

    def command_scope(command_klass)
      return command_klass.where(user:) if user.present?
      return command_klass.where(user: Admin::UserSearch.call(user_search)) if user_search.present?

      command_klass.all
    end

    def apply_status(relation)
      return relation unless status.present?

      relation.where("upper(status) = ?", status.to_s.upcase)
    end

    def apply_processor(relation)
      return relation unless processor.present?

      relation.where(processor:)
    end
  end
end
