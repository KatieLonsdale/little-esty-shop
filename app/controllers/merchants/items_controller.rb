class Merchants::ItemsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = @merchant.items
  end

  def show
    @item = Item.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def edit
    @item = Item.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
    if params[:item]
      if @item.update(item_params)
        flash[:notice] = "Item Successfully Updated!"
        redirect_to "/merchants/#{@merchant.id}/items/#{@item.id}"
      end
    else
      @item.toggle_status
      redirect_to "/merchants/#{@item.merchant.id}/items"
    end
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    if @item = @merchant.items.create(new_item_params)
      redirect_to "/merchants/#{@merchant.id}/items"
    else
      flash[:error] = "Please fill in all required fields"
      render :new
    end
  end

  private
  def item_params
    params.require(:item).permit(:description, :unit_price, :name, :merchant_id, :status)
  end

  def new_item_params
    params.permit(:name, :description, :unit_item)
  end
end