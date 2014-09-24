class CreateSubInvoices < ActiveRecord::Migration
  def change
    create_table :sub_invoices do |t|
      t.string :title
      t.text :comment
      t.integer :status
      t.integer :echeance
      t.decimal :total
      t.datetime :starttime, :endtime
      t.references :invoice, index: true
      t.timestamps
    end
  end
end
