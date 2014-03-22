require 'nokogiri'
require 'colorize'
require 'open-uri'
require 'formatador'

def url_array_from_file(f)

  if File::exists?(f) && !File.zero?(f)
    file = File.open(f, 'r')
    data = file.read
    file.close

    return data.split("\n")

  else
    Formatador.display_line("[red]File does not exist or is empty.")
    return false
  end

end

def url_is_properly_title_cased(url)
  
  begin
    file = open(url)
    html = Nokogiri::HTML(file)

  rescue OpenURI::HTTPError => e
    Formatador.display_line("[yellow]#{url} could not be reached: #{e}[/]")
    return false

  rescue SocketError
    Formatador.display_line("[yellow]#{url} could not be reached.[/]")
    return false
  end  

  headers = html.css('h1, h2, h3, h4, h5, h6')

  headers.each do |header|
    if !header_is_properly_title_cased(header)
      Formatador.display_line("[red]#{url} has issues. Here's the deets.[/]")
      Formatador.display_table([{ :text => "[red]#{header.text}[/]", :tag_name => header.name }])
      Formatador.display_line("")
      return false
    end
  end

  return true

end

def header_is_properly_title_cased(header)
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

  always_lowercase = [
    # Prepositions under 3 characters
    "as", "at", "by", "for", "in", "of", "off", "on", "per", "to", "up", "via",

    # Conjunctions under 3 characters
    "and", "but", "or", "as", "if", "so", "nor", "now"
  ]

  # If it's either first or last, it should always be capitalized, so let's just get that out of the way
  return false  if is_either_first_or_last && word != word.capitalize
  
  # If it's in the always-lowercase list
  return false  if (always_lowercase.include? word.downcase) && word != word.downcase

  # If it's not in the always-lowercase list
  return false  if (!always_lowercase.include? word.downcase) && word == word.downcase

  return true

end


# Run the program!

if ARGV.empty?
  puts "\n  This tool takes a list of URLs in a text file as its only argument.\n  Each URL in the text file should be on its own line."
  Formatador.display_line("[red]Usage: ruby title_case.rb /path/to/filename.txt[/]\n")

else
  puts "\n"

  urls = url_array_from_file(ARGV[0])

  if (urls != false)
    urls.each do |url|
      if url_is_properly_title_cased(url)
        Formatador.display_line("[blue]#{url} is OK![/]")
      end
    end
  end

end

puts "\n"



