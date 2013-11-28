class AddWrittenQuestionIndexes < ActiveRecord::Migration
  def self.up
    add_index :written_questions, :status
    add_index :debates, [:about_type, :about_id, :publication_status], :name => "debate_on_type_status_id"
    add_index :debates, :about_id
  end

  def self.down
    remove_index :written_questions, :status
    remove_index :debates, [:about_type, :about_id, :publication_status]
    remove_index :debates, :about_id
  end
end
