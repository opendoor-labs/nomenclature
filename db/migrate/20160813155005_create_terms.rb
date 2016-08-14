class CreateTerms < ActiveRecord::Migration[5.0]
  def change
    execute 'CREATE EXTENSION IF NOT EXISTS citext'

    create_table :terms do |t|
      t.integer :team_id, null: false
      t.citext :name, null: false
      t.text :description, null: false
      t.timestamps
      t.index [:team_id, :name], unique: true
    end
  end
end
