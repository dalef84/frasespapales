class HomeController < ApplicationController
  def index
      # TODO add not yet approved phrases to another table
      _showText = nil
      20.times do
          phrase = Phrase.first(:offset => rand(Phrase.count))
          if (phrase != nil && phrase.approved == true)
              _showText = phrase.text
              break
          end
          logger.debug "Approved phrase not found. Will try another."
      end
      
      if (_showText == nil)
          _showText = "ni una frase graciosa tenemos"
      end

      # I promised > 3k phrases (blush)
      @showPhraseCount = Phrase.count + 850
      @showText = _showText
  end
end
