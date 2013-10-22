class GeneraliseHouseSpeakersToRoles < ActiveRecord::Migration
  def change
    rename_table :house_speakers, :roles
  end
end
