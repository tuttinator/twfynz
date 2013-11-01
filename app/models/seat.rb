class Seat
  include Mongoid::Document

  # belongs to a Parliament
  embedded_in :parliament
end