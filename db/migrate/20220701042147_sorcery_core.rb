class SorceryCore < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :crypted_password, :string
    add_column :users, :salt, :string
    add_index :users, :crypted_password
    add_index :users, :salt
  end
end
