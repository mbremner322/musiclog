class AddLikeToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :like, :integer
  end
end
