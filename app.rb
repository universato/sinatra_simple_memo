# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'bundler'
require_relative './memo'

Bundler.require

get '/' do
  @titles = Memo.titles
  Memo.destroy_by_title("'")
  erb :index
end

get '/new' do
  @title = nil
  @body = nil
  @action = 'new'
  @action_jp = '保存'
  erb :new
end

post '/' do
  @title = params['title']
  @body = params['body']
  memo = Memo.new(title: @title, body: @body)
  @action = 'new'
  @action_jp = '保存'
  if memo.save
    redirect CGI.escape(@title)
  else
    @title = nil
    erb :new
  end
end

get '/:title' do |title|
  memo = Memo.find_by_title(title)
  @title = memo['title']
  @body = memo['body']
  erb :show
end

get '/:title/edit' do |title|
  memo = Memo.find_by_title(title)
  @title = memo['title']
  @body = memo['body']
  @action = 'edit'
  @action_jp = '更新'
  erb :edit
end

patch '/:old_title' do |old_title|
  title = params['title']
  body = params['body']
  Memo.update_by_title(old_title, title, body)
  redirect CGI.escape(title)
end

delete '/:title' do |title|
  Memo.destroy_by_title(title)
  redirect '/'
end

# not_found do
#   'Sinatra Simple Memo: 404 Not Found'
# end
