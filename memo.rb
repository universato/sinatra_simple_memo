# frozen_string_literal: true

require 'pg'

# Memo is a class like ActiveRecord in order to make it easy to manage Postgres DB
class Memo
  attr_accessor :title, :detail

  def self.connect
    PG.connect(host: 'localhost', user: 'uni', dbname: 'sinatrasimplememo', port: 5432)
  end

  def self.titles
    connection = Memo.connect
    query = 'SELECT title FROM memos'
    result = connection.exec(query)
    result.map { |data| data['title'] }
  end

  def self.find_by_title(title)
    query = 'SELECT * FROM memos WHERE title = $1'
    Memo.connect.exec(query, [title])[0]
  end

  def self.update_by_title(old_title, title, detail)
    query = 'UPDATE memos SET title = $1, detail = $2 WHERE title = $3'
    Memo.connect.exec(query, [title, detail, old_title])
  end

  def self.destroy_by_title(title)
    query = 'DELETE FROM memos WHERE title = $1'
    Memo.connect.exec(query, [title])
  end

  def self.create(title: nil, detail: nil)
    memo = Memo.new(title: title, detail: detail)
    memo.save
  end

  def initialize(title: nil, detail: nil)
    @title = title
    @detail = detail
  end

  def save
    connection = Memo.connect
    raise 'EmptyTitleError' if title.strip.chomp.empty?
    raise 'InvalidTitleError' if title == 'new'

    query = 'INSERT INTO memos (title, detail) VALUES ($1, $2)'
    connection.exec(query, [title, detail])
  rescue EmptyTitleError, InvalidTitleError => e
    puts e
    nil
  end
end
