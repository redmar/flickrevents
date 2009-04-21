class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.integer :owner_id
      t.integer :photo_id
      t.string :secret
      t.integer :server
      t.integer :farm
      t.float :latitude
      t.float :longitude
      t.text :tags

      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
