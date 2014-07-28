class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.string :title
      t.text :list
      # list = line in quote = [[designation,unit,qte,puht],[]]
      t.integer :total
      t.datetime :starttime, :endtime
      t.references :client, index: true
      t.timestamps
    end
  end
end
