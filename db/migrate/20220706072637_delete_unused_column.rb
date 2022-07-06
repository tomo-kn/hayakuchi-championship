class DeleteUnusedColumn < ActiveRecord::Migration[6.1]
  def change
    remove_column :practices, :name
    remove_column :practices, :date
    remove_column :practices, :accuracy

    drop_table :judges

    add_column :practices, :word, :string
  end
end
