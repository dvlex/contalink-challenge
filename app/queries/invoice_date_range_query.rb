class InvoiceDateRangeQuery < InvoicesController
  Result = Struct.new(:json, :error, :status) do
    def success? = json.present?
    def failure? = !success?
  end

  def self.call(params)
    new(params).call
  end

  def initialize(params)
    @start_date = parse_date(params[:start_date])
    @end_date   = parse_date(params[:end_date])
  end

  def call
    return Result.new(nil, "Invalid date format", :bad_request) unless valid_dates?
    return Result.new(nil, "end_date must be after start_date", :unprocessable_entity) unless end_date > start_date
    return Result.new(nil, "end_date cannot be in the future", :unprocessable_entity) if end_date > Time.current

    cache_key = "invoices:index:#{start_date.to_i}_#{end_date.to_i}"

    # debugger
    json = Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      @invoices = Invoice.where(invoice_date: start_date..end_date)
      render_to_string(partial: "invoices/index", formats: [ :json ])
    end

    debugger

    Result.new(json, nil, nil)
  end

  private

  attr_reader :start_date, :end_date

  def parse_date(str)
    DateTime.parse(str) rescue nil
  end

  def valid_dates?
    start_date && end_date
  end
end
