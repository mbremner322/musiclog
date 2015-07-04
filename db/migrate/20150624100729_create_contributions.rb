class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
        t.string :songTitle
        t.string :artistName
        t.string :link
        t.string :body
        t.timestamps null: false
    end 
  end
end
