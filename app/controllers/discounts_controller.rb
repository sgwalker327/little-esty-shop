class DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.discounts
    next_three_holidays = HolidaysService.get_holidays.first(3)
    @holidays = next_three_holidays.map { |h| UsHoliday.new(h)}
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

  def edit
    @discount = Discount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    discount = Discount.find(params[:id])
      if discount.update(discount_params)
        redirect_to merchant_discount_path(params[:merchant_id], discount.id)
      else
        flash[:notice] ='Invalid input'
        redirect_to edit_merchant_discount_path(params[:merchant_id], discount.id)
      end
  end

  private
  def discount_params
    params.permit(:merchant_id, :percent, :threshold)
  end
end