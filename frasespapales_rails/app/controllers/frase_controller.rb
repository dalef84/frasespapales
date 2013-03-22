class FraseController < ApplicationController
  def index

  end
    
  def create
    nuevasFrasesFileName = "nuevasFrases.txt"
      
    # TODO add frase to DB
    fraseText = params[:text]
    if fraseText != nil && fraseText.length > 5
        File.open(nuevasFrasesFileName, 'a') do |file|
            file.puts(fraseText)
        end
    end
    
    redirect_to :back
  end
end
