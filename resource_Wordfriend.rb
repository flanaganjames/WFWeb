class Wordfriend
	attr_accessor :myboard, :gameuser, :gamefile, :possiblewords, :usergames, :newgame
    #these instance variables view the current user (user whose turn it is currently)
    #the board is the same, though out of phase as each turn occurs, and the tiles are different
    #see Class Game which supports two users - usually a user versus the computer
    #as each user takes his turn, the instance variables of this class are switched
    
    require './resource_methodsOO'
	require './resource_classSW'
    require './resource_classBoard'

	def initialvalues

        self.myboard = ScrabbleBoard.new
		self.myboard.initialvalues
        

		$words = {}
		wordarray = File.readlines("wordlist.txt").map { |line| line.chomp }
        #this word list has every possible word with * in place of every possible letter
		i = 0
		while i < wordarray.size
			$words[wordarray[i]] = 'true'
			i += 1
		end
        
        $words_plus = {}
		wordarray = File.readlines("wordlist_plus.txt").map { |line| line.chomp }
        #this word list has every possible word with * in place of every possible letter
		i = 0
		while i < wordarray.size
			$words_plus[wordarray[i]] = 'true'
			i += 1
		end
        #self.saveboard($aGame.tilesplayer1, $aGame.tilesplayer2, $aGame.tilesremain.join('')) #
	end
    
    def removeuserdirectoryifempty
        Dir::rmdir("./Users/" + self.gameuser) if self.usergames.empty?
    end
    
    def createuserdirectory #create user directory if it does not exist
        if not(FileTest::directory?("./Users/" + self.gameuser))
            Dir::mkdir("./Users/" + self.gameuser)
        end
    end
    
    def creategamefile #create the game file if it does not exist
        #        if !(File.exist?("./Users/" + self.gameuser + "/" + self.gamefile))
        if not(self.usergames.include? self.gamefile)
            self.newgame = "yes"
            aFile = File.open("./Users/" + self.gameuser + "/" + self.gamefile, "w")
            i = 0
            while i < self.myboard.dimension
               aFile.puts("---------------")
               i += 1
            end
            aFile.puts("-------")
            aFile.puts("-------")
            aFile.puts("-------")#for tilesremain
            aFile.close
        else
            self.newgame = "no"
        end
        return self.newgame
    end
    

    def getusergames
		self.usergames = []
        Dir.foreach("./Users/" + self.gameuser + "/") {|aFile|
            self.usergames.push(aFile.sub(".txt", "")) if (aFile != "." && aFile != "..")
        }
    
    end
    
    
    def readboard
        tilesarray =self.myboard.readboard("./Users/" + self.gameuser + "/" + self.gamefile)
        return tilesarray
    end
 
    def saveboard(tiles1, tiles2, tilesr, mode, score1, score2)
        self.myboard.writeboard("./Users/" + self.gameuser + "/" + self.gamefile, tiles1, tiles2, tilesr, mode, score1, score2)
	end
    
    def resetnewindicator
        self.myboard.resetnewindicator
    end

    
    def updatevalues(aplayertileset) #set to either 0 or 1
        #tilesets =self.readboard  #this grabs board and an array containing two tilesets and tilesremain
        #$aGame.tilesplayer1 = tilesets[0]
        #$aGame.tilesplayer2 = tilesets[1]
        #$aGame.tilesremain = tilesets[2].scan('')
        self.myboard.tileword = aplayertileset
        self.myboard.findBoardSWs
		#self.myboard.findBoardLetters #was used only by findPossibleWords
        self.myboard.findcoordinatesusable #finds filled coordinates usable
        self.myboard.findblankparallelpositions #also finds and blank coordinates usable
        $tiles = self.myboard.tileword
		$tilepermutedset = self.myboard.tileword.permutedset #used in wordfindinline where '*' are replaced with letters once tiles combined with other chars
		$tilewords = self.myboard.findPossibleTileWords #words that can be made with the tiles;  this is used by wordfind and firstword in a call to placetilewords
        #if there was a '*' char in the tiles, this was replaced by actual letters to make words.
		
        #this is used by wordfindorthomid in classS
        #$possibleWords = self.myboard.findPossibleWords #was used in wordfindorthomid
        #finds all words that can be made with tiles plus one of the letters on the board
    end
    
    def firstword
        self.myboard.firstword
    end
    
    def placewordfromtiles(aSW, fromtiles)
        return self.myboard.scoreandplacewordfromtiles(aSW, fromtiles, "true")
    end
    

	def revertboard
        self.myboard.revertboard
	end

    def manualwordtest(aSW) #this tests a proposed move for validity:
        # must be a valid word (is a valid key in a hash called $words (method in resource_methods) AND
        # must cross (intersect) of be adjacent to an existing word  AND
        # must not generate any invalid words in line with itself or orthogonal to itself
        #must not replace an existing board letter with a different letter
        #must be on the board
        #must be placed using user tiles or letters on board
        status = nil
        (puts('notaword');return status) if not(aSW.astring.isaword)  #returns nil if not a word
        (puts('notvalidcoord');return status) if not(self.usesvalidmovecoordinates(aSW)) #returns nil if does not cross (intersect) or be adjacent to an existing word
        (puts('notonboard');return status) if not(self.myboard.testwordonboard(aSW))
        (puts('overlap');return status) if not(self.myboard.testwordoverlap(aSW))
        (puts('geninline');return status) if not(self.myboard.testwordsgeninline(aSW)) #updates score or supplement or returns nil
        (puts('genortho');return status) if not(self.myboard.testwordsgenortho(aSW)) #updates score or supplement or returns nil
        (puts('placefromtiles');return status) if not(self.myboard.couldplacewordfromtiles(aSW, $aGame.tilesplayer2)) #checks whether the word can be placed with players tiles or board letters without changing a board letter, else returns nil
        status = 'true'
        return status
    end
    
    def usesvalidmovecoordinates(aSW) #checks myboard.filledcoordinatesusable and blankcoordinatesusable to see if at least one of them is used by aSW        
        status = nil
        case
        when aSW.direction == 'right'
            i = 0
            while i < aSW.astring.length
                #puts "coordinate #{[aSW.xcoordinate, aSW.ycoordinate + i]}"
                status = 'true' if (self.myboard.blankcoordinatesusable.include?([aSW.xcoordinate, aSW.ycoordinate + i]) || self.myboard.filledcoordinatesusable.include?([aSW.xcoordinate, aSW.ycoordinate + i]))
                #puts "status #{status}"
                i += 1
            end
        when aSW.direction == 'down'
            i = 0
            while i < aSW.astring.length
                #puts "coordinate #{[aSW.xcoordinate + i, aSW.ycoordinate]}"
                status = 'true' if (self.myboard.blankcoordinatesusable.include?([aSW.xcoordinate + i, aSW.ycoordinate]) || self.myboard.filledcoordinatesusable.include?([aSW.xcoordinate + i, aSW.ycoordinate]))
                #puts "status #{status}"
                i += 1
            end
        end
        return status 
    end
    
    def wordfind
        #        require './resource_methodsOO'
        #        require './resource_classSW'
        #        require './resource_classBoard'
        
        
        
        
        #arraySWs.each {|aword| aword.print("initial")}
        #Parallel Words
        #this part finds words that can be placed in parallel to existing words wherever there are blank positions.
        #it first finds words that can be made from tiles and also finds existing blank positions that are next to filled positions
        #then it tries to place those words into blank positions, trying each possible register, ensuring that the word falls on the board and
        #ensuring that it does not replace an already filled positions with a different letter.
        #this does not account for trying words that can be created by combining tile letters with already placed letters -this happens below

        
        #for every word already on the board
        #find words that can be made with tiles by placing them orthoganal to the start, middle letters, or end letters
        #find words that can be made with tiles by placing them in line with existing words
        #then test to see if the possible words are entirely on the board (testwordonboard) and select only those
        #then test to see if placing the word will change the letter in any already filled position (testwordoverlap) and reject those
        #then test to see if placing the word incidentally creates another nonword orthogonal/next to the word being placed and reject those
        #then test to see if placing the word incidentally creates another nonword inline with the word being placed and reject those
        #for these last two steps is it incdentally creates a valid word in either (ortho or inline) then computer the supplemental score due to those
        
        #does not use wordfindcontains.  why?
        
        #the word generaters below do their own testing of onboard etc.
        puts "This is wordfind"
        wfparalleltime = 0
        wforthotime = 0
        wforthomidtime = 0
        wfinlinetime = 0
        
        t1 = Time.now
        allpossibles = self.myboard.wordfindparallel
        wfparalleltime = (Time.now - t1)
        self.myboard.boardSWs.each {|currentSW|
            t1 = Time.now
            allpossibles = allpossibles + self.myboard.wordfindortho(currentSW)
            wforthotime = wforthotime + (Time.now - t1)
            t1 = Time.now
            allpossibles = allpossibles +  self.myboard.wordfindorthomid(currentSW)
            wforthomidtime = wforthomidtime + (Time.now - t1)
            t1 = Time.now
            allpossibles = allpossibles +  self.myboard.wordfindinline(currentSW)
            wfinlinetime = wfinlinetime + (Time.now - t1)
        }
        allpossibles = allpossibles.uniqSWs
        allpossibles = allpossibles.sort_by {|possible| [-(possible.score + possible.supplement)]}
        self.possiblewords = allpossibles
        puts "parallel: #{wfparalleltime}, ortho: #{wforthotime}, orthomid: #{wforthomidtime}, inline: #{wfinlinetime}"
        return allpossibles
	end
    
end