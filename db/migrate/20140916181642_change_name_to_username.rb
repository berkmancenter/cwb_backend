class ChangeNameToUsername < ActiveRecord::Migration
  def change
    rename_column :accounts, :name, :username
  end
end
