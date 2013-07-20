class ScrabbleBoard
	attr_accessor :lettergrid, :pushlettergrid, :tileword, :newtileword, :scoregrid, :pushscoregrid, :newgrid, :pushnewgrid, :dimension, :lettervalues, :boardSWs, :boardLetters, :hotspots, :hotspotcoords, :filledcoordinates, :boardchanged, :tilewordwords, :tilewordstrings, :tilewordstringsofsize, :tilewordwordsofsize, :hotspotSWs
	
	
	def initialvalues #this method fills the letter grid array dimension x dimension with nil, the scoregrid with 1s except as defined
		self.boardchanged = nil
        self.hotspots = []
        self.dimension = 15
		self.lettergrid = {}
        self.newgrid = {}
        self.pushlettergrid = {}
        self.pushnewgrid = {}
		self.scoregrid = {}
        self.pushscoregrid = {}
		self.boardLetters = [] 
        self.filledcoordinates = []
		self.lettervalues = {'a' => 1, 'b' => 4, 'c' => 4, 'd' => 2, 'e' => 1, 'f' => 4, 'g' => 3, 'h' => 3, 
		'i' => 1, 'j' => 1, 'k' => 5, 'l' => 2, 'm' => 4, 'n' => 2, 'o' => 1, 'p' => 4, 'q' => 10, 'r' => 1, 
		's' => 1, 't' => 1, 'u' => 2, 'v' => 5, 'w' => 4, 'x' => 8, 'y' => 3, 'z' => 10,}
		i = 0
		while i < self.dimension
			j = 0
			lhash = {}
			shash = {}
            nhash = {}
			while j < self.dimension
				lhash[j] = '-'
				shash[j] = '-'
                nhash[j] = '-'
				j += 1
			end
			self.lettergrid[i] = lhash.dup
			self.scoregrid[i] = shash.dup
            self.newgrid[i] = nhash.dup
            self.pushlettergrid[i] = lhash.dup
            self.pushnewgrid[i] = nhash.dup
            self.pushscoregrid[i] = shash.dup
			i += 1
		end
        self.readscores("SWscoreResource.txt")
	end
	
	def printboard
		i = 0
		while i < self.dimension
			j = 0
			anarray = []
			while j < self.dimension
				anarray << self.lettergrid[i][j]
				j += 1
			end
			puts anarray.join(' | ')
			puts "_________________________________________________________"
			i += 1
		end		
		
	end
    
    def resetnewindicator
        i = 0
        while i < self.dimension
            j = 0
            nhash = {}
            while j < self.dimension
                nhash[j] = '-'
                j += 1
            end
            self.newgrid[i] = nhash
            #self.scoregrid[i][j] = '.' if self.scoregrid[i][j] = 'n'
            i += 1
        end
    end

	def describehotspots
		self.hotspots = []
        self.hotspotcoords = []
		col = 0
		while col < self.dimension # for the jth column
			row = 0
			while row < (self.dimension) #and the ith row
                if isblankwithonesideoccupied(row,col)
                    rstrdist = findcharstoright(row,col) #returns vector [chars, distance to chars]
                    lstrdist = findcharstoleft(row,col)
                    ustrdist = findcharstoup(row,col)
                    dstrdist = findcharstodown(row,col)
                    self.hotspotcoords << [row, col]
                    self.hotspots << {'row' => row,'col' => col,'leftdist' => lstrdist['distance'],'leftchars' => lstrdist['chars'],'rightdist' => rstrdist['distance'],'rightchars' => rstrdist['chars'],'updist' => ustrdist['distance'],'upchars' => ustrdist['chars'],'downdist' => dstrdist['distance'],'downchars' => dstrdist['chars']}
                end
            row += 1
            end
        col += 1
        end
    end
    
    def printhotspots
        puts "row, col, leftdist, leftchars, rightdist, rightchars, updist, upchars, downdist, downchars"
        self.hotspots.each {|hs|
            puts "[#{hs["row"]}, #{hs["col"]}, #{hs["leftdist"]}, #{hs["leftchars"]}, #{hs["rightdist"]}, #{hs["rightchars"]}, #{hs["updist"]}, #{hs["upchars"]}, #{hs["downdist"]}, #{hs["downchars"]}]"
        }
    end

    def isblankwithonesideoccupied (row,col)
        self.lettergrid[row][col] == '-' && onesideoccupied(row,col)
    end
        
    def onesideoccupied (row,col)
        leftsideoccupied(row,col) || rightsideoccupied(row,col) || upsideoccupied(row,col) || downsideoccupied(row,col)
    end
    
    def leftsideoccupied (row,col)
        col > 0 && self.lettergrid[row][col - 1] != '-'
    end
    
    def rightsideoccupied (row,col)
        col < (self.dimension - 1) && self.lettergrid[row][col + 1] != '-'
    end
    
    def upsideoccupied (row,col)
        row > 0 && self.lettergrid[row - 1][col] != '-'
    end
        
    def downsideoccupied (row,col)
        row < (self.dimension - 1) && self.lettergrid[row + 1][col] != '-'
    end

    def findcharstoright (row, col)
        startchars = nil
        endchars = nil
        arr = []
        i = 1
        while col + i < self.dimension
            case
                when !startchars && self.lettergrid[row][col+i] != '-'
                    startchars = col + i
                    distance = startchars - col
                    arr << self.lettergrid[row][col+i]
                when startchars &&  self.lettergrid[row][col+i] != '-'
                    arr << self.lettergrid[row][col+i]
                when startchars && self.lettergrid[row][col+i] == '-'
                    endchars = true
                    chars = arr.join('')
                vector = {'distance' => distance, 'chars' => chars}
                    return vector
            end
        i += 1
        end
        distance = nil if !startchars #if no startchars found
        chars = '' if !startchars #if no startchars found
        chars = arr.join('') if startchars && !endchars  #if startchars found but not end chars found
        vector = {'distance' => distance, 'chars' => chars}
        return vector
    end
    
    def findcharstodown (row, col)
        startchars = nil
        endchars = nil
        arr = []
        i = 1
        while row + i < self.dimension
            case
                when !startchars && self.lettergrid[row+i][col] != '-'
                startchars = row + i
                distance = startchars - row
                arr << self.lettergrid[row+i][col]
                when startchars &&  self.lettergrid[row+i][col] != '-'
                arr << self.lettergrid[row+i][col]
                when startchars && self.lettergrid[row+i][col] == '-'
                endchars = true
                chars = arr.join('')
                vector = {'distance' => distance, 'chars' => chars}
                return vector
            end
            i += 1
        end
        distance = nil if !startchars #if no startchars found
        chars = '' if !startchars #if no startchars found
        chars = arr.join('') if startchars && !endchars  #if startchars found but not end chars found
        vector = {'distance' => distance, 'chars' => chars}
        return vector
    end
    
    def findcharstoleft (row, col)
        startchars = nil
        endchars = nil
        arr = []
        i = 1
        while col - i > 0
            case
                when !startchars && self.lettergrid[row][col - i] != '-'
                    startchars = col - i
                    distance = col - startchars
                    arr << self.lettergrid[row][col-i]
                when startchars &&  self.lettergrid[row][col-i] != '-'
                    arr << self.lettergrid[row][col-i]
                when startchars && self.lettergrid[row][col-i] == '-'
                    endchars = true
                    chars = arr. reverse.join('')
                    vector = {'distance' => distance, 'chars' => chars}
                    return vector
            end
        i += 1
        end
        distance = nil if !startchars #if no startchars found
        chars = '' if !startchars #if no startchars found
        chars = arr.reverse.join('') if startchars && !endchars  #if startchars found but not end chars found
        vector = {'distance' => distance, 'chars' => chars}
        return vector
    end
    
    def findcharstoup (row, col)
        startchars = nil
        endchars = nil
        arr = []
        i = 1
        while row - i > 0
            case
                when !startchars && self.lettergrid[row-i][col] != '-'
                startchars = row - i
                distance = row - startchars
                arr << self.lettergrid[row-i][col]
                when startchars &&  self.lettergrid[row-i][col] != '-'
                arr << self.lettergrid[row-i][col]
                when startchars && self.lettergrid[row-i][col] == '-'
                endchars = true
                chars = arr. reverse.join('')
                vector = {'distance' => distance, 'chars' => chars}
                return vector
            end
            i += 1
        end
        distance = nil if !startchars #if no startchars found
        chars = '' if !startchars #if no startchars found
        chars = arr.reverse.join('') if startchars && !endchars  #if startchars found but not end chars found
        vector = {'distance' => distance, 'chars' => chars}
        return vector
    end
    
	def placetilewords (tilewords, coordinates) #return possibleSWs formed by placing each tileword in every blankposition in every register as long as the SW does not cover a non-empty grid location with a different letter; the coordinates have a direction
		possibles = []
		tilewords.each {|word|
			coordinates.each {|coord|
				i = 0
				while i < word.size #the position of the first letter can be one of size positions relative to the coordinate
					wordposition = 0
					status = "true"
					while (wordposition < word.size) && status == "true" # then for each word position check if each of its letters is an an available gird position
						case
							when coord[2] == "right"
								x = coord[0]
								y = coord[1] - i + wordposition							
							when coord[2] == "down"
								x = coord[0] - i + wordposition
								y = coord[1]
						end
						if (0 < x) && (x < self.dimension) && (0 < y) && (y < self.dimension) #if x or y calls invalid dimension then cannot place word
						then 
							if lettergrid[x][y] == '-'
								then status = "true"
							elsif lettergrid[x][y] == word[wordposition]
								then status = "true"
							else
								status = "false"
							end
						else
							status = "false"
						end
					wordposition += 1
					end #status true after checking weach wordposition or false because one of the positions could not be placed 
					if status == "true" #
						then 
							case
								when coord[2] == "right"
									possibles << ScrabbleWord.new(word, coord[0], coord[1] - i, "right", 0, 0)
								when coord[2] == "down"
									possibles << ScrabbleWord.new(word, coord[0] - i, coord[1],  "down", 0, 0)
							 end
					end
				i+= 1
				end
			}
		}
	return possibles
	end
    
    def placetilewordsat (tilewords, coord) #return possibleSWs formed by placing each tileword at coord as long as the SW does not cover a non-empty grid location with a different letter; the coordinates have a direction
		possibles = []
		tilewords.each {|word|
					wordposition = 0
					status = "true"
					while (wordposition < word.size) && status == "true" # then for each word position check if each of its letters is an an available gird position
						case
							when coord[2] == "right"
                            x = coord[0]
                            y = coord[1] + wordposition
							when coord[2] == "down"
                            x = coord[0] + wordposition
                            y = coord[1]
						end
						if (0 < x) && (x < self.dimension) && (0 < y) && (y < self.dimension) #if x or y calls invalid dimension then cannot place word
                            then
							if lettergrid[x][y] == '-'
								then status = "true"
                                elsif lettergrid[x][y] == word[wordposition]
								then status = "true"
                                else
								status = "false"
							end
                            else
							status = "false"
						end
                        wordposition += 1
					end #status true after checking weach wordposition or false because one of the positions could not be placed
					if status == "true" #
						then
                        case
                            when coord[2] == "right"
                            possibles << ScrabbleWord.new(word, coord[0], coord[1], "right", 0, 0)
                            when coord[2] == "down"
                            possibles << ScrabbleWord.new(word, coord[0], coord[1],  "down", 0, 0)
                        end
					end
		}	
        return possibles
	end
	
	def loadword (word) #this method takes any scrabble word and places its letter content onto the letter grid
		case
		when word.direction == "right"
			i = 0
			while i < word.astring.length
				self.lettergrid[word.xcoordinate][word.ycoordinate + i] = word.astring[i]
				i += 1
			end
		when word.direction == "down"
			i = 0
			while i < word.astring.length
				self.lettergrid[word.xcoordinate + i][word.ycoordinate] = word.astring[i]
				i += 1
			end	
		end
	end
    
    def findhotspotSWs #for each hotspot review all possible SWs in both directions, saving the top $maxallowed scoring
        $aWordfriend.possiblewords = []
        #puts "hotspots: #{self.hotspots.size}"
        self.hotspots.each {|hs|
            
            ($aWordfriend.possiblewords = $aWordfriend.possiblewords + wordsonblank(hs,"right")) if isblankright(hs)
            
            ($aWordfriend.possiblewords = $aWordfriend.possiblewords  + wordsonblank(hs,"down")) if isblankdown(hs)
            
            ($aWordfriend.possiblewords = $aWordfriend.possiblewords + stringsplusright(hs)) if hs["rightdist"] == 1

            ($aWordfriend.possiblewords = $aWordfriend.possiblewords + stringsplusdown(hs)) if hs["downdist"] == 1
            
            ($aWordfriend.possiblewords = $aWordfriend.possiblewords + stringsplusleft(hs)) if hs["leftdist"] == 1
            
            ($aWordfriend.possiblewords = $aWordfriend.possiblewords + stringsplusup(hs)) if hs["updist"] == 1
            
            if hs["rightdist"]
                if hs["rightdist"] > 1
                    ($aWordfriend.possiblewords = $aWordfriend.possiblewords + wordsonblanksize(hs,"right", hs["rightdist"] - 1))
                end
            end
            
            if hs["downdist"]
                if hs["downdist"] > 1
                    ($aWordfriend.possiblewords = $aWordfriend.possiblewords + wordsonblanksize(hs, "down", hs["downdist"] - 1))
                end
            end
        }
        $aWordfriend.possiblewords = $aWordfriend.possiblewords.uniqSWs.sort_by {|possible| [-(possible.score + possible.supplement)]}.take($maxallowed)
        
    end
    
    def printhotspotSWs
        hotspotSWs.each {|aSW|
            aSW.print("test")
        }
    end
    
    def isblankright(hs)
        hs["rightchars"] == "" 
    end

    def isblankdown(hs)
        hs["downchars"] == ""
    end
    
    def wordsonblank(hs,direction)
        set = []
        self.tilewordwords.each {|aword|
            aSW = ScrabbleWord.new(aword,hs["row"],hs["col"],direction,0,0)
            if self.testwordonboard(aSW) && self.testwordsgeninline(aSW) && self.testwordsgenortho(aSW) && self.scoreandplacewordfromtiles(aSW, self.tileword, nil)
                    set << aSW
            end
        }
        set = set.uniqSWs.sort_by {|possible| [-(possible.score + possible.supplement)]}.take($maxallowed)
        return set
    end
    
    def wordsonblanksize(hs, direction, maxsize)
        set = []
        i = 1
        while i < maxsize
        if self.tilewordwordsofsize[i]
        then
            self.tilewordwordsofsize[i].each {|aword|
            aSW = ScrabbleWord.new(aword,hs["row"],hs["col"],direction,0,0)
            if self.testwordonboard(aSW) && self.testwordsgeninline(aSW) && self.testwordsgenortho(aSW) && self.scoreandplacewordfromtiles(aSW, self.tileword, nil)
                set << aSW
            end
            }
        end
        i+= 1
        end
        set = set.uniqSWs.sort_by {|possible| [-(possible.score + possible.supplement)]}.take($maxallowed)
        return set
    end
    
    def stringsplusright(hs)
        someSWs = []
        tilewordstrings.each {|astring|
            somewords = (astring + hs["rightchars"]).isaword_plus
            if somewords
                somewords.each{|aword|
                aSW = ScrabbleWord.new(aword,hs["row"],hs["col"] - astring.size + 1,"right",0,0)
                if self.testwordonboard(aSW) && self.testwordsgeninline(aSW) && self.testwordsgenortho(aSW) && self.scoreandplacewordfromtiles(aSW, self.tileword, nil)
                    someSWs << aSW
                end
                }
            end
        }
        someSWs = someSWs.uniqSWs.sort_by {|possible| [-(possible.score + possible.supplement)]}.take($maxallowed)
        return someSWs
    end
 
    def stringsplusleft(hs)
        someSWs = []
        tilewordstrings.each {|astring|
            somewords = (hs["leftchars"] + astring).isaword_plus
            if somewords
                somewords.each{|aword|
                    aSW = ScrabbleWord.new(aword,hs["row"],hs["col"] - hs["leftchars"].size,"right",0,0)
                    if self.testwordonboard(aSW) && self.testwordsgeninline(aSW) && self.testwordsgenortho(aSW) && self.scoreandplacewordfromtiles(aSW, self.tileword, nil)
                        someSWs << aSW
                    end
                }
            end
        }
        someSWs = someSWs.uniqSWs.sort_by {|possible| [-(possible.score + possible.supplement)]}.take($maxallowed)
        return someSWs
    end
    
    def stringsplusup(hs)
        someSWs = []
        tilewordstrings.each {|astring|
            somewords = (hs["upchars"] + astring).isaword_plus
            if somewords
                somewords.each{|aword|
                    aSW = ScrabbleWord.new(aword,hs["row"] - hs["upchars"].size,hs["col"],"down",0,0)
                    if self.testwordonboard(aSW) && self.testwordsgeninline(aSW) && self.testwordsgenortho(aSW) && self.scoreandplacewordfromtiles(aSW, self.tileword, nil)
                        someSWs << aSW
                    end
                }
            end
        }
        someSWs = someSWs.uniqSWs.sort_by {|possible| [-(possible.score + possible.supplement)]}.take($maxallowed)
        return someSWs
    end
    
    def stringsplusdown(hs)
        someSWs = []
        tilewordstrings.each {|astring|
            somewords = (astring + hs["downchars"]).isaword_plus
            if somewords
                somewords.each{|aword|
                    aSW = ScrabbleWord.new(aword,hs["row"] - astring.size + 1,hs["col"],"down",0,0)
                    if self.testwordonboard(aSW) && self.testwordsgeninline(aSW) && self.testwordsgenortho(aSW) && self.scoreandplacewordfromtiles(aSW, self.tileword, nil)
                        someSWs << aSW
                    end
                }
            end
        }
        someSWs = someSWs.uniqSWs.sort_by {|possible| [-(possible.score + possible.supplement)]}.take($maxallowed)
        return someSWs
    end
    
    def autowordtest(aSW) #this tests a proposed move for validity:
        # must be a valid word (is a valid key in a hash called $words (method in resource_methods) AND
        # must cross (intersect) of be adjacent to an existing word  AND
        # must not generate any invalid words in line with itself or orthogonal to itself
        #must not replace an existing board letter with a different letter
        #must be on the board
        #must be placed using user tiles or letters on board
        status = nil
        (return status) if not(aSW.astring.isaword)  #returns nil if not a word
        (return status) if not(self.usesvalidmovecoordinates(aSW)) #returns nil if does not cross (intersect) or be adjacent to an existing word
        (return status) if not(self.testwordonboard(aSW))
        (return status) if not(self.testwordoverlap(aSW))
        (return status) if not(self.testwordsgeninline(aSW)) #updates score or supplement or returns nil
        (return status) if not(self.testwordsgenortho(aSW)) #updates score or supplement or returns nil
        (return status) if not(self.scoreandplacewordfromtiles(aSW, self.tileword, nil)) #checks whether the word can be placed with players tiles or board letters without changing a board letter, else returns nil
        status = 'true'
        return status
    end
    
    def usesvalidmovecoordinates(aSW) #checks myboard.hotspots to see if at least one of them is used by aSW
        status = nil
        case
            when aSW.direction == 'right'
            i = 0
            while i < aSW.astring.length
                #puts "coordinate #{[aSW.xcoordinate, aSW.ycoordinate + i]}"
                status = 'true' if self.hotspotcoords.include?([aSW.xcoordinate, aSW.ycoordinate + i])
                #puts "status #{status}"
                i += 1
            end
            when aSW.direction == 'down'
            i = 0
            while i < aSW.astring.length
                #puts "coordinate #{[aSW.xcoordinate + i, aSW.ycoordinate]}"
                status = 'true' if self.hotspotcoords.include?([aSW.xcoordinate + i, aSW.ycoordinate])
                #puts "status #{status}"
                i += 1
            end
        end
        return status
    end
    
    def letterssamerow(c)
        arr = []
        i = 0
        while i <self.dimension
            arr << self.lettergrid[c[0]][i]
            i += 1
        end
        astr = arr.uniq!.join('')
    end
            
    def letterssamecol(c)
            arr = []
            i = 0
            while i <self.dimension
                arr << self.lettergrid[i][c1]
                i += 1
            end
            astr = arr.uniq!.join('')
    end
            
	def testwordonboard (word)
	status = "true"
		case
		when word.direction == "right"
			if word.ycoordinate + word.astring.length > self.dimension
				then status = nil
			elsif not((word.ycoordinate > -1) && (word.ycoordinate < self.dimension))
				then status = nil
			elsif not((word.xcoordinate > -1) && (word.xcoordinate < self.dimension))
				then status = nil 
			end
		when word.direction == "down" 
			if word.xcoordinate + word.astring.length > self.dimension
				then status = nil
			elsif not((word.ycoordinate > -1) && (word.ycoordinate < self.dimension))
				then status = nil 
			elsif not((word.xcoordinate > -1) && (word.xcoordinate < self.dimension))
				then status = nil 
			end
		end
	return status
	end
	
	
	
	def testwordoverlap (word) #this method tests a possible word addition, rejects if goes beyond dimension or requires a letter grid position to change from one letter to another
			status = "true"
            tilearray = self.tileword # this word starts with each of the tileword letters
			case
			when word.direction == "right"
				i = 0
				count = 0
				while i < word.astring.length && status == "true"
					if	(self.lettergrid[word.xcoordinate][word.ycoordinate + i] == "-")
					then 
						status = "true"
						count += 1
                        if tilearray.include? word.astring[i]
                            achar = [word.astring[i]]
                            tilearray = tilearray.sub(word.astring[i],'') #remove one letter from the array as it "has been used"
                        elsif tilearray.include? '*'
                            tilearray = tilearray.sub('*','') #use the '*'
                        else
                            status = nil #if the tilearray does not have a letter remaining to fill this need then the word is not possible;  this screens out the double use of a tileword letter
                        end
                    elsif  (self.lettergrid[word.xcoordinate][word.ycoordinate + i] == word.astring[i])
					then 
						status = "true"
					else
						status = nil
					end
					i += 1
				end
				if count == 0 
				then status = nil 
				end #at least one '-' space must be covered to be valid
			when word.direction == "down" 
				i = 0
				count = 0
				while i < word.astring.length && status == "true"
					if	(self.lettergrid[word.xcoordinate + i][word.ycoordinate] == "-")
					then 
						status = "true"
						count += 1
                        if tilearray.include? word.astring[i]
                            then
                            tilearray = tilearray.sub(word.astring[i],'') #remove one letter from the array as it "has been used"
                        elsif tilearray.include? '*'
                            tilearray = tilearray.sub('*','') #use the '*'
                        else
                            status = nil #if the tilearray does not have a letter remaining to fill this need then the word is not possible;  this screens out the double use of a tileword letter
                        end
                    elsif  (self.lettergrid[word.xcoordinate + i][word.ycoordinate] == word.astring[i])
					then 
						status = "true"
					else
						status = nil
					end
					i += 1
				end
				if count == 0 
				then status = nil 
				end #at least one '-' space must be covered to be valid
			end
		return status
	end

	def testwordsgeninline (word) #this method tests a possible word addition, rejects if it creates a non-word in line with the test word
		#not done yet: it should also supplement the score if it generates another word inline or at right anlels
		#not done yet:the final score of the word tested will be added to this supplement score
			#puts word.print("starting word")
			case
			when word.direction == "right"
				testwordarray = []
				#find left
				testposition = word.ycoordinate - 1
				leftposition = "not found"
				while testposition > -1 && leftposition == "not found"
					if self.lettergrid[word.xcoordinate][testposition] == "-"
						then leftposition = testposition + 1
						end
					testposition -= 1
				end
				if leftposition == "not found" 
					then leftposition = 0
					end
				#puts "leftposition #{leftposition}"
				#find right
				testposition = word.ycoordinate + word.astring.size
				rightposition = "not found"
				while testposition < self.dimension && rightposition == "not found"
					if self.lettergrid[word.xcoordinate][testposition] == "-"
						then rightposition = testposition - 1
						end
					testposition += 1
				end
				if rightposition == "not found" 
					then rightposition = self.dimension - 1
					end

				# it is necessary to do the rest of this only if leftposition or rightposition goes beyond the bounds ofthe word
				if leftposition != word.ycoordinate || rightposition != (word.ycoordinate + word.astring.size - 1)
				then
					#fill in left part of array
					currentposition = leftposition
					while currentposition < word.ycoordinate
						testwordarray << self.lettergrid[word.xcoordinate][currentposition]
						currentposition += 1
					end
		
					#fill the word into the array; at this point currentposition = word.ycoordinate
					#wordfactorarray = []
					#wordfactorarray << 1
					while  currentposition < word.ycoordinate + word.astring.length 
						testwordarray << word.astring[currentposition - word.ycoordinate]
						#case
                        #when (self.scoregrid[word.xcoordinate][currentposition] == 'w' && self.lettergrid[word.xcoordinate][currentposition] == '-')
                        #	wordfactorarray << 2
						#	when (self.scoregrid[word.xcoordinate][currentposition]  == 'W' && self.lettergrid[word.xcoordinate][currentposition] == '-')
						#		wordfactorarray << 3
						#end
						currentposition += 1
					end
					#wordfactor = wordfactorarray.max
					
					#fill in right part of array
					while currentposition < rightposition + 1
						testwordarray << self.lettergrid[word.xcoordinate][currentposition]
						currentposition += 1
					end
					#puts "wordgenerated #{testwordarray.join('')}"
					status = testwordarray.join('').isaword
					#puts "status #{status} for word #{testwordarray.join('')} from inline right"
					if status
						then
						#score for full word generated inline - score for the proposed word is the supplement
						generatedword = ScrabbleWord.new(testwordarray.join(''),word.xcoordinate,leftposition,"right",0,0)
                        akey = generatedword.createkey
                        if word.suppwords[akey]
                            then
                            puts "duplicate #{generatedword.astring}, xc #{generatedword.xcoordinate}, yc #{generatedword.ycoordinate}, dirx #{generatedword.direction}"
                            else
                            word.suppwords[akey] = generatedword
                            self.scoreandplacewordfromtiles(generatedword, $aGame.currentplayertileset, nil)
                            self.scoreandplacewordfromtiles(word, $aGame.currentplayertileset, nil)
                            difference =  generatedword.score - word.score
                            word.supplement = word.supplement + difference
						end
						#puts generatedword.print("temp inline right generated")
						#puts word.print("temp inline right source")
                        
						
					end
				else
					status = word.astring
				end
			when word.direction == "down" 
				testwordarray = []
				#find left
				testposition = word.xcoordinate - 1
				leftposition = "not found"
				while testposition > -1 && leftposition == "not found"
					if self.lettergrid[testposition][word.ycoordinate] == "-"
						then leftposition = testposition + 1
						end
					testposition -= 1
				end
				if leftposition == "not found" 
					then leftposition = 0
					end
				#puts "leftposition #{leftposition}"
				#find right
				testposition = word.xcoordinate + word.astring.size
				rightposition = "not found"
				while testposition < self.dimension && rightposition == "not found"
					if self.lettergrid[testposition][word.ycoordinate] == "-"
						then rightposition = testposition - 1
						end
					testposition += 1
				end
				if rightposition == "not found" 
					then rightposition = self.dimension - 1
					end
				# it is necessary to do the rest of this only if leftposition or rightposition goes beyond the bounds ofthe word
				if leftposition != word.xcoordinate || rightposition != (word.xcoordinate + word.astring.size - 1)
				then
					#fill in left part of array
					currentposition = leftposition
					while currentposition < word.xcoordinate
						testwordarray << self.lettergrid[currentposition][word.ycoordinate]
						currentposition += 1
					end
		
					#fill the word into the array
					while  currentposition < word.xcoordinate + word.astring.length 
						testwordarray << word.astring[currentposition - word.xcoordinate]
						currentposition += 1
					end
					
					
					#fill in right part of array
					while currentposition < rightposition + 1
						testwordarray << self.lettergrid[currentposition][word.ycoordinate]
						currentposition += 1
					end
					
					status = testwordarray.join('').isaword
					#puts "status #{status} for word #{testwordarray.join('')} from inline down"
					if status
						then
						#score for full word generated inline - score for the proposed word is the supplement
						generatedword = ScrabbleWord.new(testwordarray.join(''),leftposition,word.ycoordinate,"down",0,0)
                        akey = generatedword.createkey
                        if word.suppwords[akey]
                        then
                            puts "duplicate #{generatedword.astring}, xc #{generatedword.xcoordinate}, yc #{generatedword.ycoordinate}, dirx #{generatedword.direction}"
                        else
                            word.suppwords[akey] = generatedword
                            self.scoreandplacewordfromtiles(generatedword, $aGame.currentplayertileset, nil)
                            self.scoreandplacewordfromtiles(word, $aGame.currentplayertileset, nil)
                            difference =  generatedword.score - word.score
                            word.supplement = word.supplement + difference
						end
                        
                        #puts generatedword.print("temp inline down generated")
						#puts word.print("temp inline down source")
						
					end
				else
					status = word.astring
				end
			end

		return status
	end

	def testwordsgenortho (word) #this method tests a possible word addition, rejects if it creates a non-word orthogonal to the test word. It also calculates the supplemental score if a word is generated orthogonal to the testword.
		
			#puts word.print("starting word")
			case
			when word.direction == "down"
				wordposition = 0
				status = true
				while (wordposition < word.astring.size && status == true)
					if self.lettergrid[word.xcoordinate + wordposition][word.ycoordinate] == '-'
						testwordarray = []
						#find left
						testposition = word.ycoordinate - 1
						leftposition = "not found"
						while testposition > -1 && leftposition == "not found"
							if self.lettergrid[word.xcoordinate + wordposition][testposition] == "-"
								then leftposition = testposition + 1
								end
							testposition -= 1
						end
						if leftposition == "not found" 
							then leftposition = 0
							end
						#puts "leftposition #{leftposition}"
						#find right
						testposition = word.ycoordinate + 1
						rightposition = "not found"
						while testposition < self.dimension && rightposition == "not found"
							if self.lettergrid[word.xcoordinate + wordposition][testposition] == "-"
								then rightposition = testposition - 1
								end
							testposition += 1
						end
						if rightposition == "not found" 
							then rightposition = self.dimension - 1
							end
						#puts "rightposition #{rightposition}"
						if leftposition != rightposition 
						then
							#fill in left part of array
							currentposition = leftposition
							while currentposition < word.ycoordinate
								testwordarray << self.lettergrid[word.xcoordinate + wordposition][currentposition]
								currentposition += 1
							end
				
							#fill the word into the array; at this point currentposition = word.ycoordinate
							testwordarray << word.astring[wordposition]
							currentposition += 1
							
							
							#fill in right part of array
							while currentposition < rightposition + 1
								testwordarray << self.lettergrid[word.xcoordinate + wordposition][currentposition]
								currentposition += 1
							end
							status = testwordarray.join('').isaword
							#puts "status #{status} for word #{testwordarray.join('')} from ortho down"
							if status
							then
								generatedword = ScrabbleWord.new(testwordarray.join(''),word.xcoordinate + wordposition,leftposition,"right",0,0)
                                akey = generatedword.createkey
                                if word.suppwords[akey]
                                    then
                                    puts "duplicate #{generatedword.astring}, xc #{generatedword.xcoordinate}, yc #{generatedword.ycoordinate}, dirx #{generatedword.direction}"
                                    else
                                    word.suppwords[akey] = generatedword
                                    self.scoreandplacewordfromtiles(generatedword, $aGame.currentplayertileset, nil)
                                    word.supplement = word.supplement + generatedword.score
                                end
								#puts generatedword.print("ortho down generated")
								#puts word.print("ortho down source")
                                
                                
								#puts "supplement: #{word.supplement}"
                            else
                                #puts "failed word: #{testwordarray.join('')}"
							end
						end
					end
				wordposition += 1
				end
			when word.direction == "right" 
			#puts "testwordsgenortho right"
				wordposition = 0
				status = true
				while (wordposition < word.astring.size  && status == true)
					if self.lettergrid[word.xcoordinate][word.ycoordinate + wordposition] == '-'
						testwordarray = []
						#find left
						testposition = word.xcoordinate - 1
						leftposition = "not found"
						while testposition > -1 && leftposition == "not found"
							if self.lettergrid[testposition][word.ycoordinate + wordposition] == "-"
								then leftposition = testposition + 1
								end
							testposition -= 1
						end
						if leftposition == "not found" 
							then leftposition = 0
							end
						#puts "leftposition #{leftposition}"
						#find right
						testposition = word.xcoordinate + 1
						rightposition = "not found"
						while testposition < self.dimension && rightposition == "not found"
							if self.lettergrid[testposition][word.ycoordinate + wordposition] == "-"
								then rightposition = testposition - 1
								end
							testposition += 1
						end
						if rightposition == "not found" 
							then rightposition = self.dimension - 1
							end
						#puts "rightposition #{rightposition}"
						if leftposition != rightposition 
						then				
							#fill in left part of array
							currentposition = leftposition
							while currentposition < word.xcoordinate
								testwordarray << self.lettergrid[currentposition][word.ycoordinate + wordposition]
								currentposition += 1
							end
				
							#fill the word into the array; at this point currentposition = word.xcoordinate
							testwordarray << word.astring[wordposition]
							currentposition += 1
							
							
							#fill in right part of array
							while currentposition < rightposition + 1
								testwordarray << self.lettergrid[currentposition][word.ycoordinate + wordposition]
								currentposition += 1
							end
							
							status = testwordarray.join('').isaword
							#puts "status #{status} for word #{testwordarray.join('')} from ortho right"
                            
                            if status
								then
								generatedword = ScrabbleWord.new(testwordarray.join(''),leftposition,word.ycoordinate + wordposition,"down",0,0)
                                akey = generatedword.createkey
                                if word.suppwords[akey]
                                    then
                                    puts "duplicate #{generatedword.astring}, xc #{generatedword.xcoordinate}, yc #{generatedword.ycoordinate}, dirx #{generatedword.direction}"
                                    else
                                    word.suppwords[akey] = generatedword
                                    self.scoreandplacewordfromtiles(generatedword, $aGame.currentplayertileset, nil)
                                    word.supplement = word.supplement + generatedword.score
                                end
								#puts generatedword.print("temp inline down generated")
								#puts word.print("temp inline down source")
                                
								#puts "supplement: #{word.supplement}"
                            else
                                #puts "failed word: #{testwordarray.join('')}"
							end						
						end
					end
				wordposition += 1
				end
			end
		return status
	end

	def readboard (afilename)
        afile = File.open(afilename, "r")
		rows = File.readlines(afilename).map { |line| line.chomp } #this is an array of the board rows each as a string, the last row being the tiles
        i = 0
        while i < self.dimension
                rowletters = rows[i].to_chars # this is an array of characters for one of the rows
                rowletters.each_index {|j|
                self.lettergrid[i][j] = rowletters[j]
                }
        i += 1
        end
        i = self.dimension + 6
        while i < (self.dimension + 6 + self.dimension)
                rowletters = rows[i].to_chars # this is an array of characters for one of the rows
                rowletters.each_index {|j|
                    self.scoregrid[i - self.dimension - 6][j] = rowletters[j]
                }
        i += 1
		end
        tiles1 = rows[self.dimension].sub('tiles1: ','')
        tiles2 = rows[self.dimension+1].sub('tiles2: ','')
        tilesr = rows[self.dimension+2].sub('tilesr: ','')
        mode = rows[self.dimension+3].sub('mode: ','')
        score1 = rows[self.dimension+4].sub('score1: ','').to_i
        score2 = rows[self.dimension+5].sub('score2: ','').to_i
        afile.close
        return [tiles1, tiles2, tilesr, mode, score1, score2]
	end

	
	def writeboard (afilename, tiles1, tiles2, tilesr, mode, score1, score2)
		afile = File.open(afilename, "w")
		i = 0
		while i < self.dimension
			j = 0
			anarray = []
			while j < self.dimension
				anarray << self.lettergrid[i][j]			
			j += 1
			end
			afile.puts(anarray.join())
		i += 1
		end
        afile.puts('tiles1: '+tiles1)
        afile.puts('tiles2: '+tiles2)
        afile.puts('tilesr: '+tilesr)
        afile.puts('mode: '+mode)
        afile.puts('score1: '+score1)
        afile.puts('score2: '+score2)
 		i = 0
		while i < self.dimension
			j = 0
			anarray = []
			while j < self.dimension
				anarray << self.scoregrid[i][j]
                j += 1
			end
			afile.puts(anarray.join())
            i += 1
		end
		afile.close
	end
    

	def readscores (afilename)
		rows = File.readlines(afilename).map { |line| line.chomp } #this is an array of the board rows each as a string
			rows.each_index {|i| 
			rowletters = rows[i].to_chars # this is an array of characters for one of the rows
			rowletters.each_index {|j|
			self.scoregrid[i][j] = rowletters[j]
			}
		}
		
	end
	
	def printscores
		i = 0
		while i < self.dimension
			j = 0
			anarray = []
			while j < self.dimension
				anarray << self.scoregrid[i][j]
				j += 1
			end
			puts anarray.join(' | ')
			puts "_________________________________________________________"
			i += 1
		end		
		
	end	
	
	def findBoardSWs
		self.boardSWs = []
		#find words going down
		
		j = 0 
		while j < self.dimension # for the jth column
			i = 0
			
			while i < (self.dimension - 1) #look for the start of a SW
				if self.lettergrid[i][j] != "-"
				then	if self.lettergrid[i+1][j] != "-" #start a word
						
						anarray = []
						anarray << self.lettergrid[i][j]
						anarray << self.lettergrid[i+1][j]
						# find the coordinate of the end
						h = i + 2
						while h < self.dimension && self.lettergrid[h][j] != "-"
							anarray << self.lettergrid[h][j]
							h += 1
						end
						aword = ScrabbleWord.new(anarray.join, i, j, "down", 0, 0)

						self.boardSWs << aword
						i = h + 1
					else 
						i += 2
					end
				else 
					i += 1
				end
			end
			j += 1
		
		end
		
		#find words going right
		i = 0 
		while i < self.dimension # for the ith row
			j = 0
			
			while j < (self.dimension - 1) #look for the start of a SW
				if self.lettergrid[i][j] != "-"
				then	if self.lettergrid[i][j+1] != "-" #start a word
						
						anarray = []
						anarray << self.lettergrid[i][j]
						anarray << self.lettergrid[i][j+1]
						# find the coordinate of the end
						h = j + 2
						while h < self.dimension && self.lettergrid[i][h] != "-"
							anarray << self.lettergrid[i][h]
							h += 1
						end
						aword = ScrabbleWord.new(anarray.join, i, j, "right", 0, 0)

						self.boardSWs << aword
						j	 = h + 1
					else j += 2
					end
				else 
					j += 1
				end
			end
			i += 1
		
		end
	end
	
	
	def scorestring (astring)
		ascore = 0
		i = 0
		while i < astring.length
			ascore = ascore + self.lettervalues[astring[i]]
			i += 1
		end
		return ascore
	end

	def proposedchars(proposedSWs) #returns two dimensional array x, y of vectors containing proposed characters
		anarray = []
		x = 0
		while x < self.dimension
			y = 0
			yarray = []
			while y < self.dimension
				yarray << []
				y += 1
			end
			anarray << yarray
			x += 1
		end
		
		proposedSWs.each{|aSW|
			case
			when aSW.direction == "down"
				i = 0
				while i < aSW.astring.size
					anarray[aSW.xcoordinate + i][aSW.ycoordinate] << aSW.astring[i]
					i += 1
				end
			when aSW.direction == "right"
				i = 0
				while i < aSW.astring.size
					anarray[aSW.xcoordinate][aSW.ycoordinate + i] << aSW.astring[i]
					i += 1
				end
			end
		}

		return anarray
	end

	def findBoardLetters
		self.boardLetters = []
        i = 0
        while i < self.dimension
            j = 0
            while j < self.dimension
                self.boardLetters <<  self.lettergrid[i][j] if self.lettergrid[i][j] != '-'
            j += 1
            end
        i += 1
        end
	end

    def findfilledcoordinates
        self.filledcoordinates = []
        self.boardSWs.each {|aSW|
            aSW.coordinatesused.each {|acoordinate| self.filledcoordinates << acoordinate}
        }

    end
	
	def findPossibleWords(astring) #finds all words that can be made with tiles plus the letter specified as argument;; words inlcude words that can be made with a single * character that will later be resolved to an actual letter.
		allpossiblewords = []
        tilesplus = self.tileword + astring
        tilepermutes = tilesplus.permutedset
        tilewords_plus = []
        tilepermutes.each {|astring|
            aset = astring.isaword_plus
            if aset
                aset.each {|aword| tilewords_plus << aword }
            end
        }
		return self.sortwords(tilewords_plus)
	end

    def findPossibleStrings
        aset = self.tileword.permutedset
        return aset
    end

    def findPossibleStringsofSize
        ahash = {}
        i = 1
        while i < self.tileword.size + 1
            ahash[i] = self.tileword.permutedsetofsize(i) #returns an array of strings of size i
            i += 1
        end
        return ahash
    end

def findPossibleWordsofSize
    ahash = {}
    self.tilewordwords.each {|aword|
    if ahash[aword.size]
    then ahash[aword.size] << aword
    else
        ahash[aword.size] = [aword]
    end
    }
    return ahash
end

    def sortwords(set)
        set.sort_by {|word| [-(self.wordscore(word))]}
    end

    def wordscore(word)
            sum = 0
            word.scan(/./).each{|letter| sum = sum + lettervalues[letter]}
            return sum/word.size
    end
                
    def firstword #returns a ScrabbleWord or nil
        coordinates = [[7,7,'right'], [7,7,'down']] #the tilewords must overlap this position on either axis
        allpossibles = self.placetilewords(findPossibleWords(''),coordinates) #this returns SWs that overlap this position
        allpossibles = allpossibles.uniqSWs
        allpossibles.each {|possible| self.scoreandplacewordfromtiles(possible, $aGame.currentplayertileset, nil)}
        allpossibles = allpossibles.sort_by {|possible| [-(possible.score + possible.supplement)]}
        if not(allpossibles.empty?)
            then
            dirx = "down"
            dirx = "right" if rand(2) == 0 # dirx will be either right of down depending on rand
            i = 0
            while i < allpossibles.size
                return allpossibles[i]  if allpossibles[i].direction == dirx #return highest scoring SW
                i += 1
            end
            else return nil
        end
    end

def revertboard
    self.popgrids
end

def pushgrids
    i = 0
    while i < self.dimension
        j = 0
        while j < self.dimension
            self.pushnewgrid[i] = self.newgrid[i].dup
            self.pushlettergrid[i] = self.lettergrid[i].dup
            self.pushscoregrid[i] = self.scoregrid[i].dup
            j += 1
        end
        i += 1
    end
end

def popgrids
    i = 0
    while i < self.dimension
        j = 0
        while j < self.dimension
            self.newgrid[i] = self.pushnewgrid[i].dup
            self.lettergrid[i] = self.pushlettergrid[i].dup
            self.scoregrid[i] = self.pushscoregrid[i].dup
            j += 1
        end
        i += 1
    end
end

def scoreandplacewordfromtiles(aSW, fromtiles, permanent) #used to place a SW on board and deduct from newtileword, calculates direct score for placing the aSW and sets which word is new on board; used by self.firstword and by WFweb'/updated' and by manualtestword; permanent set to nil if intent is to remove the word after scoring and set to "true" if the intent is leave the word placed.
    #puts "scoring word = aSW #{aSW.astring}, for permstatus = #{permanent}"
    anarray = []
    anarray << 1
    ascore = 0
    self.pushgrids
    self.resetnewindicator
    self.newtileword = fromtiles
    status = "true"
    i = 0
    while i < aSW.astring.length
        case
            when aSW.direction == "right"
            xc = aSW.xcoordinate
            yc = aSW.ycoordinate + i
            when aSW.direction == "down"
            xc = aSW.xcoordinate + i
            yc = aSW.ycoordinate
        end
        scoremultiplier = self.scorehelper(xc, yc) #must be done before letter placed
        case
        when self.lettergrid[xc][yc] != '-'
            scorevalue = self.lettervalues[aSW.astring[i]]
        when self.lettergrid[xc][yc] == '-'
            if self.newtileword.include?(aSW.astring[i])
                self.lettergrid[xc][yc] = aSW.astring[i].dup
                scorevalue = self.lettervalues[aSW.astring[i]]
                self.newtileword = self.newtileword.sub(aSW.astring[i],'')
            elsif self.newtileword.include?'*'
                self.lettergrid[xc][yc] = aSW.astring[i].dup
                scorevalue = 0
                self.newtileword = self.newtileword.sub('*','')
                self.scoregrid[xc][yc] = '*'
            else
                status = nil
            end
        end
        if status
            case
            when scoremultiplier == 'W'
            anarray << 3
            ascore = ascore + scorevalue
            when scoremultiplier == 'w'
            anarray << 2
            ascore = ascore + scorevalue
            when scoremultiplier == 'L'
            ascore = ascore + 3 * scorevalue
            when scoremultiplier == 'l'
            ascore = ascore + 2 * scorevalue
            when scoremultiplier == '-'
            ascore = ascore + scorevalue
            when scoremultiplier == '*'
            ascore = ascore
            end
        end
        self.newgrid[xc][yc] = 'n'
        #puts "i = #{i}, letter #{aSW.astring[i]}, ascore = #{ascore}"
    i += 1
    end
    case
    when  status && permanent
        aSW.score = ascore * anarray.max
        #puts "aSW.score #{aSW.score}"
        return self.newtileword
        self.boardchanged = true
    when status && not(permanent)
        aSW.score = ascore * anarray.max
        #puts "aSW.score #{aSW.score}"
        self.popgrids
        return self.newtileword
    when not(status)
        self.popgrids
        return status
    end
end


def couldplacewordfromtiles(aSW, fromtiles) #used to check whether one could place a SW on board with the fromtiles and without changing any letter on the board. Returns nil if invalid move.
    self.pushgrids #holds the newgrid and lettergrid and scoregrid in case of an undo
    remainingtileword = fromtiles
    status = 'true'
    case
        when aSW.direction == "right"
        i = 0
        while i < aSW.astring.length
            if (self.lettergrid[aSW.xcoordinate][aSW.ycoordinate + i] == '-') && (remainingtileword.include?aSW.astring[i])
                remainingtileword= remainingtileword.sub(aSW.astring[i],'')
            elsif (self.lettergrid[aSW.xcoordinate][aSW.ycoordinate + i] == aSW.astring[i])
            elsif (self.lettergrid[aSW.xcoordinate][aSW.ycoordinate + i] == '-') && (remainingtileword.include?'*')
                remainingtileword= remainingtileword.sub('*','')
                #self.scoregrid[aSW.xcoordinate][aSW.ycoordinate + i] = '*' #this prepares to not count the score form this letter when it is placed
            else status = nil
            end
            i += 1
        end
        when aSW.direction == "down"
        i = 0
        while i < aSW.astring.length
            if (self.lettergrid[aSW.xcoordinate + i][aSW.ycoordinate] == '-') && (remainingtileword.include?aSW.astring[i])
                remainingtileword= remainingtileword.sub(aSW.astring[i],'')
            elsif (self.lettergrid[aSW.xcoordinate + i][aSW.ycoordinate] == aSW.astring[i])
            elsif (self.lettergrid[aSW.xcoordinate + i][aSW.ycoordinate] == '-') && (remainingtileword.include?'*')
                remainingtileword= remainingtileword.sub('*','')
                #self.scoregrid[aSW.xcoordinate + i][aSW.ycoordinate] = '*' #this prepares to not count the score from this letter when it is placed
            else status = nil
            end
            i += 1
        end
    end
    self.popgrids if not(status) #if the word is invalid then roll back the grids (scoregrid may have changed)
    return status
end

def scorehelper(xcoord, ycoord)  #used by placewordfromtiles to score a letter placed
    gridvalue = self.scoregrid[xcoord][ycoord]
    occupied = "true"
    occupied = "false" if self.lettergrid[xcoord][ycoord] == '-'
    case
        when gridvalue == "*" #scoregrid is set to "*" if a '*' character was previously used to put a letter on the lettergrid
        ascore = '*'
        when gridvalue == "-"
        ascore = '-'
        when gridvalue == "l"
        ascore = 'l' if occupied =="false"
        ascore = '-' if occupied == "true"
        when gridvalue == "L"
        ascore = 'L' if occupied == "false"
        ascore = '-' if occupied == "true"
        when gridvalue == "w"
        ascore = '-' if occupied == "true"
        ascore = 'w' if occupied == "false"
        when gridvalue == "W"
        ascore = '-' if occupied == "true"
        ascore = 'W' if occupied == "false"
    end
return ascore
end

end  #class






