require 'sinatra'
require 'sinatra/json'

# The wordinator takes words supplied from the params hash and gives certain
# statistics on them.
class Wordinator
  def initialize(words)
    @words = words
  end

  def analyze
    json_hash = {}
    @words.each { |word| json_hash[word] = yield(word) }
    json_hash
  end

  def palindrome?
    analyze { |w| w.reverse.downcase == w.downcase }
  end

  def length
    analyze(&:length)
  end

  def capitalized?
    analyze { |w| ('A'..'Z').include?(w[0]) }
  end

  def anagram?
    hash = {}
    @words.each do |word|
      hash[word] = Hash.new(0)
      word.downcase.each_char do |c|
        hash[word][c] += 1
      end
    end
    hash[@words[0]].eql?(hash[@words[1]])
  end
end

get '/' do
  erb :index
end

get '/palindrome/:word' do
  json Wordinator.new([params[:word]]).palindrome?
end

get '/length/:word' do
  json Wordinator.new([params[:word]]).length
end

get '/capitalized/:word' do
  json Wordinator.new([params[:word]]).capitalized?
end

get '/anagram/:word1/:word2' do
  json Wordinator.new([params[:word1], params[:word2]]).anagram?
end
