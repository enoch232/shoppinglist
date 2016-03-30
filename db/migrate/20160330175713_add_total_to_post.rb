class AddTotalToPost < ActiveRecord::Migration
  def change
    add_column :posts, :total, :decimal
  end
end
