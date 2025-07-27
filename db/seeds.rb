# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Tag.destroy_all  # タグテーブルの全データを削除

Tag.create([
  { name: 'ベース' },
  { name: 'コンシーラー' },
  { name: 'ファンデーション' },
  { name: 'パウダー' },
  { name: 'アイブロウ' },
  { name: 'チーク'},
  { name: 'アイライナー' },
  { name: 'マスカラ' },
  { name: 'シェーディング' },
  { name: 'ハイライト' },
  { name: 'リップ' },
  { name: 'その他' }
])