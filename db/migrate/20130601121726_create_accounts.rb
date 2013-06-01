class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer    :balance, :default => 0
      t.references :user, :null => false
      t.timestamps
    end

    add_index :accounts, :user_id, :unique => true
    add_foreign_key :accounts, :users
  end
end
