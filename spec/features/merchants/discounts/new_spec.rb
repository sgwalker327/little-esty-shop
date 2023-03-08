require 'rails_helper'

RSpec.describe 'merchant/:id/discounts/new', type: :feature do
  describe 'When I visit a merchants new discount page' do
    it ' I see a form to create a new discount' do
      @merchant21 = create(:merchant)
      visit new_merchant_discount_path(@merchant21)
     
      expect(page).to have_content("Create New Discount for #{@merchant21.name}'s")
      expect(page).to have_field("Percent:")
      expect(page).to have_field("Quantity Threshold:")
    end

    it "When I fill out the form and submit it, I'm redirected back to the discount index page, and I see the new disount" do
      @merchant21 = create(:merchant)
      visit new_merchant_discount_path(@merchant21)

      fill_in :percent, with: "0.25"
      fill_in :threshold, with: "13"
      
      click_on "Submit"

      expect(current_path).to eq(merchant_discounts_path(@merchant21))
      expect(page).to have_content("25.0% off 13 or more items")
    end

    
    it 'When I fill in the form wrongly, I see an error message and stay on the form' do
      @merchant21 = create(:merchant)
      visit new_merchant_discount_path(@merchant21)

      fill_in :percent, with: "0.25"
      fill_in :threshold, with: "seagulls"
      
      click_on "Submit"
   
      expect(current_path).to eq(new_merchant_discount_path(@merchant21))
      expect(page).to have_content("Invalid Input")
      expect(page).to_not have_content("0.25% off 13 or more items")
    end

    it 'If I put a percent over 100%, I see an error message' do
      @merchant21 = create(:merchant)
      visit new_merchant_discount_path(@merchant21)

      fill_in :percent, with: "1.5"
      fill_in :threshold, with: "10"

      click_on "Submit"
      save_and_open_page

      expect(current_path).to eq(new_merchant_discount_path(@merchant21))
      expect(page).to have_content("Invalid Input")
    end

    it 'If I put a threshold under 1, I see an error message' do
      @merchant21 = create(:merchant)
      visit new_merchant_discount_path(@merchant21)

      fill_in :percent, with: "1.5"
      fill_in :threshold, with: "-1"

      click_on "Submit"

      expect(current_path).to eq(new_merchant_discount_path(@merchant21))
      expect(page).to have_content("Invalid Input")
    end
  end
end