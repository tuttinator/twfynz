class Parliament
  include Mongoid::Document

  field :ordinal_number, type: Integer
  field :commenced_on, type: Date
  field :disolved_on, type: Date

  embeds_many :seats

  validates_numericality_of :number

  def number_of_seats
    seats.count
  end

end