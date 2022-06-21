class CreatePractices < ActiveRecord::Migration[6.1]
  def change
    create_table :practices do |t|
      t.string :name
      t.integer :score
      t.integer :accuracy
      t.float :time
      t.string :voice
      t.datetime :date

      t.timestamps
    end
  end
end
