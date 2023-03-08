require 'rails_helper'

RSpec.describe 'merchant/:id/discounts/:id/edit', type: :feature do
  before do
    @merchant21 = create(:merchant)
    @merchant22 = create(:merchant)
    @discount1 = @merchant21.discounts.create!(merchant_id: @merchant21.id, percent: 0.2, threshold: 10)
    @discount2 = @merchant21.discounts.create!(merchant_id: @merchant21.id, percent: 0.33, threshold: 20)
    visit edit_merchant_discount_path(@merchant21.id, @discount1.id)
  end

  describe 'when I visit the edit merchant discount page' do
    it 'It displays an edit discount form with prepopulated discount info' do
      
      expect(page).to have_content("Edit Discount ##{@discount1.id}")
      expect(page).to have_field("Percent:")
      expect(page).to have_field("Quantity Threshold:")
      expect(page).to have_field("Quantity Threshold:", with: "10")
      expect(page).to have_field("Percent:", with: "0.2")
    end

    it 'I change any/all of the information and click submit, I am redirected to the discount show page and see the new info' do
      fill_in "Percent", with: "0.5"

      click_on "Submit"
      
      expect(current_path).to eq(merchant_discount_path(@merchant21, @discount1))
      expect(page).to have_content("Percent Discount: 50.0%")
      expect(page).to have_content("Quantity Threshold: 10")
    end

    it 'If I fill out the form incorrectly, I see an error message and stay on the form' do
      fill_in :percent, with: "0.5"
      fill_in :threshold, with: "seagulls"

      click_on "Submit"
     
      expect(current_path).to eq(edit_merchant_discount_path(@merchant21, @discount1))
      expect(page).to have_content("Invalid input")
    end

    it 'If I put a percent over 100%, I see an error message' do
      fill_in :percent, with: "1.5"
      fill_in :threshold, with: "10"

      click_on "Submit"

      expect(current_path).to eq(edit_merchant_discount_path(@merchant21, @discount1))
      expect(page).to have_content("Invalid input")
    end

    it 'If I put a threshold under 1, I see an error message' do
      # visit end_merchant_discount_path(@merchant21, @discount1)

      fill_in :percent, with: "1.5"
      fill_in :threshold, with: "-1"

      click_on "Submit"

      expect(current_path).to eq(edit_merchant_discount_path(@merchant21, @discount1))
      expect(page).to have_content("Invalid input")
    end
  end
end