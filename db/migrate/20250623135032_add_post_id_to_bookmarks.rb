class AddPostIdToBookmarks < ActiveRecord::Migration[7.1]
  def change
    add_column :bookmarks, :post_id, :integer
  end
end
