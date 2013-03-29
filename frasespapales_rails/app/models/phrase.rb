class Phrase < ActiveRecord::Base
    attr_accessible :created_date, :origin, :text, :votes, :approved
    
    validates :text, :presence => true,
                     :length => {:minimum => 5, :maximum => 140}
    
    before_validation do
        # Do some cleanup
        if self.text != nil
            self.text = text.lstrip.rstrip
            #remove HTTP, FTP, HTTPS links
            self.text.gsub!(/(?:f|ht)tps?:\/[^\s]+/, '')
            #remove twitter hashtags
            self.text.gsub!(/#[^\s]+/, '')
            #remove twitter mentions (remove just the symbol so that no context is lost)
            self.text.gsub!('@', '')
            self.text.gsub!('"', '')
            self.text.gsub!(/(?i)\s(ja|je|ji|jo|ju|ha|he|hi|ho|hu)+(\s|$)/, '')
        end
    end
end
