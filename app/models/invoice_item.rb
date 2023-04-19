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

  def formatted_unit_price
    "$#{format('%.2f', (unit_price / 100.to_f ))}"
  end
end