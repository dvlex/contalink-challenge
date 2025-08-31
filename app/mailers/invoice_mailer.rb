class InvoiceMailer < ApplicationMailer
  def test(email)
    mail(to: email, subject: "Test Email from Contalink Challenge") do |format|
      format.text { render plain: "This is a test email to verify SMTP settings." }
    end
  end
end
