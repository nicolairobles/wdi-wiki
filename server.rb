require "sinatra/base"
require "pg"
require "bcrypt"
require "pry"
require "date"
require "time"

module WDIWiki
	
	class Server < Sinatra::Base
		set :method_override, true
		enable :sessions

		def current_user
			if session["user_id"]
				@user ||= db.exec_params(<<-SQL, [session["user_id"]]).first
				SELECT * FROM users WHERE id = $1
				SQL
			end
		end

		get "/" do
			redirect "/signup"
		end

		get "/signup" do
			erb :signup
		end

		post "/signup" do
			db = database_connection
			name = params[:name]
			email = params[:login_email]
			encrypted_password = BCrypt::Password.create(params[:login_password])
			users = db.exec_params("INSERT INTO users (name, email, password) VALUES ($1, $2, $3) RETURNING id", [name, email, encrypted_password])
	    session["user_id"] = users.first["id"]
	    binding.pry
			erb :login 
		end

		get "/login" do
			erb :login
		end

		post "/login" do
			@user = @@db.exec_params("SELECT * FROM users WHERE login_name = $1", [params[login_name]])
			# if @user.length == 0
			# 	@error = "Invalid Username"
			# 	erb :login
			# else
			if @user && params[:login_password] == BCrypt::Password.new(@user["login_password_digest"])
					session["user_id"] = @user["id"]
			end

			login_password = BCrypt::Password.new(@user) # the password already in db
			login_name = params[:login_name]
	 		users = @@db.exec_params(<<-SQL, [params[:login_name],login_password]) 
	      SELECT * FROM users WHERE login_name = ;
	    SQL
	    if login_password == users["login_password_digest"]
		    session["user_id"] = users.first["id"]
	    	binding.pry
				erb :login_success
			else
	  	end
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
			@time = DateTime.parse(@article["edit_date"])
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

		get "/categories" do
			db = database_connection
			@categories = db.exec(
				"SELECT id, title FROM categories"
				).to_a
			erb :categories
		end

		get "/category/:id" do
			db = database_connection
			@id = params[:id]
			@title = db.exec("SELECT title FROM categories WHERE id = #{@id}").first["title"]
			@articles = db.exec(
				"SELECT articles.id AS article_id, articles.title AS article_title, articles.content AS article_content FROM articles INNER JOIN articles_categories ON articles.id = articles_categories.articles_id WHERE articles_categories.categories_id = #{@id}"
				).to_a
			erb :category
		end

		private
		def database_connection
			PG.connect(dbname: WDIWiki)
		end 
		
	end 
	
end








