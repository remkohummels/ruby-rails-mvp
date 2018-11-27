class AddKeywordsIntoItem < ActiveRecord::Migration
  def change
      add_column :items, :keywords,  :string
  end
end
