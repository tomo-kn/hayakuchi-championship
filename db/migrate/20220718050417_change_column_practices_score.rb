class ChangeColumnPracticesScore < ActiveRecord::Migration[6.1]
  def change
    change_column :practices, :score, :float
  end
end
