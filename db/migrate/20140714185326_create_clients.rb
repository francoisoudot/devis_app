class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :ln_fl
      t.string :address
      t.string :postal_code
      t.string :city
      t.string :phone,:company
      t.string :res1, :res2, :res3

      t.timestamps
    end
  end
end
