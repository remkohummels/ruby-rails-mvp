class AddResolveReasonToDisputs < ActiveRecord::Migration
  def change
    add_column :disputs, :resolve_reason, :text
  end
end
