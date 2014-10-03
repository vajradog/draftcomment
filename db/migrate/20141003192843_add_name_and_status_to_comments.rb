class AddNameAndStatusToComments < ActiveRecord::Migration
  def change
  	add_column :comments, :creator, :string
  	add_column :comments, :status, :string
  end
end
