class AddLastSentAtToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :last_sent_at, :datetime
  end
end
