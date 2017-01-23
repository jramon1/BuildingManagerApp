class DropTableUpload < ActiveRecord::Migration[5.0]
  def up
    drop_table :uploads
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
