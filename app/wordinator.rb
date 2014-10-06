require 'sinatra'
require 'sinatra/json'

class Wordinator
  attr_reader :words
  def initialize(words)
    @words = words
  end

  def palindrome
    json_hash = {}
    @words.each do |word|
      json_hash[word] = (word.reverse.downcase == word.downcase)
    end
    json_hash
  end

  def length
    json_hash = {}
    @words.each { |word| json_hash[word] = word.length }
    json_hash
  end

  def capitalized
    json_hash = {}
    @words.each { |word| json_hash[word] = ('A'..'Z').include?(word[0])}
    json_hash
  end
end

get '/' do
  erb :index
end

get '/palindrome/:word' do
  json Wordinator.new([params[:word]]).palindrome
end

get '/length/:word' do
  json Wordinator.new([params[:word]]).length
end

get '/capitalized/:word' do
  json Wordinator.new([params[:word]]).capitalized
end
