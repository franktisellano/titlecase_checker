require 'nokogiri'
require 'colorize'
require 'open-uri'
require 'formatador'

urls = ["http://localdev.frank.is/sample.html", "http://localdev.frank.is/sample2.html"]

# table_data = [{:url => 'url', :tag_name => "h1", :original_text => "Here's the thing", :correct_text => "Here's the Thing"}]
# Formatador.display_line('[yellow]Hello World 1[/]')
# Formatador.display_table(table_data)


# table_data2 = [{:url => 'url', :tag_name => "h1", :original_text => "Here's the thing", :correct_text => "Here's the Thing"}]
# Formatador.display_line('[yellow]Hello World[/]')
# Formatador.display_table(table_data2)

# def properly_title_cased?(el)
#   el_text = el.text
#   words = el_text.split

#   words.each_with_index do |w, index|
#     if index == 0
#       word_check(w, 'first')
#     end

#     if index == words.size - 1
#       word_check(w, 'last')
#     end
        
#     word_check(w, index + 1)
#   end
# end

# def word_check(word, position)
#   # The first and last word should always be capitalized, regardless of word length or part of speech.
#   if position == 'first' || position == 'last'
#     puts "#{word} is first or last"
#   end
# end

def url_is_properly_title_cased(url)
  html = Nokogiri::HTML(open(url))
  headers = html.css('h1, h2, h3, h4, h5, h6')

  headers.each do |header|
    return false if !header_is_properly_title_cased(header)
  end

  return true

end

def header_is_properly_title_cased(header)
  puts header
  words = header.text.split

  words.each_with_index do |word, index|

    # If first or last
    if index == 1 || index == words.size - 1
      return false if !word_is_properly_title_cased(word, true)

    # If not
    else
      return false if !word_is_properly_title_cased(word, false)
    end
  end

  return true

end

def word_is_properly_title_cased(word, is_either_first_or_last)

  puts word

  always_lowercase = [
    # Prepositions under 3 characters
    "as", "at", "by", "for", "in", "of", "off", "on", "per", "to", "up", "via",

    # Conjunctions under 3 characters
    "and", "but", "or", "as", "if", "so", "nor", "now"
  ]

  # If it's either first or last, it should always be capitalized, so let's just get that out of the way
  #return true   if is_either_first_or_last && word == word.capitalize
  return false  if is_either_first_or_last && word != word.capitalize
  puts "1"
  
  # If it's in the always-lowercase list
  #return true   if always_lowercase.include? word.downcase && word == word.downcase
  return false  if always_lowercase.include? word.downcase && word != word.downcase
  puts "2"

  # If it's not in the always-lowercase list
  return false  if !always_lowercase.include? word.downcase && word == word.downcase
  #return true   if !always_lowercase.include? word.downcase && word != word.downcase

  puts "3"

  return true

end


# Eventually do it
urls.each do |url|
  if url_is_properly_title_cased(url)
    Formatador.display_line("[green]#{url} is OK![/]")
  else
    Formatador.display_line("[red]#{url} is BAD[/]")
  end
end