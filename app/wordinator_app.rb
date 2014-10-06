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
    unless @words.size == 2
      return "Anagram argument error: #{@words.size} for 2"
    end

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
  rescue NoMethodError
    redirect to('/wow-very-error-much-sorry')
end

get '/' do
  erb :index
end

get '/wow-very-error-much-sorry' do
  erb :error
end

# FIXME: This implementation is still unwieldy since it requires expansion for
# every new word that gets tested. Ideally, these routes should be reduced to
# no more than one - they have been left at three simply to demonstrate
# the app's capabilities.

get '/:action/:word?/?' do
  json wordinate(params[:word])
end

get '/:action/:word1/:word2?/?' do
  json wordinate(params[:word1], params[:word2])
end

get '/:action/:word1/:word2/:word3?/?' do
  json wordinate(params[:word1], params[:word2], params[:word3])
end


