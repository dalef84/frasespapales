class HomeController < ApplicationController
  def index
      fileName = "frases.txt"
      min_length = 5
      
      contents = File.readlines(fileName)
      frases = contents
      puts frases.count
      
      i = Random.rand(frases.count)
      @showText = frases[i]
  end
end
