class CreateFaqItems < ActiveRecord::Migration
  def change
    create_table :faq_items do |t|
      t.string :question
      t.string :answer

      t.timestamps null: false
    end
  end
end
