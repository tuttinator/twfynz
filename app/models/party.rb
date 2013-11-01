class Party
  include Mongoid::Document

  field :name, String
  field :alternate_names, Array

end