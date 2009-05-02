class AddMoreIndexes < ActiveRecord::Migration
  def self.up
    add_index :parties, :vote_name
    add_index :debates, :date
    add_index :persisted_files, :publication_status
    add_index :members, :person_id
  end

  def self.down
    remove_index :parties, :vote_name
    remove_index :debates, :date
    remove_index :persisted_files, :publication_status
    remove_index :members, :person_id
  end
end
