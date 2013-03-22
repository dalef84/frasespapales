require 'twitter'

begin
    text = "Ahora que el papa es argentino"
    searchText = "\"#{text}\""
    min_length = 5
    
    Twitter.configure do |config|
        config.consumer_key = "TCjA3zelHm4rsfhZIXjDzw"
        config.consumer_secret = "PQiBSuZPaFg81UdpLE2MTgRqXiZE3FCMIPXG8Ucyq4"
        config.oauth_token = "113621195-0Xq9B5DaFHxbKWz20o4f65gmRsQya5oMblToyWzA"
        config.oauth_token_secret = "qQkKqXx7T8ExLaXTPZtpwcfnUjs0OaJUMe9WLLgFm4"
    end
    
    lastId = 0;
    
    5.times do
        searchResults = Twitter.search(searchText, :count => 5, :since_id => lastId, :result_type => "recent", :lang => "es")
        searchResults.statuses.each do |result|
            result = result.text[/(?i)^.*#{text}\W*(.*)\W*/, 1]
            if result != nil
                result = result.lstrip.rstrip
                #remove HTTP, FTP, HTTPS links
                result.gsub!(/(?:f|ht)tps?:\/[^\s]+/, '')
                #remove twitter hashtags
                result.gsub!(/#[^\s]+/, '')
                #remove twitter mentions (remove just the symbol so that no context is lost)
                result.gsub!('@', '')
                if result.length > min_length
                    puts result
                end
            end
        
        end
        
        lastId = searchResults.max_id
        puts lastId
    end
    
    
rescue  Exception => e
    print "Connection error. #{e}!"
end