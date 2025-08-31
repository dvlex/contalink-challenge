class TopTenDaysSellsJob
  include Sidekiq::Job

  def perform(*args)
    invoices = Invoice.all

    InvoiceMailer.test("alex@lexdrel.com").deliver_now
  end
end
