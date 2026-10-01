module Admin
  Sort = Struct.new(:key, :direction) do
    def desc?
      direction == "desc"
    end

    def sql_direction
      desc? ? "DESC" : "ASC"
    end
  end
end
