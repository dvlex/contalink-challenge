class TopTenDaysSellsJob
  include Sidekiq::Job

  def perform(*args)
    top_ten_days = Invoice
      .group(Arel.sql("DATE(invoice_date)"))
      .select("DATE(invoice_date) AS day, SUM(total) AS daily_total")
      .order(Arel.sql("daily_total DESC"))
      .limit(10)

    InvoiceMailer.test("alex@lexdrel.com", top_ten_days).deliver_now
  end
end
