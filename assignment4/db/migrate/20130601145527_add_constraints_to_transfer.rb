class AddConstraintsToTransfer < ActiveRecord::Migration
  def change
    execute "ALTER TABLE transfers ADD CONSTRAINT positive_amount CHECK (amount > 0)"
    execute "ALTER TABLE transfers ADD CONSTRAINT transfer_direction CHECK (account_id <> to_account_id)"
  end

  def down
    execute "ALTER TABLE transfers DROP CONSTRAINT transfer_direction"
    execute "ALTER TABLE transfers DROP CONSTRAINT positive_amount"
  end
end
