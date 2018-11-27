class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.references  :user
      t.references  :item
      t.string :title
      t.text   :text
      t.timestamps null: false
    end
  end
end
