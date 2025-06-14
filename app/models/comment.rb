class Comment < ApplicationRecord
    belongs_to :user
    belongs_to :post

    validates :comment, presence: true, length: { maximum: 5 }
end
