When(/^I search a product "(.*)"$/) do |product|
  @product_search_result = search_product(@connection,product)
end

Then(/^the product search result should include "(.*)"$/) do |pattern|
  match_found = false
  @product_search_result.each do |product|
    if product['title'].match(pattern)
      @product_page = product['link']
      match_found = true
      break
    end
  end
  fail("Product was not found on search results.") unless match_found
end

Then(/^the product (description|characteristics|ratings) should exist with$/) do |option,table|
  product_details = product_details(@connection,@product_page)
  input = table.hashes[0]
  case option
  when 'description'
    fail("Product description does not contain \"#{input['description']}\".") unless product_details[option].match(input['description'])
  when 'characteristics'
    input.each do |k,v|
      fail("Product characteristic \"#{k}\" is not \"#{v}\", it is #{product_details[option][k]}.") unless product_details[option][k] == v
    end
  when 'ratings'
    input.each do |k,v|
      fail("Product does not have \"#{v}\" ratings with \"#{k}\", it has #{product_details[option][k]}.") unless product_details[option][k] == v
    end
  end
end

Then(/^the product oldest comment should be (\d+) (months|days) or older$/) do |months,option|
  comments = all_comments(@connection,@product_page)
  age = []
  option
  case option
  when 'months'
    comments.each do |comment|
      if comment['stamp'].match(/(?:mês|meses)/)
        comment['stamp'].gsub!('um','1')
        age << comment['stamp'].match(/^(\d+)/)[0]
      end
    end
  end
  fail("The oldest comment is not #{months} #{option} or older, it is #{age.max}.") unless age.max.to_i >= months.to_i
end

Then(/^the product stock should exist with$/) do |table|
  input = table.hashes[0]
  stock = product_stock(@connection,@product_page,input.keys.first)
  found_store = false
  stock.each do |entry|
    if entry.keys.first.match(input.keys.first)
      fail("The store \"#{entry.keys.first}\" stock is \"#{entry.values.first}\"") unless entry.values.first == input.values.first
      found_store = true
    end
  end
  fail("Could not find stock info for \"#{input.keys.first}\"") unless found_store
end