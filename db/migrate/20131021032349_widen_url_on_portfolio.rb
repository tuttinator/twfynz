class WidenUrlOnPortfolio < ActiveRecord::Migration
  def up
    change_table :portfolios do |t|
      t.change :url, :text
    end
  end

  def down
    change_table :portfolios do |t|
      t.change :url, :string, :limit => 82
    end
  end
end
