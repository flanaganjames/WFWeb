class ScrabbleWord
	attr_accessor :astring, :xcoordinate, :ycoordinate, :direction, :score, :supplement
	
	def initialize (astring, xcoordinate, ycoordinate, direction, score, supplement)
		@astring = astring
		@xcoordinate = xcoordinate
		@ycoordinate = ycoordinate
		@direction = direction
		@score = score
		@supplement = supplement
	end
	
	def print (source)
		puts "#{source}>  #{self.astring}, x=#{self.xcoordinate}, y=#{self.ycoordinate}, dirx: #{self.direction}, score: #{self.score}, suppl: #{self.supplement}, total: #{self.score + self.supplement}"
	end
	
	def wordfindcontains (tileset)
	possibles = []
	tiles = tileset.to_chars
	tiles_plus_anchor = tiles + self.astring.to_chars
	tilepower = tiles_plus_anchor.powerset
	anchorword_plus = self.astring.iscontainedwords
	tilepower_words = []
	tilepower.each {|array| tilepower_words << array.sort.join('') }
	anchor_words = anchorword_plus.select {|word| tilepower_words.include?(word.scan(/./).sort.join(''))}
	anchor_words.each { |word|
		
		case
		when self.direction == 'right'
			possible = ScrabbleWord.new(word, self.xcoordinate,  self.ycoordinate - (word =~ /#{Regexp.quote(self.astring)}/), self.direction, 0, 0)
			
		when self.direction == 'down'
			possible = ScrabbleWord.new(word, self.xcoordinate - (word =~ /#{Regexp.quote(self.astring)}/),  self.ycoordinate, self.direction, 0, 0)
			
		end
		possibles.push(possible)
		}
	return possibles
	end
		
	def wordfindinline (tiles) #tiles is a set of letters as a single string
	possibles = []
	strings = $tilepermutedset.collect {|astring| self.astring + astring} #words that can be made with the the target word + tiles placed after the target word
	words = strings.select {|astring| astring.isaword} 
	words.each { |word|
		case
		when self.direction == 'right'
			possible = ScrabbleWord.new(word, self.xcoordinate,  self.ycoordinate, self.direction, 0, 0)
		when self.direction == 'down'
			possible = ScrabbleWord.new(word, self.xcoordinate,  self.ycoordinate , self.direction, 0, 0)
		end
		possibles.push(possible)
		}
	
	strings = strings + $tilepermutedset.collect {|astring| astring + self.astring}.select {|astring| astring.isaword}  #words that can be made with the the target word + tiles placed before the target word
	words.each { |word|
		offset = (word =~ /#{Regexp.quote(self.astring)}/)
		case
		when self.direction == 'right'
			possible = ScrabbleWord.new(word, self.xcoordinate,  self.ycoordinate - offset, self.direction, 0, 0)
		when self.direction == 'down'
			possible = ScrabbleWord.new(word, self.xcoordinate - offset,  self.ycoordinate , self.direction, 0, 0)
		end
		possibles.push(possible)
		}

	strings = strings + tiles.permutaround(self.astring).select {|astring| astring.isaword} #words that can be made with the the target word + tiles placed both before and after the target word
	words.each { |word|
		offset = (word =~ /#{Regexp.quote(self.astring)}/)
		case
		when self.direction == 'right'
			possible = ScrabbleWord.new(word, self.xcoordinate,  self.ycoordinate - offset, self.direction, 0, 0)
			
		when self.direction == 'down'
			possible = ScrabbleWord.new(word, self.xcoordinate - offset,  self.ycoordinate , self.direction, 0, 0)
			
		end
		possibles.push(possible)
		}

	return possibles
	end

	def wordfindortho(tiles)
	#Orthogonal to the begining or the end of self
		possibles = []
		tilewords = $tilepermutedset.select {|astring| astring.isaword}
		tileset = tiles.to_chars
		tileset.each do |aletter|
			case
				when (self.astring + aletter).isaword
					tilewords.each {|aword|
					offset = (aword =~ /#{Regexp.quote(aletter)}/)
					if offset
					then
						case
							when self.direction == 'right'
								possible = ScrabbleWord.new(aword, self.xcoordinate - offset ,  self.ycoordinate + self.astring.length, "down", 0, 0)
							when  self.direction == 'down'
								possible = ScrabbleWord.new(aword, self.xcoordinate + self.astring.length ,  self.ycoordinate - offset, "right", 0, 0)
						end
						possibles.push(possible)
					end
					}
				when (aletter + self.astring).isaword
					tilewords.each {|aword| 
					offset = (aword =~ /#{Regexp.quote(aletter)}/)
					if offset
					then
						case
							when self.direction == 'right'
								possible = ScrabbleWord.new(aword, self.xcoordinate - offset ,  self.ycoordinate - 1, "down", 0, 0)
							when  self.direction == 'down'
								possible = ScrabbleWord.new(aword, self.xcoordinate - 1 ,  self.ycoordinate - offset, "right", 0, 0)
						end
						possibles.push(possible)
					end
					}
			end
		end
		return possibles
	end

	def wordfindorthomid(tiles)
		possibles = []
		tilearray = tiles.to_chars
		letters = self.astring.to_chars #take the basword and create an array of letters
		letters.each_index do |index| #for each letter of self find words that can be made orthogonal to self
			tilesplus = tiles + letters[index]
			indexletterarray = [letters[index]]
			#puts tilesplus
			#tilewords = tilesplus.permutedset.select {|astring| astring.isaword} #words that can be made with the tiles plus one letter of of self
			#puts tilewords.join("' ")
			#tilewords.each do |word|
			$possibleWords.each do |word|
				offset = (word =~ /#{Regexp.quote(letters[index])}/) # for those tilewords that have the one letter of self find its offset
				tilelettersneeded = word.to_chars - indexletterarray
				if offset && tilelettersneeded.subset?(tilearray)
				then				
					case
						when self.direction == "right"
						aSW = ScrabbleWord.new(word, self.xcoordinate - offset, self.ycoordinate + index, "down", 0, 0)
						when self.direction == "down"
						aSW = ScrabbleWord.new(word, self.xcoordinate + index, self.ycoordinate - offset, "right", 0, 0)
					end
				#aSW.print("test")
				possibles << aSW
				end
			end
		end
	return possibles
	end

	def scoreword (myboard)
		ascore = 0
		i = 0
		anarray = []
		anarray << 1
		while i < self.astring.length
			case
			when self.direction == "right"
				gridvalue = myboard.scoregrid[self.xcoordinate][self.ycoordinate + i]
				if myboard.lettergrid[self.xcoordinate][self.ycoordinate + i] == '-' 
					then occupied = "false"
					else occupied = "true"
					end
				#puts "gridvalue: #{gridvalue}; occupied: #{occupied}"
			when self.direction == "down"
				gridvalue = myboard.scoregrid[self.xcoordinate + i][self.ycoordinate]
				if myboard.lettergrid[self.xcoordinate + i][self.ycoordinate] == '-' 
					then occupied = "false"
					else occupied = "true"
					end
			end
			
			case			
			when gridvalue == "."
				ascore = ascore + myboard.lettervalues[self.astring[i]]
			when gridvalue == "l"
				if occupied =="false" 
					then
					ascore = ascore + 2 * myboard.lettervalues[self.astring[i]]
					else
					ascore = ascore + myboard.lettervalues[self.astring[i]]
					end
			when gridvalue == "L"
				if occupied == "false" 
					then
					ascore = ascore + 3 * myboard.lettervalues[self.astring[i]]
					else
					ascore = ascore + myboard.lettervalues[self.astring[i]]
					end
			when gridvalue == "w"
				ascore = ascore + myboard.lettervalues[self.astring[i]]
				if occupied == "false" 
					then
					anarray << 2
					end
			when gridvalue == "W"
				ascore = ascore + myboard.lettervalues[self.astring[i]]
				if occupied == "false" 
					then
					anarray <<  3
					end
			end
			i += 1
		end
		wordscore = ascore * anarray.max
		self.score = wordscore
	end


end






