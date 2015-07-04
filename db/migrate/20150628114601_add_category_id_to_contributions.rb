class AddCategoryIdToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :author, :integer
  end
end
