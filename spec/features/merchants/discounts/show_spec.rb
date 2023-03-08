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
      expect(page).to have_content("Quantity Threshold: #{@discount1.threshold} items")
      expect(page).to have_content("Percent Discount: 20.0%")
      expect(page).to_not have_content("Quantity Threshold: #{@discount2.threshold} items")
      expect(page).to_not have_content("Percent Discount: 33.0%")
    end

    it 'there is a button to edit the discount' do
      expect(page).to have_link("Edit Discount")
    end

    it 'when I click the edit button, I am redirected to the edit page' do
      click_link "Edit Discount"

      expect(current_path).to eq(edit_merchant_discount_path(@merchant21.id, @discount1.id))
      ## Continued on spec/features/merchant/discounts/edit_spec.rb
    end
  end
end