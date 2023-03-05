require 'rails_helper'

RSpec.describe 'merchant/:id/discounts/:id', type: :feature do
  before do
    @merchant21 = create(:merchant)
    @merchant22 = create(:merchant)
    @discount1 = @merchant21.discounts.create!(merchant_id: @merchant21.id, percent: 0.2, threshold: 10)
    @discount2 = @merchant21.discounts.create!(merchant_id: @merchant21.id, percent: 0.33, threshold: 20)
    visit merchant_discount_path(@merchant21.id, @discount1.id)
  end

  describe 'when I visit a discount show page' do
    it 'displays the discount\'s attributes' do
      expect(page).to have_content("Discount #{@discount1.id}'s Page")
      expect(page).to have_content("Quantity Threshold: #{@discount1.threshold}")
      expect(page).to have_content("Percent Discount: #{@discount1.percent}")
      expect(page).to_not have_content("Quantity Threshold: #{@discount2.threshold}")
      expect(page).to_not have_content("Percent Discount: #{@discount2.percent}")
    end
  end
end