require 'pry'

require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @chapters = File.readlines('data/toc.txt')
  erb :home
end

get /\/chapters\/(\d+)/ do
  @chap_num = params['captures'].join
  @title = "Chapter #{@chap_num}"
  @chapters = File.readlines('data/toc.txt')
  @chapter = File.read("data/chp#{@chap_num}.txt")
  
  
  erb :chapter
end

# binding.pry

# puts "Hello"