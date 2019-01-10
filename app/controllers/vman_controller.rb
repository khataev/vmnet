class VmanController < ApplicationController
	before_action :load_vars



	def index

	end

	def off
		r = @v.off
		make_flash(r)
		redirect_to action: "index"
	end

	def on
		r = @v.on
		make_flash(r)
		redirect_to action: "index"
	end

	def make_flash(result)
		if result
			flash[:notice] = "Успешно"
		else
			flash[:notice] = "Неудачно"
		end
	end

	protected
	def load_vars
		@v = Vman.new
	end
end
