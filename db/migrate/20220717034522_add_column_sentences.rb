class AddColumnSentences < ActiveRecord::Migration[6.1]
  def change
    add_column :sentences, :contentFurigana, :string
    add_column :sentences, :contentHiragana, :string
    add_column :sentences, :contentMisconversion, :string
  end
end
