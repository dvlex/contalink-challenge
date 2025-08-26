class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.string :invoice_number, null: false
      t.decimal :total, null: false
      t.datetime :invoice_date, null: false
      t.string :status, null: false, default: "Vigente"
      t.boolean :active, null: false, default: true
    end
  end
end
