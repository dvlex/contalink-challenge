json.extract! invoice, :id, :invoice_number, :total, :invoice_date, :status, :active
json.total invoice.total.to_f
