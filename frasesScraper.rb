require 'google-search'

begin
    text = "Ahora que el papa es argentino"
    searchText = "\"#{text}\""
    searcher = Google::Search::Web.new(:query => searchText)
    searcher.each do |result|
        #        contents = result.title.split(/\.|,/)
        result = result.title[/^.*#{text}[\.,\s:;](.*)[\.,\s:;]$/, 1]
        if result != nil
            result = result.lstrip.rstrip
            puts result
        end
    end
rescue  Exception => e
    print "Connection error. #{e}!"
end