require "sinatra/base"
require "pg"
require "bcrypt"
require "pry"

module WDIWiki
	
	class Server < Sinatra::Base
		get "/" do
			redirect "/signup"
		end

		get "/signup" do
			erb :signup
		end	

		get "/articles/:id" do
			db = database_connection
			@id = params[:id]
			@article = db.exec(
				"SELECT users.name, users.email, articles.title, articles.content, articles.edit_date, articles.author_ID 
				FROM users 
				JOIN articles 
				ON users.id = articles.author_ID 
				WHERE articles.id = #{@id}"
				).first
			binding.pry
			erb :article
		end

		private

		def database_connection
			PG.connect(dbname: WDIWiki)
		end 
		
	end 
	
end