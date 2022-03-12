Given(/^I add the product to the cart$/) do
  add_product_to_cart(@connection,@product_page)
end

Then(/^cart should have "(\d)" items?$/) do |number_of_items|
  details = cart_details(@connection)
  fail("The cart does not have #{number_of_items} items, it has #{details['items']}.") unless number_of_items.to_i == details['items'].to_i
end

Then(/^the cart total value should be valid$/) do
  details = cart_details(@connection)
  unless details['cart_total'] == details['item_price'] + details['shipping_price'] 
    fail("The cart total is not valid: 
          Item price: #{details['item_price']} 
          Shipping: #{details['shipping_price']} 
          Cart total: #{details['cart_total']}")
  end
end