class CreateSpeakers < ActiveRecord::Migration
  def up
    create_table :house_speakers do |t|
      t.references :mp, null: false
      t.date :start_date
      t.date :end_date
    end
  end

  def down
    drop_table :house_speakers
  end
end
