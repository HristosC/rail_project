class CreateSalts < ActiveRecord::Migration[6.0]
  def change
    create_table :salts do |t|
      t.integer :user_id
      t.string :salt_str
      t.string :token

      t.timestamps
    end
  end
end