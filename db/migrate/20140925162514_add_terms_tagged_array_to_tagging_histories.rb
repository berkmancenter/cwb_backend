class AddTermsTaggedArrayToTaggingHistories < ActiveRecord::Migration
  def change
    add_column :tagging_histories, :terms_tagged, :string
  end
end
