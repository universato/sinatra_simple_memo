# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

MEMO_FILE = 'sample.json'

def memos
  File.open(MEMO_FILE) do |j|
    JSON.load(j)
  end
end

get '/' do
  @titles = (memos ? memos.keys : {})
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
  memos = memos()
  if memos[@title] || @title == 'new'
    @error = '既にあるタイトルであるため登録できませんした。'
    erb :new
  end
  memos[@title] = @detail
  File.open(MEMO_FILE, 'w+') do |file|
    JSON.dump(memos, file)
  end
  redirect CGI.escape("/#{@title}")
end

get '/:title' do |title|
  @title = title
  @detail = memos[title]
  erb :show
end

get '/:title/edit' do |title|
  @title = title
  @detail = memos[title]
  @action = 'edit'
  @action_jp = '更新'
  erb :edit
end

patch '/:old_title' do |old_title|
  title = params['title'] 
  detail = params['detail']
  memos = memos()
  memos.delete(old_title)
  memos[title] = detail
  File.open(MEMO_FILE, 'w+') do |file|
    JSON.dump(memos, file)
  end
  redirect CGI.escape("/#{title}")
end

delete '/:title' do |title|
  memos = memos()
  memos.delete(title)
  File.open(MEMO_FILE, 'w+') do |file|
    JSON.dump(memos, file)
  end
  redirect '/'
end
