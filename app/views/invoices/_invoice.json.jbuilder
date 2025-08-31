json.extract! invoice, :id, :invoice_number, :total, :invoice_date, :status, :active
json.url invoice_url(invoice, format: :json)
