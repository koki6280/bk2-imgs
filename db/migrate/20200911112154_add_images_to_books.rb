class AddImagesToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :images, :json
  end
end
