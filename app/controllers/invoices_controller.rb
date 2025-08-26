class InvoicesController < ApplicationController
  # GET /invoices or /invoices.json
  def index
      cache_key = "invoices:index:v#{Invoice.maximum(:invoice_date).to_i}"
      @cached_json = Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
        @invoices = Invoice.all
        render_to_string(partial: "invoices/index", formats: [ :json ])
      end
      render json: @cached_json
  end
end
