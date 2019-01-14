require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"

before do
  @contents = File.readlines('data/toc.txt')
end

helpers do
  def in_paragraphs(text)
    text = text.split("\n\n").map.with_index { |para, idx| "<p id=#{idx + 1}> #{para} </p>"}.join(" ")
  end
  
  def paragraph_search(text, search_term)
    para_result = []
    text = text.split("\n\n").each_with_index do |para, idx|
      para_result << {number: idx, content: para} if para.include? search_term
    end
    para_result
  end
  
  def make_bold(text, search_term)
    text = text.gsub(search_term, "<strong>#{search_term}</strong>")
  end
  
  def each_chapter
    @contents.each_with_index do |name, index|
      number = index + 1
      contents = File.read("data/chp#{number}.txt")
      yield number, name, contents
    end
  end
  
  def chapters_matching(query)
    results = []
  
    return results if query.nil? || query.empty?
  
    each_chapter do |number, name, contents|
      results << {number: number, name: name} if contents.include?(query)
    end
  
    results
  end
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  
  erb :home
end

get "/chapters/:number" do
  number = params[:number].to_i
  @title = "Chapter #{number}: " + @contents[number - 1]

  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

get "/show/:name" do
  params[:name]
end

get "/search" do
  @results = chapters_matching(params[:query])
  erb :search
end

not_found do
  redirect("/")
end

# binding.pry

# puts "Hello"