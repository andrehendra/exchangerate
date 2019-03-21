class CreateExchanges < ActiveRecord::Migration[5.1]
  def change
    create_table :exchanges do |t|
      t.date :date
      t.string :from
      t.string :to
      t.float :rate

      t.timestamps
    end
  end
end
