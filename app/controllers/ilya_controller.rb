require 'date'
class IlyaController < ApplicationController
	
	@@usd_id = 'R01235'
	@@eur_id = 'R01239'

	def index
    init

		@base_usd_rate = usdcur.rate(@base_date) # базовый курс
		@base_eur_rate = eurcur.rate(@base_date) # базовый курс

		@today_usd_rate = usdcur.rate(nil) # сегодняшний курс

		rel = @today_usd_rate / @base_usd_rate  # отношение курсов
		@cur_debt_str = separate_space((@base_debt * rel).round(0))

		@usd = (@base_debt / @base_usd_rate).round(0)
		@eur = (@base_debt / @base_eur_rate).round(0)

	end

	private 

  def init
    date_format = "%d.%m.%Y"
    @base_date = Date.new(2014,8,1) 

    @today_date = Date.today
    @today_date_str = @today_date.strftime(date_format)

    @base_date_str = @base_date.strftime(date_format)
    @base_debt = 2200000
    @base_debt_str = separate_space(@base_debt)
    @currencies = Currency.all
  end

	def usdcur
		@usd_currency = @currencies.select {|c| c.id == @@usd_id}.first
	end

	def eurcur
		@eur_currency = @currencies.select {|c| c.id == @@eur_id}.first
	end

	def separate_space(number)
  		number.to_s.chars.to_a.reverse.each_slice(3).map(&:join).join(" ").reverse
	end
end
