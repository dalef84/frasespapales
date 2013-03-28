class Phrase < ActiveRecord::Base
  attr_accessible :created_date, :origin, :text, :votes
end
