class CreatePhotos < ActiveRecord::Migration[8.0]
  def change
    create_table :photos do |t|
      t.date :taken_on, null: false
      t.timestamps
    end
    add_index :photos, :taken_on, unique: true
  end
end
