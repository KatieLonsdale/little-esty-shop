class AdminController < ApplicationController

  def index
    @top_cust = Customer.top_five_cust
    @incomplete_invoices = Invoice.in_progress
  end
end
