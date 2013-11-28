class AddFormerlyPartOfTextToBill < ActiveRecord::Migration
  def change
    change_table :bills do |t|
      t.string :formerly_part_of_text
    end
  end
end
