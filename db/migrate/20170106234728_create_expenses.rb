class CreateExpenses < ActiveRecord::Migration[5.0]
  def change
    create_table :expenses do |t|
      t.integer :user_id
      t.datetime :date
      t.string :description
      t.float :amount
      t.string :comment

      t.timestamps
    end
  end
end
