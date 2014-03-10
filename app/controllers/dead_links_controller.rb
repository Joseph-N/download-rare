class DeadLinksController < ApplicationController
	before_filter :authenticate_admin!
	before_filter :find_model

	def index
		@dead_links = DeadLink.all
	end

	

	private
	def find_model
		@model = DeadLinks.find(params[:id]) if params[:id]
	end
end