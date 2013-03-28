class CreatePhrases < ActiveRecord::Migration
  def change
    create_table :phrases do |t|
      t.string :text
      t.integer :votes
      t.datetime :created_date
      t.string :origin

      t.timestamps
    end
  end
end
