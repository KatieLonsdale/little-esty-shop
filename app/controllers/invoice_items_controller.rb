class InvoiceItemsController < ApplicationController
  def update
    invoice_item = InvoiceItem.find(params[:id])
    invoice_item.update(invoice_items_params)
    redirect_to "/merchants/#{invoice_item.item.merchant_id}/invoices/#{invoice_item.invoice.id}"
  end

  private
  def invoice_items_params
    params.permit(:quantity, :unit_price, :status, :invoice_id, :item_id)
  end
end