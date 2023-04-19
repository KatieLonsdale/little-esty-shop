module Testable

  def delete_data
    Transaction.delete_all
    InvoiceItem.delete_all
    Item.delete_all
    Invoice.delete_all
    Merchant.delete_all
    Customer.delete_all
  end

  def us_3_test_data
    delete_data

    @merch_1 = create(:merchant)
    @merch_2 = create(:merchant)

    @cust_1 = create(:customer)
    @cust_2 = create(:customer)
    @cust_3 = create(:customer)
    @cust_4 = create(:customer)
    @cust_5 = create(:customer)
    @cust_6 = create(:customer)
    @cust_7 = create(:customer)

    @item_1 = create(:item, merchant: @merch_1)
    @item_2 = create(:item, merchant: @merch_2)

    # customer 6 - 7 succ transactions(one with item from different merch)
    # switching cust 6 and 1 to make sure method is able to order on its own
    6.times do
      invoice = create(:invoice, status: 1, customer: @cust_6)
      create(:invoice_item, invoice: invoice, item: @item_1)
      create(:transaction, result: 1, invoice: invoice)
    end

    invoice = create(:invoice, status: 1, customer: @cust_6)
    create(:invoice_item, invoice: invoice, item: @item_2)
    create(:transaction, result: 1, invoice: invoice)

    # customer 2 - 5 succ transactions
    5.times do
      invoice = create(:invoice, status: 1, customer: @cust_2)
      create(:invoice_item, invoice: invoice, item: @item_1)
      create(:transaction, result: 1, invoice: invoice)
    end

    # customer 3 - 4 succ transactions
    4.times do
      invoice = create(:invoice, status: 1, customer: @cust_3)
      create(:invoice_item, invoice: invoice, item: @item_1)
      create(:transaction, result: 1, invoice: invoice)
    end

    # customer 4 - 3 succ transactions
    3.times do
      invoice = create(:invoice, status: 1, customer: @cust_4)
      create(:invoice_item, invoice: invoice, item: @item_1)
      create(:transaction, result: 1, invoice: invoice)
    end
    
    # customer 5 - 2 success 2 failures
    2.times do 
      invoice = create(:invoice, status: 1, customer: @cust_5)
      create(:invoice_item, invoice: invoice, item: @item_1)
      create(:transaction, result: 0, invoice: invoice)
      create(:transaction, result: 1, invoice: invoice)
    end

    # customer 1 - one succ transaction
    invoice = create(:invoice, status: 1, customer: @cust_1)
    create(:invoice_item, invoice: invoice, item: @item_1)
    create(:transaction, result: 1, invoice: invoice)
  end

  def us_4_test_data
    delete_data

    @merch_1 = create(:merchant)
    @merch_2 = create(:merchant)

    @item_1 = create(:item, merchant: @merch_1)
    @item_2 = create(:item, merchant: @merch_1)
    @item_3 = create(:item, merchant: @merch_1)
    @item_4 = create(:item, merchant: @merch_2)

    @invoice_1 = create(:invoice, status: 1)
    @invoice_2 = create(:invoice, status: 1)
    @invoice_3 = create(:invoice, status: 1)

    # pending invoice_items - 5 - should appear
    @pending_item_1 = create_list(:invoice_item, 2, item: @item_1, invoice: @invoice_1, status: 0)
    @pending_item_2 = create_list(:invoice_item, 3, item: @item_2, invoice: @invoice_2, status: 0)

    # packaged invoice_items - 6 - should appear
    @packaged_item_1 = create_list(:invoice_item, 2, item: @item_1, invoice: @invoice_3, status: 1)
    @packaged_item_2 = create_list(:invoice_item, 4, item: @item_2, invoice: @invoice_2, status: 1)

    # shipped invoice_items - 2 - should not appear
    create(:invoice_item, item: @item_1, invoice: @invoice_1, status: 2)
    create(:invoice_item, item: @item_3, invoice: @invoice_2, status: 2)

    # other merchant item - should not appear
    create(:invoice_item, item: @item_4, invoice: @invoice_2, status: 0)
  end

  def us_5_test_data
    delete_data

    @merch_1 = create(:merchant)

    @item_1 = create(:item, merchant: @merch_1)
    @item_2 = create(:item, merchant: @merch_1)
    @item_3 = create(:item, merchant: @merch_1)

    @invoice_3 = create(:invoice)
    @invoice_1 = create(:invoice)
    @invoice_2 = create(:invoice)

    @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice_3, status: 0)
    @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice_1, status: 0)
    @invoice_item_3 = create(:invoice_item, item: @item_3, invoice: @invoice_2, status: 0)
  end

  def us_14_test_data
    delete_data

    @merch_1 = create(:merchant)
    @merch_2 = create(:merchant)

    @item_1 = create(:item, merchant: @merch_1)
    @item_2 = create(:item, merchant: @merch_1)
    @item_3 = create(:item, merchant: @merch_1)
    @item_4 = create(:item, merchant: @merch_2)

    @invoice_1 = create(:invoice)
    @invoice_2 = create(:invoice)
    # should not appear on invoices index
    @invoice_3 = create(:invoice)

    # invoice_1 - all merchant items
    create(:invoice_item, item: @item_1, invoice: @invoice_1)
    create(:invoice_item, item: @item_2, invoice: @invoice_1)
    create(:invoice_item, item: @item_3, invoice: @invoice_1)

    # invoice_2 - some merchant items
    create(:invoice_item, item: @item_3, invoice: @invoice_2)
    create(:invoice_item, item: @item_2, invoice: @invoice_2)
    create(:invoice_item, item: @item_4, invoice: @invoice_2)

    # invoice_3 - no merchant items
    create(:invoice_item, item: @item_4, invoice: @invoice_3)
    create(:invoice_item, item: @item_4, invoice: @invoice_3)
  end

  def us_15_test_data
    delete_data

    @merch_1 = create(:merchant)
    @merch_2 = create(:merchant)

    @customer_1 = create(:customer, first_name: "Sally", last_name: "Field")
    @customer_2 = create(:customer, first_name: "Christy", last_name: "Smith")

    @item_1 = create(:item, merchant: @merch_1)
    @item_2 = create(:item, merchant: @merch_1)
    @item_3 = create(:item, merchant: @merch_1)
    @item_4 = create(:item, merchant: @merch_2)

    @invoice_1 = create(:invoice, customer: @customer_1)
    @invoice_2 = create(:invoice)
    @invoice_3 = create(:invoice)

    # invoice_1 - all merchant items
    create(:invoice_item, item: @item_1, invoice: @invoice_1)
    create(:invoice_item, item: @item_2, invoice: @invoice_1)
    create(:invoice_item, item: @item_3, invoice: @invoice_1)

    # invoice_2 - some merchant items
    create(:invoice_item, item: @item_3, invoice: @invoice_2)
    create(:invoice_item, item: @item_2, invoice: @invoice_2)
    create(:invoice_item, item: @item_4, invoice: @invoice_2)

    # invoice_3 - no merchant items
    create(:invoice_item, item: @item_4, invoice: @invoice_3)
    create(:invoice_item, item: @item_4, invoice: @invoice_3)
  end

  def us_16_test_data
    delete_data

    @merch_1 = create(:merchant)
    @merch_2 = create(:merchant)

    @customer_1 = create(:customer, first_name: "Sally", last_name: "Field")

    @item_1 = create(:item, merchant: @merch_1)
    @item_2 = create(:item, merchant: @merch_1)
    # should not appear, not on invoice
    @item_3 = create(:item, merchant: @merch_1)
    # should not appear, not right merchant
    @item_4 = create(:item, merchant: @merch_2)

    @invoice_1 = create(:invoice)

    # mix of merchant 1 and 2 items
    @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice_1, quantity: 3, unit_price: 349, status: 0)
    @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice_1, quantity: 2, unit_price: 1450)
    @invoice_item_3 = create(:invoice_item, item: @item_4, invoice: @invoice_1, quantity: 1, unit_price: 5899)
  end

  def us_9_test_data
    delete_data

    @merch_1 = create(:merchant)

    @item_1 = create(:item, merchant: @merch_1, status: 0)
    @item_2 = create(:item, merchant: @merch_1)
    @item_3 = create(:item, merchant: @merch_1)
  end

  def us_12_test_data
    delete_data

    @merch_1 = create(:merchant)
    # @merch_2 = create(:merchant)

    # $200
    @item_5 = create(:item, merchant: @merch_1)
    # $199.95
    @item_6 = create(:item, merchant: @merch_1)
    # $58.99
    @item_3 = create(:item, merchant: @merch_1)
    # $34.93
    @item_4 = create(:item, merchant: @merch_1)
    # $29
    @item_2 = create(:item, merchant: @merch_1)
    # $10.47 - should not appear on top 5
    @item_1 = create(:item, merchant: @merch_1)

    @invoice_1 = create(:invoice)
    @invoice_2 = create(:invoice)
    # only failed transaction
    @invoice_3 = create(:invoice)

    @transaction = create(:transaction, result: 0, invoice_id: @invoice_3.id)
    @transaction_2 = create(:transaction, result: 1, invoice_id: @invoice_1.id)
    @transaction_3 = create(:transaction, result: 1, invoice_id: @invoice_2.id)

    @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice_1, quantity: 3, unit_price: 349)
    @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice_1, quantity: 2, unit_price: 1450)
    @invoice_item_3 = create(:invoice_item, item: @item_3, invoice: @invoice_1, quantity: 1, unit_price: 5899)
    @invoice_item_4 = create(:invoice_item, item: @item_4, invoice: @invoice_2, quantity: 7, unit_price: 499)
    @invoice_item_5 = create(:invoice_item, item: @item_5, invoice: @invoice_2, quantity: 1, unit_price: 20000)
    @invoice_item_6 = create(:invoice_item, item: @item_6, invoice: @invoice_1, quantity: 5, unit_price: 3999)
    # failed invoice
    @invoice_item_7 = create(:invoice_item, item: @item_6, invoice: @invoice_3, quantity: 1, unit_price: 5000)
  end
end