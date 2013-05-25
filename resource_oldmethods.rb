class ScrabbleBoard
	
	
    def wordfindparallel
        possibles = []
        possibles = self.placetilewords($tilewords, self.blankparallelpositions)
        possibles = possibles.uniqSWs
        subpossibles = []
        possibles.each {|aSW|
            if self.testwordonboard(aSW) && self.testwordoverlap(aSW) && self.testwordsgeninline(aSW) &&  self.testwordsgenortho(aSW)
                scoreandplacewordfromtiles(aSW, $aGame.currentplayertileset, nil)
                if possibles.size > $maxallowed
                    if (possibles[0].score + possibles[0].supplement) < (aSW.score + aSW.supplement)
                        possibles = possibles - [possibles[0]]
                        possibles << aSW
                    end
                    else
                    possibles << aSW
                end
                possibles.sort_by {|possible| [(possible.score + possible.supplement)]}
            end
        }
        return subpossibles
    end
    
	def wordfindinline (aSWtarget) #self.tileword is a set of letters as a single string
        possibles = []
        aSW = nil
        strings = $tilepermutedset.collect {|astring| aSWtarget.astring + astring} #words that can be made with the the target word + tiles placed after the target word
        strings = strings.actualwords #replaces strings with '*' with all actual words with a letter in the positon of the '*'
        words = strings.select {|astring| astring.isaword}
        words.each { |word|
            case
                when aSWtarget.direction == 'right'
                aSW = ScrabbleWord.new(word, aSWtarget.xcoordinate,  aSWtarget.ycoordinate, aSWtarget.direction, 0, 0)
                when aSWtarget.direction == 'down'
                aSW = ScrabbleWord.new(word, aSWtarget.xcoordinate,  aSWtarget.ycoordinate , aSWtarget.direction, 0, 0)
            end
            if aSW
                if self.testwordonboard(aSW) && self.testwordoverlap(aSW) && self.testwordsgeninline(aSW) &&  self.testwordsgenortho(aSW)
                    scoreandplacewordfromtiles(aSW, $aGame.currentplayertileset, nil)
                    if possibles.size > $maxallowed
                        if (possibles[0].score + possibles[0].supplement) < (aSW.score + aSW.supplement)
                            possibles = possibles - [possibles[0]]
                            possibles << aSW
                        end
                        else
                        possibles << aSW
                    end
                    possibles.sort_by {|possible| [(possible.score + possible.supplement)]}
                end
            end
		}
        
        strings = strings + $tilepermutedset.collect {|astring| astring + aSWtarget.astring}
        strings = strings.actualwords #replaces strings with '*' with all actual words with a letter in the positon of the '*'
        strings.select {|astring| astring.isaword}  #words that can be made with the the target word + tiles placed before the target word
        words.each { |word|
            offset = (word =~ /#{Regexp.quote(aSWtarget.astring)}/)
            case
                when aSWtarget.direction == 'right'
                aSW = ScrabbleWord.new(word, aSWtarget.xcoordinate,  aSWtarget.ycoordinate - offset, aSWtarget.direction, 0, 0)
                when aSWtarget.direction == 'down'
                aSW = ScrabbleWord.new(word, aSWtarget.xcoordinate - offset,  aSWtarget.ycoordinate , aSWtarget.direction, 0, 0)
            end
            if aSW
                if self.testwordonboard(aSW) && self.testwordoverlap(aSW) && self.testwordsgeninline(aSW) &&  self.testwordsgenortho(aSW)
                    scoreandplacewordfromtiles(aSW, $aGame.currentplayertileset, nil)
                    if possibles.size > $maxallowed
                        if (possibles[0].score + possibles[0].supplement) < (aSW.score + aSW.supplement)
                            possibles = possibles - [possibles[0]]
                            possibles << aSW
                        end
                        else
                        possibles << aSW
                    end
                    possibles.sort_by {|possible| [(possible.score + possible.supplement)]}
                end
            end
		}
        
        strings = strings + self.tileword.permutaround(aSWtarget.astring).select {|astring| astring.isaword} #words that can be made with the the target word + tiles placed both before and after the target word
        words.each { |word|
            offset = (word =~ /#{Regexp.quote(aSWtarget.astring)}/)
            case
                when aSWtarget.direction == 'right'
                aSW = ScrabbleWord.new(word, aSWtarget.xcoordinate,  aSWtarget.ycoordinate - offset, aSWtarget.direction, 0, 0)
                
                when aSWtarget.direction == 'down'
                aSW = ScrabbleWord.new(word, aSWtarget.xcoordinate - offset,  aSWtarget.ycoordinate , aSWtarget.direction, 0, 0)
                
            end
            if aSW
                if self.testwordonboard(aSW) && self.testwordoverlap(aSW) && self.testwordsgeninline(aSW) &&  self.testwordsgenortho(aSW)
                    scoreandplacewordfromtiles(aSW, $aGame.currentplayertileset, nil)
                    if possibles.size > $maxallowed
                        if (possibles[0].score + possibles[0].supplement) < (aSW.score + aSW.supplement)
                            possibles = possibles - [possibles[0]]
                            possibles << aSW
                        end
                        else
                        possibles << aSW
                    end
                    possibles.sort_by {|possible| [(possible.score + possible.supplement)]}
                end
            end
        }
        return possibles
	end
    
	def wordfindortho(aSWtarget)
        #Orthogonal to the begining or the end of self
		possibles = []
        aSW = nil
		tileset = self.tileword.to_chars
		tileset.each do |aletter|
			case
				when (aSWtarget.astring + aletter).isaword
                $tilewords.each {|aword|
					offset = (aword =~ /#{Regexp.quote(aletter)}/)
					if offset
                        then
						case
							when aSWtarget.direction == 'right'
                            aSW = ScrabbleWord.new(aword, aSWtarget.xcoordinate - offset ,  aSWtarget.ycoordinate + aSWtarget.astring.length, "down", 0, 0)
							when  aSWtarget.direction == 'down'
                            aSW = ScrabbleWord.new(aword, aSWtarget.xcoordinate + aSWtarget.astring.length ,  aSWtarget.ycoordinate - offset, "right", 0, 0)
						end
					end
                }
				when (aletter + aSWtarget.astring).isaword
                $tilewords.each {|aword|
					offset = (aword =~ /#{Regexp.quote(aletter)}/)
					if offset
                        then
						case
							when aSWtarget.direction == 'right'
                            aSW = ScrabbleWord.new(aword, aSWtarget.xcoordinate - offset ,  aSWtarget.ycoordinate - 1, "down", 0, 0)
							when  aSWtarget.direction == 'down'
                            aSW = ScrabbleWord.new(aword, aSWtarget.xcoordinate - 1 ,  aSWtarget.ycoordinate - offset, "right", 0, 0)
						end
					end
                }
			end
            if aSW
                if self.testwordonboard(aSW) && self.testwordoverlap(aSW) && self.testwordsgeninline(aSW) &&  self.testwordsgenortho(aSW)
                    scoreandplacewordfromtiles(aSW, $aGame.currentplayertileset, nil)
                    if possibles.size > $maxallowed
                        if (possibles[0].score + possibles[0].supplement) < (aSW.score + aSW.supplement)
                            possibles = possibles - [possibles[0]]
                            possibles << aSW
                        end
                        else
                        possibles << aSW
                    end
                    possibles.sort_by {|possible| [(possible.score + possible.supplement)]}
                end
            end
		end
		return possibles
	end
    
	def wordfindorthomid (aSWtarget)
		puts "This is orthomid"
        possibles = []
        aSW = nil
		tilearray = self.tileword.to_chars
        tilearray = tilearray + 'abcdefghijklmnopqrstuvwxyz'.to_chars if self.tileword.include?'*'
		letters = aSWtarget.astring.to_chars #take the baseword and create an array of letters
		letters.each_index do |index| #for each letter of self find words that can be made orthogonal to self
			tilesplus = self.tileword + letters[index]
			indexletterarray = [letters[index]]
            possibleWords = self.findPossibleWords(letters[index])
            
			possibleWords.each do |word|
				offset = (word =~ /#{Regexp.quote(letters[index])}/) # for those tilewords that have the one letter of self find its offset
				tilelettersneeded = word.to_chars - indexletterarray
				if offset && tilelettersneeded.subset?(tilearray)
                    then
					case
						when aSWtarget.direction == "right"
						aSW = ScrabbleWord.new(word, aSWtarget.xcoordinate - offset, aSWtarget.ycoordinate + index, "down", 0, 0)
						when aSWtarget.direction == "down"
						aSW = ScrabbleWord.new(word, aSWtarget.xcoordinate + index, aSWtarget.ycoordinate - offset, "right", 0, 0)
					end
                    #aSW.print("test")
                    if aSW
                        if self.testwordonboard(aSW) && self.testwordoverlap(aSW) && self.testwordsgeninline(aSW) &&  self.testwordsgenortho(aSW)
                            scoreandplacewordfromtiles(aSW, $aGame.currentplayertileset, nil)
                            if possibles.size > $maxallowed
                                if (possibles[0].score + possibles[0].supplement) < (aSW.score + aSW.supplement)
                                    possibles = possibles - [possibles[0]]
                                    possibles << aSW
                                end
                                else
                                possibles << aSW
                            end
                            possibles.sort_by {|possible| [(possible.score + possible.supplement)]}
                        end
                    end
				end
			end
            
        end
        return possibles
	end
    
    def wordfindcontains(aSWtarget)  #this is not used.  was it too time consuming?
        possibles = []
        sometiles = self.tileword.to_chars
        tiles_plus_anchor = sometiles + aSWtarget.astring.to_chars
        tilepower = tiles_plus_anchor.powerset
        anchorword_plus = aSWtarget.astring.iscontainedwords
        tilepower_words = []
        tilepower.each {|array| tilepower_words << array.sort.join('') }
        anchor_words = anchorword_plus.select {|word| tilepower_words.include?(word.scan(/./).sort.join(''))}
        anchor_words.each { |word|
            
            case
                when aSWtarget.direction == 'right'
                aSW = ScrabbleWord.new(word, aSWtarget.xcoordinate,  aSWtarget.ycoordinate - (word =~ /#{Regexp.quote(aSWtarget.astring)}/), aSWtarget.direction, 0, 0)
                
                when aSWtarget.direction == 'down'
                aSW = ScrabbleWord.new(word, aSWtarget.xcoordinate - (word =~ /#{Regexp.quote(aSWtarget.astring)}/),  aSWtarget.ycoordinate, aSWtarget.direction, 0, 0)
                
            end
            if aSW
                if self.testwordonboard(aSW) && self.testwordoverlap(aSW) && self.testwordsgeninline(aSW) &&  self.testwordsgenortho(aSW)
                    scoreandplacewordfromtiles(aSW, $aGame.currentplayertileset, nil)
                    if possibles.size > $maxallowed
                        if (possibles[0].score + possibles[0].supplement) < (aSW.score + aSW.supplement)
                            possibles = possibles - [possibles[0]]
                            possibles << aSW
                        end
                        else
                        possibles << aSW
                    end
                    possibles.sort_by {|possible| [(possible.score + possible.supplement)]}
                end
            end
		}
        #aSW.print("test")
        
        return possibles
	end

end  #class






