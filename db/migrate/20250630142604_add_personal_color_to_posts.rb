class AddPersonalColorToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :personal_color, :string
  end
end
