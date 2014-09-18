class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :title
      t.text :list
      t.text :comment
      t.integer :quote_id
      # list = line in quote = [[designation,unit,qte,puht],[]]
      t.decimal :total, :tax_rate, :discount, :total_paid
      t.datetime :starttime, :endtime
      t.references :client, index: true
      t.string :res1, :res2, :res3
      t.timestamps
    end
  end
end
