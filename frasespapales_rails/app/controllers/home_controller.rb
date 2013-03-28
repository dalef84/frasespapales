class HomeController < ApplicationController
  def index
      phrase = Phrase.first(:offset => rand(Phrase.count))
      @showText = phrase.text
      
      @showPhraseCount = Phrase.count
  end
end
