# encoding: UTF-8
class WrittenQuestion < ActiveRecord::Base
  belongs_to :asker, :class_name => "Mp"
  belongs_to :portfolio
  belongs_to :respondent, :class_name => "Mp"

  has_many :written_questions_links, :foreign_key => :from_id
  has_many :linked_questions, :class_name => "written_question", :through => :written_question_links

  validates_presence_of :question, :asker, :portfolio, :question_number, :question_year
end
