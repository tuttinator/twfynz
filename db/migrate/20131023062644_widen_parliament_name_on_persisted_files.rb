class WidenParliamentNameOnPersistedFiles < ActiveRecord::Migration
  def up
    change_column :persisted_files, :parliament_name, :text
  end

  def down
    change_column :persisted_files, :parliament_name, :string
  end
end
