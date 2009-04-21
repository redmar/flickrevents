class CreateGatherSessions < ActiveRecord::Migration
  def self.up
    create_table :gather_sessions do |t|
      t.date :begin_date
      t.date :end_date
      t.integer :page_start
      t.integer :page_end
      t.string :tag

      t.timestamps
    end
  end

  def self.down
    drop_table :gather_sessions
  end
end
