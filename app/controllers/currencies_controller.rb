class CurrenciesController < ApplicationController
	def index
		@currencies = Currency.all
		id = params[:currency][:id] if params[:currency]

		
		if id
			@currency = @currencies.select {|c| c.id == id}.first
			@rate = @currency.rate(nil)
		else
			#@currencies.first
		end 
		
	end

	def show
		id = params[:id]
		if id
			@currency = @currencies.select {|c| c.id == id}.first
			@rate = @currency.rate(nil)
		end
	end
end
