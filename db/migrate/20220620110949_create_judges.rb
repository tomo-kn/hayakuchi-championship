class CreateJudges < ActiveRecord::Migration[6.1]
  def change
    create_table :judges do |t|
      t.string :content

      t.timestamps
    end
  end
end
