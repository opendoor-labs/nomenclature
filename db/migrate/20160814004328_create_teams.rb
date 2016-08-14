class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.citext :slack_team_id, null: false
      t.string :team_name, null: false
      t.string :access_token, null: false
      t.string :install_scope, null: false
      t.string :installing_user_id, null: false
      t.timestamps
      t.index :slack_team_id, unique: true
    end
  end
end
