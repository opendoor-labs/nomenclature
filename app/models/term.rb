class Term < ApplicationRecord
  belongs_to :team
  validates :name, presence: true
  validates :description, presence: true
end
