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
    
    def coordinatesused  #returns array of coordinates covered by aSW
        array = []
        case
        when self.direction == 'right'
            i = 0
            while i < self.astring.length
                array.push([self.xcoordinate, self.ycoordinate + i])
                i += 1
            end
        when self.direction == 'down'
            i = 0
            while i < self.astring.length
                array.push([self.xcoordinate + i, self.ycoordinate])
                i += 1
            end
        end
        return array
    end
	
	def wordfindcontains  #this is not used.  was it too time consuming?
	possibles = []
	sometiles = $tiles.to_chars
	tiles_plus_anchor = sometiles + self.astring.to_chars
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
		
	def wordfindinline #$tiles is a set of letters as a single string
	possibles = []
    aSW = nil
	strings = $tilepermutedset.collect {|astring| self.astring + astring} #words that can be made with the the target word + tiles placed after the target word
    strings = strings.actualwords #replaces strings with '*' with all actual words with a letter in the positon of the '*'
    words = strings.select {|astring| astring.isaword}
	words.each { |word|
		case
		when self.direction == 'right'
			aSW = ScrabbleWord.new(word, self.xcoordinate,  self.ycoordinate, self.direction, 0, 0)
		when self.direction == 'down'
			aSW = ScrabbleWord.new(word, self.xcoordinate,  self.ycoordinate , self.direction, 0, 0)
		end
        if aSW
            if $aWordfriend.myboard.testwordonboard(aSW) && $aWordfriend.myboard.testwordoverlap(aSW) && $aWordfriend.myboard.testwordsgeninline(aSW) &&  $aWordfriend.myboard.testwordsgenortho(aSW)
                aSW.scoreword
                possibles << aSW if ((aSW.score + aSW.supplement) > $minscore)
            end
        end
		}
	
	strings = strings + $tilepermutedset.collect {|astring| astring + self.astring}
    strings = strings.actualwords #replaces strings with '*' with all actual words with a letter in the positon of the '*'
    strings.select {|astring| astring.isaword}  #words that can be made with the the target word + tiles placed before the target word
	words.each { |word|
		offset = (word =~ /#{Regexp.quote(self.astring)}/)
		case
		when self.direction == 'right'
			aSW = ScrabbleWord.new(word, self.xcoordinate,  self.ycoordinate - offset, self.direction, 0, 0)
		when self.direction == 'down'
			aSW = ScrabbleWord.new(word, self.xcoordinate - offset,  self.ycoordinate , self.direction, 0, 0)
		end
        if aSW
            if $aWordfriend.myboard.testwordonboard(aSW) && $aWordfriend.myboard.testwordoverlap(aSW) && $aWordfriend.myboard.testwordsgeninline(aSW) &&  $aWordfriend.myboard.testwordsgenortho(aSW)
                aSW.scoreword
                possibles << aSW if ((aSW.score + aSW.supplement) > $minscore)
            end
        end
		}

	strings = strings + $tiles.permutaround(self.astring).select {|astring| astring.isaword} #words that can be made with the the target word + tiles placed both before and after the target word
	words.each { |word|
		offset = (word =~ /#{Regexp.quote(self.astring)}/)
		case
		when self.direction == 'right'
			aSW = ScrabbleWord.new(word, self.xcoordinate,  self.ycoordinate - offset, self.direction, 0, 0)
			
		when self.direction == 'down'
			aSW = ScrabbleWord.new(word, self.xcoordinate - offset,  self.ycoordinate , self.direction, 0, 0)
			
		end
        if aSW
            if $aWordfriend.myboard.testwordonboard(aSW) && $aWordfriend.myboard.testwordoverlap(aSW) && $aWordfriend.myboard.testwordsgeninline(aSW) &&  $aWordfriend.myboard.testwordsgenortho(aSW)
                aSW.scoreword
                possibles << aSW if ((aSW.score + aSW.supplement) > $minscore)
            end
        end
        }
	return possibles
	end

	def wordfindortho
	#Orthogonal to the begining or the end of self
		possibles = []
        aSW = nil
		tileset = $tiles.to_chars
		tileset.each do |aletter|
			case
				when (self.astring + aletter).isaword
					$tilewords.each {|aword|
					offset = (aword =~ /#{Regexp.quote(aletter)}/)
					if offset
					then
						case
							when self.direction == 'right'
								aSW = ScrabbleWord.new(aword, self.xcoordinate - offset ,  self.ycoordinate + self.astring.length, "down", 0, 0)
							when  self.direction == 'down'
								aSW = ScrabbleWord.new(aword, self.xcoordinate + self.astring.length ,  self.ycoordinate - offset, "right", 0, 0)
						end
						#possibles.push(possible)
					end
					}
				when (aletter + self.astring).isaword
					$tilewords.each {|aword|
					offset = (aword =~ /#{Regexp.quote(aletter)}/)
					if offset
					then
						case
							when self.direction == 'right'
								aSW = ScrabbleWord.new(aword, self.xcoordinate - offset ,  self.ycoordinate - 1, "down", 0, 0)
							when  self.direction == 'down'
								aSW = ScrabbleWord.new(aword, self.xcoordinate - 1 ,  self.ycoordinate - offset, "right", 0, 0)
						end
						#possibles.push(possible)
					end
					}
			end
            if aSW
                if $aWordfriend.myboard.testwordonboard(aSW) && $aWordfriend.myboard.testwordoverlap(aSW) && $aWordfriend.myboard.testwordsgeninline(aSW) &&  $aWordfriend.myboard.testwordsgenortho(aSW)
                    aSW.scoreword
                    possibles << aSW if ((aSW.score + aSW.supplement) > $minscore)
                end
            end
		end
		return possibles
	end

	def wordfindorthomid
		possibles = []
        aSW = nil
		tilearray = $tiles.to_chars
        tilearray = tilearray + 'abcdefghijklmnopqrstuvwxyz'.to_chars if $tiles.include?'*'
		letters = self.astring.to_chars #take the baseword and create an array of letters
		letters.each_index do |index| #for each letter of self find words that can be made orthogonal to self
			tilesplus = $tiles + letters[index]
			indexletterarray = [letters[index]]
            possibleWords = $aWordfriend.myboard.findPossibleWords(letters[index])
            
			possibleWords.each do |word|
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
                    if aSW
                        if $aWordfriend.myboard.testwordonboard(aSW) && $aWordfriend.myboard.testwordoverlap(aSW) && $aWordfriend.myboard.testwordsgeninline(aSW) &&  $aWordfriend.myboard.testwordsgenortho(aSW)
                            aSW.scoreword
                            possibles << aSW if ((aSW.score + aSW.supplement) > $minscore)
                        end
                    end
				end
			end
            
        end
        return possibles
	end

	def scoreword  #calculates only the direct score. testwordsgeninline and testwordsgenortho calculate the cupplement score from indirectly created words
		ascore = 0
		i = 0
		anarray = []
		anarray << 1
		while i < self.astring.length
			case
			when self.direction == "right"
				gridvalue = $aWordfriend.myboard.scoregrid[self.xcoordinate][self.ycoordinate + i]
				if $aWordfriend.myboard.lettergrid[self.xcoordinate][self.ycoordinate + i] == '-'
					then occupied = "false"
					else occupied = "true"
					end
				#puts "gridvalue: #{gridvalue}; occupied: #{occupied}"
			when self.direction == "down"
				gridvalue = $aWordfriend.myboard.scoregrid[self.xcoordinate + i][self.ycoordinate]
				if $aWordfriend.myboard.lettergrid[self.xcoordinate + i][self.ycoordinate] == '-'
					then occupied = "false"
					else occupied = "true"
					end
			end
			
			case			
            when gridvalue == "" #scoregrid is set to "" if a '*' character used on lettergrid
                #no addition to the score in this case
            when gridvalue == "."
				ascore = ascore + $aWordfriend.myboard.lettervalues[self.astring[i]]
			when gridvalue == "l"
				if occupied =="false" 
					then
					ascore = ascore + 2 * $aWordfriend.myboard.lettervalues[self.astring[i]]
					else
					ascore = ascore + $aWordfriend.myboard.lettervalues[self.astring[i]]
					end
			when gridvalue == "L"
				if occupied == "false" 
					then
					ascore = ascore + 3 * $aWordfriend.myboard.lettervalues[self.astring[i]]
					else
					ascore = ascore + $aWordfriend.myboard.lettervalues[self.astring[i]]
					end
			when gridvalue == "w"
				ascore = ascore + $aWordfriend.myboard.lettervalues[self.astring[i]]
				if occupied == "false" 
					then
					anarray << 2
					end
			when gridvalue == "W"
				ascore = ascore + $aWordfriend.myboard.lettervalues[self.astring[i]]
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






