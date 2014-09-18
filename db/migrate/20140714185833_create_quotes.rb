class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.string :title
      t.integer :status
      t.text :list
      t.text :comment
      # list = line in quote = [[designation,unit,qte,puht],[]]
      t.decimal :total, :tax_rate, :discount
      t.datetime :starttime, :endtime
      t.references :client, index: true
      t.string :res1, :res2, :res3
      t.timestamps
    end
  end
end
