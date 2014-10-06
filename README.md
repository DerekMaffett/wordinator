# Description

This Wordinator API uses Sinatra instead of Rails to provide a streamlined
response for word submissions through the URL. The first parameter is the
action which is to be carried out, followed by the word or words being
analyzed. Examples of analyses that can be carried are whether a word is
capitalized, whether it is a palindrome, how long it is, and whether two words
are anagrams for each other.

As the app took shape, I realized that my routing and methods were all tending
to follow a very similar pattern to what I found investigating the source code
for pundit, so I decided to apply those concepts and metaprogram the routing.
