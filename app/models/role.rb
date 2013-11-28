# encoding: UTF-8

class Role < ActiveRecord::Base
  belongs_to :mp

  class << self
    def find_speaker_at title, date
      title.downcase!

      %w(madam mr).each{|tok| title.gsub!(tok, '') }

      title.squish!

      role = where("title = ? AND start_date < ? AND (end_date IS NULL OR end_date > ?)", title, date, date).first

      role.mp unless role.nil?
    end
  end
end
