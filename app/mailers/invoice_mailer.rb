class InvoiceMailer < ApplicationMailer
  def test(email, top_ten_days)
    @top_ten_days = top_ten_days
    mail(to: email, subject: "Test Email from Contalink Challenge") do |format|
      format.html
    end
  end
end
