# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'bundler'
require './memo'

Bundler.require

get '/' do
  @titles = Memo.titles
  Memo.destroy_by_title("'")
  erb :index
end

get '/new' do
  @title = nil
  @detail = nil
  @action = 'new'
  @action_jp = '保存'
  erb :new
end

post '/' do
  @title = params['title']
  @detail = params['detail']
  memo = Memo.new(title: @title, detail: @detail)
  @action = 'new'
  @action_jp = '保存'
  if memo.save
    redirect CGI.escape("/#{@title}")
  else
    @title = nil
    erb :new
  end
end

get '/:title' do |title|
  memo = Memo.find_by_title(title)
  @title = memo['title']
  @detail = Rack::Utils.escape_html(memo['detail'])
  erb :show
end

get '/:title/edit' do |title|
  memo = Memo.find_by_title(title)
  @title = memo['title']
  @detail = memo['detail']
  @action = 'edit'
  @action_jp = '更新'
  erb :edit
end

patch '/:old_title' do |old_title|
  title = params['title']
  detail = params['detail']
  Memo.update_by_title(old_title, title, detail)
  redirect CGI.escape("/#{title}")
end

delete '/:title' do |title|
  Memo.destroy_by_title(title)
  redirect '/'
end
