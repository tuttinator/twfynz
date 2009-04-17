class CreateWrittenQuestions < ActiveRecord::Migration
  def self.up
    create_table :written_questions do |t|
      t.text :question
      t.text :answer
      t.string :status
      t.integer :question_number
      t.integer :question_year
      t.integer :asker_id
      t.integer :portfolio_id
      t.integer :respondent_id
      t.date :date_asked
      t.integer :days_late
      t.string :subject
    end
  end

  def self.down
    drop_table :written_questions
  end
end
