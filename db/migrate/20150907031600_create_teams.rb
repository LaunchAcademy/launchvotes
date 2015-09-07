class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.boolean :enrolling, null: false, default: false
      t.index :name, unique: true
    end
  end
end
