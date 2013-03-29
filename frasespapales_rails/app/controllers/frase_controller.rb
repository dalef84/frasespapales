class FraseController < ApplicationController
  def index

  end
    
  def create
      # TODO add model validation
    phraseText = params[:text]
    if phraseText != nil && phraseText.length > 5
        Phrase.create(
              created_date: DateTime.now,
              origin: "Website",
              text: phraseText
        )
        logger.debug "Created #{phraseText} phrase."
    end
    
    redirect_to :back
  rescue  Exception => e
      logger.debug "Error creating phrase. #{e}!"
      redirect_to :back
  end
end
