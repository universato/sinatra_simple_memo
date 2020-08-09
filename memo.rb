require 'pg'

class Memo
  attr_accessor :title, :detail

  def self.connect
    PG::connect(host: 'localhost', user: 'uni', dbname: 'sinatrasimplememo', port: 5432)
  end

  def self.titles
    connection = Memo.connect
    query = 'SELECT title FROM memos'
    result = connection.exec(query)
    result.map { |data| data['title'] }
  end
  
  def self.find_by_title(title)
    title = Memo.simple_escape(title)
    query = "SELECT * FROM memos WHERE title = '#{title}'"
    Memo.connect.exec(query)[0]
  end
  
  def self.update_by_title(old_title, title, detail)
    old_title = Memo.simple_escape(old_title)
    title = Memo.simple_escape(title)
    detail = Memo.simple_escape(detail)
    query = "UPDATE memos SET title = '#{title}', detail = '#{detail}' WHERE title = '#{old_title}'"
    Memo.connect.exec(query)
  end
  
  def self.destroy_by_title(title)
    title = Memo.simple_escape(title)
    query = "DELETE FROM memos WHERE title = '#{title}'" 
    Memo.connect.exec(query)
  end

  def self.create(title: nil, detail: nil)
    memo = Memo.new(title: title, detail: detail)
    memo.save
  end

  def self.simple_escape(input)
    input.gsub("'", "''")
    # .gsub("/", "'/")
  end

  def initialize(title: nil, detail: nil)
    @title = Memo.simple_escape(title)
    @detail = Memo.simple_escape(detail)
  end

  def save
    connection = Memo.connect
    raise 'EmptyTitleError' if title.strip.chomp.empty?
    raise 'InvalidTitleError' if title == 'new'
    query = "INSERT INTO memos (title, detail) VALUES ('#{title}', '#{detail}')"
    result = connection.exec(query)
  rescue => e
    puts e
    nil
  end
end
