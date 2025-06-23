class Post < ApplicationRecord

    attachment :image
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :view_counts, dependent: :destroy
    #tweetsテーブルから中間テーブルに対する関連付け
    has_many :post_tag_relations, dependent: :destroy
    #tweetsテーブルから中間テーブルを介してTagsテーブルへの関連付け
    has_many :tags, through: :post_tag_relations, dependent: :destroy
    has_many :bookmarks, dependent: :destroy
    has_many :bookmarking_users, through: :bookmarks, source: :user

    validates :location, presence: true, length: { maximum: 15 }
    validates :text, presence: true, length: { maximum: 195 }

    enum status: { published: 0, draft: 1 }

    def favorited_by?(user)
        favorites.where(user_id: user.id).exists?
    end
end
