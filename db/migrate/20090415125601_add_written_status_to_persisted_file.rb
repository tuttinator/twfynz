class AddWrittenStatusToPersistedFile < ActiveRecord::Migration
  def self.up
    add_column :persisted_files, :written_status, :string, :limit => 10
  end

  def self.down
    remove_column :persisted_files, :written_status
  end
end
