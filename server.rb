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
			binding.pry
			encrypted_password = BCrypt::Password.create(params[:login_password])
			users = db.exec_params("INSERT INTO users (name, email, password) VALUES ($1, $2, $3) RETURNING id", [name, email, encrypted_password])
	    session["user_id"] = users.first["id"]
			erb :login 
		end

		get "/login" do
			erb :login
		end

		# post "/login" do
		# 	db = database_connection
		# 	login_email = params[:login_email]
		# 	login_password = params[:login_password]
		# 	@user = db.exec_params("SELECT * FROM users WHERE email = $1", [login_email]).first
		# 	# if @user.length == 0
		# 	# 	@error = "Invalid Username"
		# 	# 	erb :login
		# 	# else
		# 	binding.pry
		# 	if @user && login_password == BCrypt::Password.new(@user["login_password_digest"])
		# 			session["user_id"] = @user["id"]
		# 			binding.pry
		# 	end

		# 	login_password = BCrypt::Password.new(@user) # the password already in db
		# 	login_email = params[:login_email]
	 # 		users = db.exec_params(<<-SQL, [params[:login_email],login_password]) 
	 #      SELECT * FROM users WHERE login_name = ;
	 #    SQL
	 #    if login_password == users["login_password_digest"]
		#     session["user_id"] = users.first["id"]
	 #    	binding.pry
		# 		erb :login_success
		# 	else
	 #  	end
		# end

		post "/login" do
			db = database_connection
	    @user = db.exec_params("SELECT * FROM users WHERE email = $1", [params[:login_email]]).first
	    if @user
	    		binding.pry
	      if BCrypt::Password.new(@user["password"]) == params[:login_password]
	        session["user_id"] = @user["id"]
	        redirect "/categories"
	      else
	        @error = "Invalid Password"
	        erb :login
	      end
	    else
	      @error = "Invalid Username"
	      erb :login
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
