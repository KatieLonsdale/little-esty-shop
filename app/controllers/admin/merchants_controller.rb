class Admin::MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
    @top_five = Merchant.top_five_merch_by_revenue
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
      if @merchant.update(merchant_params_update)
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

  def new
  end

  def create
    @merchant = Merchant.create(merchant_params_create)
    if @merchant
      redirect_to '/admin/merchants'
    else
      flash[:error] = "Please fill in required fields."
      redirect_to '/admin/merchants/new'
    end
  end

  private 
  def merchant_params_update
    params.require(:merchant).permit(:name)
  end

  def merchant_params_create
    params.permit(:name)
  end

  def toggle_merch_status
    if @merchant.enabled?
      @merchant.disabled!
    elsif @merchant.disabled?
      @merchant.enabled!
    end
  end
end