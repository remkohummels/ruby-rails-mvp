class ChangeGroupStatusDefault < ActiveRecord::Migration
  def change
    change_column_default(:groups, :status, 'disabled')
  end
end
