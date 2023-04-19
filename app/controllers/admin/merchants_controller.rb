class Admin::MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:id])
    if params[:merchant]
      if @merchant.update(merchant_params)
        flash[:notice] = "Merchant information updated successfully"
        redirect_to admin_merchant_path(@merchant)
      else
        render 'edit'
      end
    else
      toggle_merch_status
      redirect_to admin_merchants_path
    end
  end

  private 
  def merchant_params
    params.require(:merchant).permit(:name)
  end

  def toggle_merch_status
    if @merchant.enabled?
      @merchant.disabled!
    elsif @merchant.disabled?
      @merchant.enabled!
    end
  end
end