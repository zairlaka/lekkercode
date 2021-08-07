class AddArchiveToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :archive, :boolean, default: false
  end
end
