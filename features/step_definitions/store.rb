When(/^I search a store "(.*)"$/) do |store|
  search_store(@connection,store)
end

Then(/^the store search result should include "(.*)"$/) do |pattern|
  match_found = false
  @store_details = store_details(@connection,pattern)
  fail("Store was not found on search results.") if @store_details == 0
end

Then(/^the store details should exist with$/) do |table|
  @store_details
  input = table.hashes[0]
    input.each do |k,v|
      fail("\"#{k}\" is not  \"#{v}\", it is \"#{@store_details[k]}\".") unless @store_details[k] == v
    end
end