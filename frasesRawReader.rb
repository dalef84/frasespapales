require 'fileutils'

begin
    text = "Ahora que el papa es argentino"
    rawFileName = "frasesRaw.txt"
    curatedFileName = "frases.txt"
    curatedFileName2 = "rails/ahoraqueelpapaesargentino/frases.txt"
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
                       
    frases = frases.uniq;
    File.open(curatedFileName, 'w') { |file|
        
        frases.each do |frase|
             file.puts(frase)
        end
    }
    
    FileUtils.cp curatedFileName, curatedFileName2
    

    
rescue  Exception => e
    print "Error. #{e}!"
end