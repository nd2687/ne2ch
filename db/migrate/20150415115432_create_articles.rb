class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :tweet_text, null: false
      t.string :text, null: false
      t.string :url, null: false

      t.timestamps null: false
    end
  end
end
