class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.references :account, :null => false
      t.integer :to_account_id, :null => false
      t.integer :amount, :null => false
      t.timestamps
    end

    add_foreign_key :transfers, :accounts
    add_foreign_key :transfers, :accounts, column: :to_account_id
  end
end
