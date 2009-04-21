class AddDateTakenToPhoto < ActiveRecord::Migration
  def self.up
    add_column("photos", "date_taken", "date")
  end

  def self.down
    remove_column("photos", "date_taken")
  end
end
