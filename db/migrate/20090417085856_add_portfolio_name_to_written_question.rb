class AddPortfolioNameToWrittenQuestion < ActiveRecord::Migration
  def self.up
    add_column :written_questions, :portfolio_name, :string
  end

  def self.down
    remove_column :written_questions, :portfolio_name
  end
end
