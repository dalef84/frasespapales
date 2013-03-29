class CreatePhrases < ActiveRecord::Migration
  def change
    create_table :phrases do |t|
      t.string :text, :null => false
      t.integer :votes, :default => 0
      t.datetime :created_date
      t.string :origin
      t.boolean :approved, :default => false

      t.timestamps
    end
      
    add_index :phrases, [:text], :unique => true

  end
end
