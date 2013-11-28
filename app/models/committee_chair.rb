# encoding: UTF-8
class CommitteeChair < ActiveRecord::Base

  belongs_to :committee, :foreign_key => 'chairs_id'
  has_many :oral_answers, :as => :answer_from

  def self.from_name name
    chair = CommitteeChair.find_by_role(name)

    if chair.nil?
      committee = Committee.from_name(name.gsub('Chairperson of the', ''))
      if committee
        CommitteeChair.create(:role => name, :committee => committee)
      else
        nil
      end
    else
      chair
    end
  end

  def title
    role
  end
end
