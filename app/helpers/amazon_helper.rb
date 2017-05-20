module AmazonHelper
	
	def self.get_all(param, amount)
		require 'rubygems'
		require 'nokogiri'
		require 'open-uri'
		require 'spreadsheet'

		book = Spreadsheet::Workbook.new
		sheet1 = book.create_worksheet :name => "#{param}"
		sheet1.row(0).concat %w{Name Price URL Page}

		bold = Spreadsheet::Format.new :weight => :bold
		sheet1.row(0).set_format(0, bold)
		sheet1.row(0).set_format(1, bold)
		sheet1.row(0).set_format(2, bold)
		sheet1.row(0).set_format(3, bold)

		counter = 1

		amount.to_i.times { |index|
			url = "https://www.amazon.com/s/field-keywords=#{param}&page=#{index+1}"
			doc = Nokogiri::HTML(open(url,
			    "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36"
			))	

			doc.css(".s-item-container").each do |item|
				name = item.at_css(".s-access-title").text if item.at_css(".s-access-title")
				link = item.at_css(".s-access-detail-page")[:href] if item.at_css(".s-access-detail-page")
				price = "#{item.at_css(".sx-price-whole").text}.#{item.at_css(".sx-price-fractional").text}" if item.at_css(".sx-price-whole") && item.at_css(".sx-price-fractional")

				sheet1.row(counter).push name, price, link, index+1

			  counter += 1
			end
				
		}

		puts 'All done!'
		book.write 'nir.xls'

	end
end