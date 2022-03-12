def connect()
	browser = Watir::Browser.new
	detail_url = 'https://www.worten.pt'
	browser.goto detail_url
	sleep(2)
	browser.button(:text => 'Aceitar Tudo').click
	sleep(1)
	return browser
end

# takes a search string and returns parsed results (in this case we are interested in the product title and link)
# returns an array of hashes: [{title => title1, link => link1}]
def search_product(browser,search_string)
	search_url = 'https://www.worten.pt/search?query=' + search_string.gsub(' ','+')
	browser.goto search_url
	sleep(1)
	result = Nokogiri::HTML(browser.html)
	# parse the search results
	result_array = []
	result.css('div.w-product__wrapper').each do |entry|
		entry_hash = {}
		entry_hash['title'] = entry.css('h3').text.match(/^\n\s+(.*)\s?\n\s+$/)[1]
		entry_hash['link'] = entry.at('a')['href']
		result_array << entry_hash
	end
	return result_array
end

def product_details(browser,product)
	detail_url = 'https://www.worten.pt' + product
	browser.goto detail_url
	browser.scroll.to :bottom
	sleep(3)
	result = Nokogiri::HTML(browser.html)
	# hash with the product details
	details = {}
	# description
	details['description'] = result.css('div.w-product-about__info__wrapper').text
	# characteristics
	details['characteristics'] = {}
	result.css('div.w-product-details__wrapper').css('li.clearfix').each do |item|
		details['characteristics'][item.css('span.details-label').to_s.match(/^.*<\/span>(.*)<\/span>$/)[1]] = item.css('span.details-value').text
	end
	# ratings
	details['ratings'] = {}
	ratings = result.css('div.bv-inline-histogram-ratings-score').css('span.bv-off-screen')
	ratings.each do |rating|
		quantity, stars = rating.text.match(/(\d+)\savaliaç(?:ão|ões)\scom\s(\d)\sestrelas?./).captures
		details['ratings']["#{stars} stars"] = quantity
	end

	return details
end

def product_stock(browser,product,store_string)
	detail_url = 'https://www.worten.pt' + product
	browser.goto detail_url
	sleep(1)
	browser.div(:class => 'w-product__store-stock').click
	sleep(1)
	#result = Nokogiri::HTML(browser.html)
    browser.input(:id => 'w-modal--store-stock__search__input').click
    sleep(1)
    browser.send_keys store_string
    sleep(1)
	browser.button(:class => 'w-button-primary w-modal--store-stock__search__button').click
	sleep(3)
	result = Nokogiri::HTML(browser.html)
	store_stock = []
	result.css('div.store-stock__results__items__details').each do |store|
		stock_status = store.css('div.store-stock__results__items__details__stock').text.match(/^\s\n\s+(.*)\n/)[1]
		stock = {}
		stock["#{store.at('p').text.match(/^\n\s+(.*)\s?\n\s+$/)[1]}"] = stock_status
		store_stock << stock
	end
	return store_stock
end

def search_store(browser,search_string)
	search_url = 'https://www.worten.pt/lojas-worten?search=' + search_string.gsub(' ','+')
	browser.goto search_url
end

def store_details(browser,store_string)
	result = Nokogiri::HTML(browser.html)
	# list all stores if they are not visible
	if result.css('section.w-section__wrapper').to_s.match('Visualizar todas as lojas')
		browser.button(:text => 'Visualizar todas as lojas').click
	end
	store_href = ""
	result.css('section.w-store-block').each do |elem|
		if elem.to_s.match(store_string)
			store_href = elem.css('a.w-button-secondary').at('a')['href']
		end
	end
	if store_href == ""
		return 0
	end
	store_url = 'https://www.worten.pt' + store_href
	browser.goto store_url
	result = Nokogiri::HTML(browser.html)
	details = {}
	details['Coordenadas'] = result.css('span.w-store__geolocation').first.text
	details['Horário']     = result.css('div.w-store-details__schedule').css('p').first.text
	return details
end
	
# takes a product href and gets all comments (for this case we are only interested in the timestamp)
# returns an array of hashes: [{stamp => stamp1}, {stamp => stamp2}]
def all_comments(browser,product_href)
	product_url = 'https://www.worten.pt' + product_href
	comments = []
	last_page = false
	while !last_page
		browser.goto product_url
		# scroll to bottom and wait some time to load elements
		browser.scroll.to :bottom
		sleep(2)
		result = Nokogiri::HTML(browser.html)
		# check if there are more comment pages
		if result.xpath('/html/body/div[5]/div/div/section[3]/div/div/div/div/div/div[2]/div/div/div/div/div[3]/div/ul/li[2]/a').empty?
			last_page = true
		else
			product_url = result.xpath('/html/body/div[5]/div/div/section[3]/div/div/div/div/div/div[2]/div/div/div/div/div[3]/div/ul/li[2]/a/@href').first.value
		end
		#parse the comments
 		result.css('span.bv-content-datetime-stamp')
		result.css('span.bv-content-datetime-stamp').each do |stamp|
			stamp
			stamp.text
			item = {}
			item['stamp'] = stamp.text
			comments << item
		end
	end
	return comments
end

# takes a product href and adds it to the cart
def add_product_to_cart(browser,product_href)
	product_url = 'https://www.worten.pt' + product_href
	browser.goto product_url
	sleep(1)
	browser.button(:text => 'Adicionar ao Carrinho').click
	# sometime for the click to take effect
	sleep(2)
end

# returns the cart details
def cart_details(browser)
	product_url = 'https://www.worten.pt/carrinho'
	browser.goto product_url
	sleep(1)
	result = Nokogiri::HTML(browser.html)

	details = {} 
	details['items'] = result.xpath('/html/body/div[4]/header/div[1]/div[2]/div[2]/a/span').text.to_i
	# in our case we will assume there is only one item and the only detail we need is the price
	euro = result.css('td.shopcart__item__val').css('span.w-product-price__main')
	cent = result.css('td.shopcart__item__val').css('sup.w-product-price__dec')
	if euro.size == 2
		price = euro[1].text + "." + cent[1].text
	else
		price = euro.text + "." + cent.text
	end
	details['item_price']     = price.to_f
	details['shipping_price'] = result.css('span#estimated-shipping-price').text.gsub('€','').gsub(',','.').to_f
	details['cart_total']     = result.css('dd#cart-total').text.gsub('€','').gsub(',','.').to_f
	return details
end