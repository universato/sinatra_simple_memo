# frozen_string_literal: true

require 'pg'

# Memo is a class like ActiveRecord in order to make it easy to manage Postgres DB
class Memo
  class MemoError < StandardError; end

  def initialize(title: nil, body: nil)
    @title = title
    @body = body
  end
  attr_accessor :title, :body

  class << self
    def connect
      localhost = ENV['HOST'] || 'localhost'
      port      = ENV['PORT'] || 5432
      dbname    = ENV['DB_NAME'] || 'sinatra_simple_memo_db'
      user      = ENV['USER']
      @connection ||= PG.connect(
        host: localhost,
        port: port,
        dbname: dbname,
        user: user
      )
    end

    def titles
      @connection ||= Memo.connect
      query = 'SELECT title FROM memos'
      result = @connection.exec(query)
      result.map { |data| data['title'] }
    end

    def find_by_title(title)
      query = 'SELECT * FROM memos WHERE title = $1'
      @connection ||= Memo.connect
      @connection.exec(query, [title])[0]
    rescue IndexError
      {}
    end

    def update_by_title(old_title, title, body)
      query = 'UPDATE memos SET title = $1, body = $2 WHERE title = $3'
      @connection ||= Memo.connect
      @connection.exec(query, [title, body, old_title])
    end

    def destroy_by_title(title)
      query = 'DELETE FROM memos WHERE title = $1'
      @connection ||= Memo.connect
      @connection.exec(query, [title])
    end

    def create(title: nil, body: nil)
      memo = Memo.new(title: title, body: body)
      memo.save
    end
  end

  def save
    title.delete!('/')
    1 while title.gsub!(/<script>/i, '')
    raise MemoError if title.strip.chomp.empty? || title == 'new'

    query = 'INSERT INTO memos (title, body) VALUES ($1, $2)'
    @connection ||= Memo.connect
    @connection.exec(query, [title, body])
  rescue MemoError => e
    puts e
  end
end
