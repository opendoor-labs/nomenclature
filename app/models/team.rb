class Team < ApplicationRecord
  has_many :terms
  validates :slack_team_id, presence: true
  validates :team_name, presence: true
  validates :access_token, presence: true
  validates :install_scope, presence: true
  validates :installing_user_id, presence: true
end
