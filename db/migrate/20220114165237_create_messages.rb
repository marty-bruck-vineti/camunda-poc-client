class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.column :body, :text
      t.column :received_date, :datetime
    end
  end
end
