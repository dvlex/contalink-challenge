class InvoicesController < ApplicationController
  # GET /invoices or /invoices.json
  def index
      # TODO: it's recommendable to have the timestamps, since, they updated_at is the best way to know if the data is fresh
      # TODO: add a cache versioning strategy that uses filter params
      cache_key = "invoices:index:v#{Invoice.maximum(:invoice_date).to_i}"
      @cached_json = Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
        @invoices = Invoice.all
        render_to_string(partial: "invoices/index", formats: [ :json ])
      end
      render json: @cached_json
  end
end
