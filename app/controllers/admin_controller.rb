class AdminController < ApplicationController

  def index
    @top_cust = Customer.all
  end

end