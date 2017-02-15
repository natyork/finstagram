helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end
end

get '/' do
  @posts = Post.order(created_at: :desc)
  erb(:index)  
end

get '/login' do
  erb(:login)
end

get '/logout' do
  session[:user_id] = nil
  redirect to('/')
end

get '/posts/new' do
  if current_user
    @post = Post.new
    erb(:"posts/new")
  else
    redirect to('/')
  end
end

get '/posts/:id' do
  @post = Post.find(params[:id])
  erb(:"posts/show")
end

get '/signup' do
  @user = User.new
  erb(:signup)
end

post '/login' do
  username = params[:username]
  password = params[:password]

  user = User.find_by(username: username)
  
  if user && user.password == password
    session[:user_id] = user.id
    redirect to('/')
  else
    @error_message = "Login failed."
    erb(:login)
  end
end

post '/posts' do
  photo_url = params[:photo_url]
  
  @post = Post.new({ photo_url: photo_url, user_id: current_user.id }) 
  
  if @post.save
    redirect to('/')
  else
    erb(:"posts/new")
  end
end

post '/signup' do
  
  #get user input value from params
  email = params[:email]
  avatar_url = params[:avatar_url]
  username = params[:username]
  password = params[:password]
  
  #instantiate a User
  @user = User.new({ email: email, avatar_url: avatar_url, username: username, password: password })
  
  #if user validations pass and user is saved
  if @user.save
    session[:user_id] = @user.id
    redirect to('/')
  else
    erb(:signup)
  end
end
