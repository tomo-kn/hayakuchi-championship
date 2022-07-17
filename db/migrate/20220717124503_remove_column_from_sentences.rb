class RemoveColumnFromSentences < ActiveRecord::Migration[6.1]
  def change
    remove_column :sentences, :contentHiragana
  end
end
