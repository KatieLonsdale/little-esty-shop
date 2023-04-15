require 'rails_helper'
# As a merchant,
# When I visit my merchant items index page ("merchants/merchant_id/items")
# I see a list of the names of all of my items
# And I do not see items for any other merchant
RSpec.describe 'merchant items index page' do
  describe 'when I visit my my items index page' do
    before(:all) do
      Item.delete_all
      Merchant.delete_all
      @merch_1 = create(:merchant)
      @merch_2 = create(:merchant)
      create_list(:item, 10, merchant_id: @merch_1.id)
      create_list(:item, 3, merchant_id: @merch_2.id)

      visit "/merchants/#{@merch_1.id}/items"
    end

    it 'displays a list of the names of all my items' do
  save_and_open_page
      list_of_names = @merch_1.items.pluck('name')
     
      within("#my-items") do
        list_of_names.each do |name|
          expect(page).to have_content(name)
        end
      end
    end
     
    it 'does not display items from other merchants' do

      list_of_names_2 = @merch_2.items.pluck('name')

      within("#my-items") do
        list_of_names2.each do |name|
          expect(page).to_not have_content(name)
        end
      end
    end
  end
end