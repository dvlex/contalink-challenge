class InvoicesController < ApplicationController
  # GET /invoices or /invoices.json
  before_action :set_dates, only: [ :index ]
  def index
    return Result.new(nil, "Invalid date format", :bad_request) unless valid_dates?
    return Result.new(nil, "end_date must be after start_date", :unprocessable_entity) unless @end_date > @start_date
    return Result.new(nil, "end_date cannot be in the future", :unprocessable_entity) if @end_date > Time.current

    cache_key = "invoices:index:#{@start_date.to_i}_#{@end_date.to_i}"

    @cached_json = Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      @invoices = Invoice.where(invoice_date: @start_date..@end_date)
      render_to_string(partial: "invoices/index", formats: [ :json ])
    end
    render json: @cached_json
  end

  private

  def invoice_params
    params.permit(:start_date, :end_date)
  end

  def set_dates
    @start_date = parse_date(params[:start_date])
    @end_date   = parse_date(params[:end_date])
  end

  def parse_date(str)
    DateTime.parse(str) rescue nil
  end

  def valid_dates?
    @start_date && @end_date
  end
end
