class RemoveEmailFromAccounts < ActiveRecord::Migration
  def change
    remove_column :accounts, :email, :string
  end
end
