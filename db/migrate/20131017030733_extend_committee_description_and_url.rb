class ExtendCommitteeDescriptionAndUrl < ActiveRecord::Migration
  def up
    change_column :committees, :description, :text
    change_column :committees, :url, :text, :null => false
  end

  def down
    change_column :committees, :description, :string, :limit => 234
    change_column :committees, :url, :string, :limit => 46, :null => false
  end
end
