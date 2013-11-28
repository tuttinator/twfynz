class RenamePersistedToIsPersisted < ActiveRecord::Migration
  def change
    change_table :persisted_files do |t|
      t.rename :persisted, :is_persisted
    end
  end
end
