class Message < ApplicationRecord
  belongs_to :customer
  belongs_to :room

  validates :content, presence: true, length: { maximum:140 }
end
