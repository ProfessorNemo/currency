require 'net/http'
require 'rexml/document'
require_relative 'currency_choice'

# Достаем данные с сайта Центробанка и записываем их в XML
begin
  uri = URI.parse('http://www.cbr.ru/scripts/XML_daily.asp'.freeze)
  response = Net::HTTP.get_response(uri)
  doc = REXML::Document.new(response.body)
  nodes = doc.root.elements['/ValCurs'].to_a
rescue SocketError => e
  puts "Ошибка соединения с сервером: #{e.message}"
  abort e.message
end

puts "Текущий курс для какой валюты Вы хотите узнать? Введите число:\n\n"
nodes.each_with_index { |currency_tag, index| puts "#{index + 1}: #{CurrencyChoice.from_xml(currency_tag)}" }
value_index = gets.to_i
until value_index.between?(1, nodes.size)
  value_index = gets.to_i
  puts "Введите число от 1 до #{nodes.size}"
end

# очистить экран
puts "\e[H\e[2J"

puts <<~END
   \nТекущий курс валют на #{doc.elements['ValCurs'].attributes['Date']}:
  #{nodes[value_index - 1].elements['Name'].text}: #{nodes[value_index - 1].elements['Value'].text} руб.
END
