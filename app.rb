require 'sinatra'
require 'sinatra/reloader'
require 'json'

MEMO_FILE = 'sample.json'

def memos
  memos = File.open(MEMO_FILE) do |j|
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
  @action = "new"
  @action_jp = "保存"
  erb :new
end

post '/' do
  p @title = params['title']
  p @detail = params['detail']
  memos = memos()
  if memos[@title] || @title == 'new'
    @error = "既にあるタイトルであるため登録できませんした。"
    erb :new
  end
  memos[@title] = @detail
  File.open(MEMO_FILE, 'w+') do |file|
    JSON.dump(memos, file)
  end
  redirect URI.encode("/#{@title}")
end

get '/:title' do |title|
  @title = title
  @detail = memos[title]
  erb :show
end

get '/:title/edit' do |title|
  @title = title
  @detail = memos[title]
  @action = "edit"
  @action_jp = "更新"
  erb :edit 
end

patch '/:old_title' do |old_title|
  p title = params['title'] 
  p detail = params['detail']
  p memos = memos()
  p memos.delete(old_title)
  p memos[title] = detail
  File.open(MEMO_FILE, 'w+') do |file|
    JSON.dump(memos, file)
  end
  redirect URI.encode("/#{title}")
end

delete '/:title' do |title|
  memos = memos()
  memos.delete(title)
  File.open(MEMO_FILE, 'w+') do |file|
    JSON.dump(memos, file)
  end
  redirect '/'
end
