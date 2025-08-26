class InvoicesController < ApplicationController
  # GET /invoices or /invoices.json
  def index
    @invoices = Invoice.first(100000)
  end
end
