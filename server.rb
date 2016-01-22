require "sinatra/base"
require "pg"
require "bcrypt"
require "pry"
require "date"

module WDIWiki
	
	class Server < Sinatra::Base
		set :method_override, true

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
				"SELECT users.id, users.name, users.email, articles.title, articles.content, articles.edit_date, articles.author_ID 
				FROM users 
				JOIN articles 
				ON users.id = articles.author_ID 
				WHERE articles.id = #{@id}"
				).first
			@time = Date.parse(@article["edit_date"])
			binding.pry
			erb :article
		end

		get "/articles/:id/edit" do
			db = database_connection
			@id = params[:id]
			@article = db.exec(
				"SELECT users.id, users.name, users.email, articles.title, articles.content, articles.edit_date, articles.author_ID 
				FROM users 
				JOIN articles 
				ON users.id = articles.author_ID 
				WHERE articles.id = #{@id}"
				).first
			erb :article_edit
		end

		put "/articles/:id/edit" do
			db = database_connection
			@id = params[:id]
			content = params["content"]
			db.exec_params("UPDATE articles SET content = $1, edit_date = $2 WHERE id = $3", [content, Time.now, @id])
			@article = db.exec(
				"SELECT users.id, users.name, users.email, articles.title, articles.content, articles.edit_date, articles.author_ID 
				FROM users 
				JOIN articles 
				ON users.id = articles.author_ID 
				WHERE articles.id = #{@id}"
				).first
			erb :article_edit
		end

		private
		def database_connection
			PG.connect(dbname: WDIWiki)
		end 
		
	end 
	
end








