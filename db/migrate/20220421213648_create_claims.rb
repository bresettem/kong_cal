class CreateClaims < ActiveRecord::Migration[7.0]
  def change
    create_table :claims do |t|
      t.date :claimed, null: false

      t.timestamps
    end
  end
end