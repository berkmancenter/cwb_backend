class AddAccountManagerToAccountsTable < ActiveRecord::Migration
  def change
    add_column :accounts, :account_manager, :boolean
  end
end
