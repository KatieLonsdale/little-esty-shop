class AdminController < ApplicationController

  def index
    @top_cust = Customer.top_five_cust
  end

end