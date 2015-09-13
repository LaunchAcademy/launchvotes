class CreateNominations < ActiveRecord::Migration
  def change
    create_table :nominations do |t|
      t.belongs_to :nominee_membership, null: false, index: true
      t.belongs_to :nominator, null: false, index: true
      t.string :body, null: false
      t.timestamps
    end
  end
end
