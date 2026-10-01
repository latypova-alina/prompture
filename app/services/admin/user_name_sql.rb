module Admin
  # SQL expression for the lowercased name of the user who owns a request row, so refs can be
  # sorted by user without joins. Button tables reach the user through their (polymorphic)
  # command request, so they get one CASE branch per command table. Only whitelisted class/table
  # names are interpolated - never params.
  module UserNameSql
    def self.call(klass)
      return user_name_where("users.id = #{klass.quoted_table_name}.user_id") if command?(klass)

      "(CASE #{klass.quoted_table_name}.command_request_type #{command_branches(klass)} END)"
    end

    def self.command?(klass)
      Admin::CommandRequestsQuery::TYPES.include?(klass)
    end

    def self.command_branches(klass)
      Admin::CommandRequestsQuery::TYPES.map do |command_klass|
        condition = "users.id = (SELECT user_id FROM #{command_klass.quoted_table_name} " \
                    "WHERE id = #{klass.quoted_table_name}.command_request_id)"
        "WHEN #{klass.connection.quote(command_klass.name)} THEN #{user_name_where(condition)}"
      end.join(" ")
    end

    def self.user_name_where(condition)
      "(SELECT LOWER(users.name) FROM users WHERE #{condition})"
    end

    private_class_method :command?, :command_branches, :user_name_where
  end
end
