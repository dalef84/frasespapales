# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'fileutils'

begin
    def write_phrases_in_file(frases)
        File.open(curatedFileName, 'w') { |file|
            frases.each do |frase|
                file.puts(frase)
            end
        }
        FileUtils.cp curatedFileName, curatedFileNameProd
    end

    def delete_records_if_necessary
        if (Phrase.count > 0)
            puts "Deleting all records"
            Phrase.delete_all
        end
    end

    def write_phrases_in_db(frases)
        delete_records_if_necessary
        frases.each do |frase|
            Phrase.create(
              created_date: DateTime.now,
              origin: "Twitter",
              text: frase,
              votes: 0
            )
        end
    end

    text = "Ahora que el papa es argentino"
    searchText = "\"#{text}\""
    rawFileName = File.expand_path("../../../frasesRaw.txt", __FILE__)
    curatedFileName = File.expand_path("../../../frases.txt", __FILE__)
    curatedFileNameProd = File.expand_path("../../frases.txt", __FILE__)
    min_length = 5
    frases = Array.new
    
    contents = File.read(rawFileName)
    contents.lines.each do |line|
        line = line[/(?i)^.*#{text}\W*(.*)\W*/, 1]
        if line != nil
            line = line.lstrip.rstrip
            #remove HTTP, FTP, HTTPS links
            line.gsub!(/(?:f|ht)tps?:\/[^\s]+/, '')
            #remove twitter hashtags
            line.gsub!(/#[^\s]+/, '')
            #remove twitter mentions (remove just the symbol so that no context is lost)
            line.gsub!('@', '')
            line.gsub!('"', '')
            line.gsub!(/(?i)\s(ja|je|ji|jo|ju|ha|he|hi|ho|hu)+(\s|$)/, '')
            if line.length > min_length
                frases.push(line)
            end
        end
    end
                       
    frases = frases.uniq
                       #    write_phrases_in_file(frases)
    write_phrases_in_db(frases)
    puts "Frases Count: " + frases.count.to_s
    
rescue  Exception => e
    puts "Error. #{e}!"
end