# encoding: UTF-8

class Role < ActiveRecord::Base
  class << self
    def by_date date
      role = where("start_date > ? AND (end_date IS NULL OR end_date < ?)", date, date).first

      speaker.mp unless speaker.nil?
    end
  end
end
