Given(/^I connect to http:\/\/www.worten.pt$/) do
  @connection = connect()
end

Given(/^the connection is closed$/) do
  @connection.close  
end