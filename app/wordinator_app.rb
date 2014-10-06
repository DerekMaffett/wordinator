require 'sinatra'
require 'sinatra/json'

# The wordinator takes words supplied from the params hash and gives certain
# statistics on them.
class Wordinator
  def initialize(words)
    @words = words
  end

  def palindrome?
    analyze { |w| w.reverse.downcase == w.downcase }
  end

  def length?
    analyze(&:length)
  end

  def capitalized?
    analyze { |w| ('A'..'Z').include?(w[0]) }
  end

  def anagram?
    return "Argument error: #{@words.size} for 2" unless @words.size == 2

    hash = {}
    @words.each do |word|
      hash[word] = Hash.new(0)
      word.downcase.each_char do |c|
        hash[word][c] += 1
      end
    end
    hash[@words[0]].eql?(hash[@words[1]])
  end

  private

  def analyze
    json_hash = {}
    @words.each { |word| json_hash[word] = yield(word) }
    json_hash
  end
end

def wordinate(*args)
  query = params[:action].to_s + '?'
  Wordinator.new(args).public_send(query)
end

get '/' do
  erb :index
end

get '/:action/:word' do
  json wordinate(params[:word])
end

get '/:action/:word1/:word2' do
  json wordinate(params[:word1], params[:word2])
end
