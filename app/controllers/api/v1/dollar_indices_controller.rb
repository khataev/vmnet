class Api::V1::DollarIndicesController < ApplicationController
	respond_to :json

	def broad
		respond_with DollarIndex.data
	end
end