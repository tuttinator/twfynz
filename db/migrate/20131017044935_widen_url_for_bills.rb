class WidenUrlForBills < ActiveRecord::Migration
  def up
    change_column :bills, :url, :text
  end

  def down
    change_column :bills, :url, :string, :limit => 45
  end
end
