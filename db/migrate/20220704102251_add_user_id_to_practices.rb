class AddUserIdToPractices < ActiveRecord::Migration[6.1]
  def change
    add_reference :practices, :user, foreign_key: true
    add_reference :practices, :sentence, foreign_key: true
  end
end
