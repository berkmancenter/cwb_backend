class CreateTaggingHistories < ActiveRecord::Migration
  def change
    create_table :tagging_histories do |t|
      t.integer :account_id
      t.string :file_tagged
      t.string :file_untagged

      t.timestamps
    end
  end
end
