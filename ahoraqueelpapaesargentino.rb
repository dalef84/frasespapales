fileName = "frases.txt"
min_length = 5

contents = File.readlines(fileName)
frases = contents
puts frases.count

i = Random.rand(frases.count)
puts "Ahora que el Papa es argentino, " + frases[i]