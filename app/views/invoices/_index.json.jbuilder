# app/views/invoices/_index.json.jbuilder
json.array! @invoices, partial: "invoices/invoice", as: :invoice
