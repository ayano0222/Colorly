class RemoveArticleIdFromBookmarks < ActiveRecord::Migration[7.1]
  def change
    remove_column :bookmarks, :article_id, :integer
  end
end
