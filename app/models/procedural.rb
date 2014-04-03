# encoding: UTF-8
# == Schema Information
#
# Table name: contributions
#
#  id           :integer          not null, primary key
#  spoken_in_id :integer          not null
#  spoken_by_id :integer
#  type         :string(255)      not null
#  speaker      :string(255)
#  on_behalf_of :string(255)
#  time         :time
#  page         :integer
#  vote_id      :integer
#  text         :text             not null
#  date         :date
#  date_int     :integer
#

class Procedural < Contribution

  alias_method :original_is_procedural?, :is_procedural?
  alias_method :original_populate_spoken_by_id, :populate_spoken_by_id

  def is_procedural?
    true
  end

  protected

    def populate_spoken_by_id
      # do nothing, as procedural contribution has no speaker
    end

end
