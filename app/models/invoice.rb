class Invoice < ApplicationRecord
  before_commit :clear_invoice_cache
  before_destroy :clear_invoice_cache

  def delete
    raise "Don't use DELETE, since it doesn't use transactions neither callbacks, use 'destroy' instead"
  end

  private

  def clear_invoice_cache
    Rails.cache.delete_matched("invoices:index:*")
  end
end
