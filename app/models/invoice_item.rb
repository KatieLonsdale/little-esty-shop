class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  enum status: { pending: 0, packaged: 1, shipped: 2 }

  def item_name
    item.name
  end

  def invoice_date
    invoice.created_at.strftime("%A, %B %d, %Y")
  end
end