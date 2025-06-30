class AddPersonalColorToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :personal_color, :string
  end
end
