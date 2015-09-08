class CreateTeamMemberships < ActiveRecord::Migration
  def change
    create_table :team_memberships do |t|
      t.belongs_to :user, null: false
      t.belongs_to :team, null: false
      t.index :user_id
      t.index :team_id
      t.index [:user_id, :team_id], unique: true
      t.timestamps
    end
  end
end
