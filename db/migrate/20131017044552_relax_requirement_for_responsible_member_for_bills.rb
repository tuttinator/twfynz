class RelaxRequirementForResponsibleMemberForBills < ActiveRecord::Migration
  def up
    change_column :bills, :member_in_charge_id, :integer, :null => true
  end

  def down
    change_column :bills, :member_in_charge_id, :integer, :null => false
  end
end
