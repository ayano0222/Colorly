class CreateViewCounts < ActiveRecord::Migration[7.1]
  def change
    create_table :view_counts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true

      t.timestamps
    end
  end
end
