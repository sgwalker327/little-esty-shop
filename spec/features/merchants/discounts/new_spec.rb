require 'rails_helper'

RSpec.describe 'merchant/:id/discounts/new', type: :feature do
  describe 'When I visit a merchants new discount page' do
    it ' I see a form to create a new discount' do
      @merchant21 = create(:merchant)
      visit new_merchant_discount_path(@merchant21)
      save_and_open_page
      expect(page).to have_content("Create New Discount for #{@merchant21.name}'s")
      expect(page).to have_field("Percent:")
      expect(page).to have_field("Quantity Threshold:")
    end

    it "When I fill out the form and submit it, I'm redirected back to the discount index page, and I see the new disount" do
      @merchant21 = create(:merchant)
      visit new_merchant_discount_path(@merchant21)

      fill_in :percent, with: "0.25"
      fill_in :threshold, with: "13"
      save_and_open_page
      click_on "Submit"

      expect(current_path).to eq(merchant_discounts_path(@merchant21))
      expect(page).to have_content("0.25% off 13 or more items")
    end
  end
end