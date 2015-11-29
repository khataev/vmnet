require 'date'

class IlyaController < ApplicationController
	@@usd_id = 'R01235'

	#@base_date = Date.new(2014,8,1)	
	#@base_debt = 2200000
	@currency

	def initialize
		@base_date = Date.new(2014,8,1)	
		@base_debt = 2200000
		@base_debt_str = separate_space(@base_debt)
	end

	def index

		@base_rate = usdcur().rate(@base_date) # базовый курс
		puts "base_rate: #{@base_rate}"
		@today_rate = usdcur().rate(nil) # сегодняшний курс

		rel = @today_rate / @base_rate  # отношение курсов
		@cur_debt_str = separate_space((@base_debt * rel).round(0))

	end

	private 

	def usdcur
		currencies = Currency.all
		@currency ||= currencies.select {|c| c.id == @@usd_id}.first
	end

	def separate_space(number)
  		number.to_s.chars.to_a.reverse.each_slice(3).map(&:join).join(" ").reverse
	end
end
