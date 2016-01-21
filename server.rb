require "sinatra/base"
require "pg"
require "bcrypt"

module WDIWiki
	
	class Server < Sinatra::Base
		get "/signup" do
			erb :signup
		end	

	end 
	
end