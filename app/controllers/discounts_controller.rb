class DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.discounts
    
  end

  def show
    @discount = Discount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create 
    discount = Discount.new(discount_params)
    if discount.valid?
      discount.save
      redirect_to merchant_discounts_path
    else
      flash[:notice] = 'Field cannot be blank.'
      redirect_to new_merchant_discount_path(params[:merchant_id])
    end
  end

  def destroy
    Discount.find(params[:id]).destroy
    redirect_to merchant_discounts_path(params[:merchant_id])
  end

  private
  def discount_params
    params.permit(:merchant_id, :percent, :threshold)
  end
end