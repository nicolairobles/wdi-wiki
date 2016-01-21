HTTP Routes:
	Login/Signup 						
		"/" (get)
		"/login" (get/post)
		"/signup"
	Categories Page
		"/categories"
		"/categories/:id"
		"/categories/:id/edit"
	Articles Page
		"/articles"
		"articles/:id"
		"articles/:id/edit"

ERB Files
		index.erb 
	Layouts
		layout.erb
		layout_nonuser.erb 
	Login/Singup
		login.erb 
		login_success.erb 
		signup.erb 
		signup_success.erb 
	Categories Page
		categories.erb

Route									Get Requests	ERB File							Post Reqests	ERB File 						Layout File
"/"										get						redirect to "/login"			
"/login"							get						login.erb							post					login_success.erb		layout_nonuser.erb
"/signup"							get						signup.erb						post					login.erb						layout_nonuser.erb
					
"/categories"					get						categories.erb																					layout.erb
"/categories/:id"			get						category.erb					layout.erb
					
"/articles"						get						articles.erb					layout.erb
"/articles/:id"				get						article.erb						layout.erb
"/articles/:id/edit"	get						article_edit.erb			post					article_edit.erb		layout.erb









