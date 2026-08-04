class SeedGrowthBlazerDashboard < ActiveRecord::Migration[8.0]
  def up
    dashboard = Blazer::Dashboard.create!(name: "Growth")
    query = Blazer::Query.find_by!(name: "New users per day")

    Blazer::DashboardQuery.create!(dashboard:, query:, position: 0)
  end

  def down
    Blazer::Dashboard.find_by(name: "Growth")&.destroy
  end
end
