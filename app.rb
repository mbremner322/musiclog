require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require "sinatra/json"
require './models.rb'
use Rack::Session::Cookie
enable :sessions
get '/' do
    erb :home
end

get '/signup' do
    erb :signup
end

get '/login' do
    erb :signin
end

get '/marieonly' do
    @user = User.all
    @post = Contribution.all
    erb :marieOnly
end

get '/search' do
    @search = params[:search]
    @contents = Contribution.where({artistName: @search})
    erb :searchResult
end

post '/deleteuser/:id' do
    user = User.find_by_id(params[:id])
    user.destroy
    redirect '/marieonly'
end

post '/deletepost/:id' do
    post = Contribution.find_by_id(params[:id])
    post.destroy
    redirect '/marieonly'
end

post '/edit/:id' do
    @post = Contribution.find_by_id(params[:id])
    erb :editpost
end

post '/updatePost/:id' do
    songTitle = params[:songTitle]
    link = params[:link]
    artistName = params[:artist]
    body = params[:body]
    body = body.gsub!"{", "<span class='time'>"
    body = body.gsub!"}", "</span>"
    content = Contribution.find_by_id(params[:id])
    content.update({
        songTitle: songTitle,
        artistName: artistName,
        link: link,
        body: body,
        author: session[:user],
        like: 0
    })
    redirect '/marieonly'
end

post '/signup' do
    @user = User.create(mail:params[:username],name:params[:name],password:params[:password],password_confirmation:params[:password_confirmation])
    if @user != nil
        session[:user]=@user.id
    end
    redirect '/dashboard'
end

post '/login' do
    user = User.find_by_mail(params[:username])
    if user && user.authenticate(params[:password])
        session[:user]=user.id
    else
        flash[:error] = "wrong username or password plaese try again"
        redirect '/login'
    end
    redirect '/dashboard'
end

get '/signout' do
    session[:user] = nil
    redirect '/'
end


get '/dashboard'do
    userid = session[:user]
    @user = User.find_by_id(userid)
    @username = @user.name
    @contents = Contribution.order('id desc').all
    erb :dashboard
end

get '/myPage' do
    userid = session[:user]
    @user = User.find_by_id(userid)
    @username = @user.name
    @contents = Contribution.where({author:userid})
    erb :myPage
end

get '/newPost' do
    erb :newPost
end

post '/createNewPost' do
    songTitle = params[:songTitle]
    link = params[:link]
    artistName = params[:artist]
    body = params[:body]
    body = body.gsub!"{", "<span class='time'>"
    body = body.gsub!"}", "</span>"
    Contribution.create({
        songTitle: songTitle,
        artistName: artistName,
        link: link,
        body: body,
        author: session[:user],
        like: 0
    })
    redirect '/dashboard'
end

get '/readPost/:id' do
    userid = session[:user]
    @user = User.find_by_id(userid)  
    @username = @user.name 
    id = params['id']
    @post = Contribution.find_by_id(id)
    @author = User.find_by_id(@post.author).name
    @songTitle = @post.songTitle
    @artistName = @post.artistName
    @link = @post.link
    @body = @post.body
    erb :post
end

get '/user/:id' do
   
    if (params['id'] == session[:user].to_s)
        redirect '/myPage'
    else
        userid = params['id'].to_i
        @user = User.find_by_id(userid)
        @username = @user.name
        @contents = Contribution.where({author:userid})
        erb :myPage
    end
end


post '/like/:id' do
    id = params[:id]
    post = Contribution.find_by_id(id)
    post.like += 1
    post.save
    redirect '/dashboard'
end

