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
				db = database_connection
				@user ||= db.exec_params(
					"SELECT * 
					FROM users where id = $1", 
					[session["user_id"]]).first
			else
				{}
			end
		end

		get "/" do
			redirect "/signup"
		end

		get "/signup" do
			erb :signup, :layout => :layout_nonuser
		end

		post "/signup" do
			db = database_connection
			name = params[:name]
			email = params[:login_email]
			encrypted_password = BCrypt::Password.create(params[:login_password])
			users = db.exec_params("INSERT INTO users (name, email, password) VALUES ($1, $2, $3) RETURNING id", [name, email, encrypted_password])
	    session["user_id"] = users.first["id"]
			erb :login 
		end

		get "/login" do
			erb :login, :layout => :layout_nonuser
		end

		post "/login" do
			db = database_connection
	    @user = db.exec_params("SELECT * FROM users WHERE email = $1", [params[:login_email]]).first
	    if @user
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

  	delete "/logout" do
  		session.delete(:user_id)
  		redirect "/login"
  	end

		get "/categories" do
			if current_user["id"]
				db = database_connection
				@categories = db.exec(
					"SELECT id, title FROM categories"
					).to_a
				erb :categories, :layout => :layout
    	else
    		redirect "/login"
      end
		end

		get "/category/:id" do
			if current_user["id"]
				db = database_connection
				@id = params[:id]
				@title = db.exec("SELECT title FROM categories WHERE id = #{@id}").first["title"]
				@articles = db.exec(
					"SELECT articles.id AS article_id, articles.title AS article_title, articles.content AS article_content FROM articles INNER JOIN articles_categories ON articles.id = articles_categories.articles_id WHERE articles_categories.categories_id = #{@id}"
					).to_a
				erb :category, :layout => :layout
			else
    		redirect "/login"
      end
		end

		get "/articles/:id" do
			if current_user["id"]
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
				erb :article, :layout => :layout
			else
    		redirect "/login"
      end
		end

		get "/articles/:id/edit" do
			if current_user["id"]
				db = database_connection
				@id = params[:id]
				@article = db.exec(
					"SELECT users.id, users.name, users.email, articles.title, articles.content, articles.edit_date, articles.author_ID 
					FROM users 
					JOIN articles 
					ON users.id = articles.author_ID 
					WHERE articles.id = #{@id}"
					).first
				erb :article_edit, :layout => :layout
			else
    		redirect "/login"
      end
		end

		put "/articles/:id/edit" do
			if current_user["id"]
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
				erb :article_edit, :layout => :layout
			else
    		redirect "/login"
      end
		end

		get "/user/:id" do
			binding.pry
			if current_user["id"]
				binding.pry
				db = database_connection
				@id = params[:id]
				@user_profile = db.exec(
					"SELECT * FROM users WHERE id = #{@id}"
					)
				binding.pry
				erb :user
			else
    		redirect "/login"
      end
		end


		private
		def database_connection
			PG.connect(dbname: WDIWiki)
		end 
		
	end 
	
end
