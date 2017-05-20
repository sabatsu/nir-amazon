class HomeController < ApplicationController
	include AmazonHelper

	def index
		
	end

	def get_amazon_results		
		AmazonHelper::get_all(params[:key], params[:amount])
		file = open("nir.xls")
		send_file(file, :filename => "nir.xls", :type => "application/xls" , :disposition => "attachment")
	end

end
