class AlterBanArticles < ActiveRecord::Migration
  def change
    add_column :ban_articles, :ban_word, :string
  end
end
