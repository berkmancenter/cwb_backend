class AddProfileIdToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :profile_id, :integer
  end
end
