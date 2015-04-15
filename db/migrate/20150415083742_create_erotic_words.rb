class CreateEroticWords < ActiveRecord::Migration
  def change
    create_table :erotic_words do |t|
      t.string :word, null: false
      t.string :first_word, null: false

      t.timestamps null: false
    end
  end
end
