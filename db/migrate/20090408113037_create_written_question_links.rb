class CreateWrittenQuestionLinks < ActiveRecord::Migration
  def self.up
    create_table :written_question_links do |t|
      t.integer :from_id
      t.integer :to_id
      t.string :link_type
    end
  end

  def self.down
    drop_table :written_question_links
  end
end
