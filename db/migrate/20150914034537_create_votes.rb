class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.belongs_to :nomination, null: false, index: true
      t.belongs_to :voter, null: false, index: true
      t.index [:nomination_id, :voter_id], unique: true
      t.timestamps
    end
  end
end
