class Wordfriend
	attr_accessor :myboard, :gameuser, :gamefile, :possiblewords, :usergames
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
		i = 0
		while i < wordarray.size
			$words[wordarray[i]] = 'true'
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
            aFile = File.open("./Users/" + self.gameuser + "/" + self.gamefile + ".txt", "w")
            i = 0
            while i < self.myboard.dimension
               aFile.puts("---------------")
               i += 1
            end
            aFile.puts("-------")
            aFile.puts("-------")
            aFile.puts("-------")#for tilesremain
            aFile.close
        end
    end
    
    def getusergames
		self.usergames = []
        Dir.foreach("./Users/" + self.gameuser + "/") {|aFile|
            self.usergames.push(aFile.gsub(".txt", "")) if (aFile != "." && aFile != "..")
        }
    
    end
    
    
    def readboard
        tilesarray =self.myboard.readboard("./Users/" + self.gameuser + "/" + self.gamefile + ".txt")
        return tilesarray
    end
 
    def saveboard(tiles1, tiles2, tilesr)
        self.myboard.writeboard("./Users/" + self.gameuser + "/" + self.gamefile + ".txt", tiles1, tiles2, tilesr)
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
		self.myboard.findBoardLetters
        $tiles = self.myboard.tileword
		$tilepermutedset = self.myboard.tileword.permutedset
		$tilewords = self.myboard.findPossibleTileWords #words that can be made with the tiles
		$possibleWords = self.myboard.findPossibleWords#finds all words that can be made with tiles plus one of the letters on the board
    end

	def RevertBoard
		tilesets = self.readboard("Games/" + self.gamefile  + ".txt")
        $aGame.tilesplayer1 = tilesets[0]
        $aGame.tilesplayer2 = tilesets[1]
        $aGame.tilesremain = tilesets[2].scan('')
        aWordfriend.myboard.resetnewindicator
        self.myboard.tileword = $aGame.tilesplayer2
        $tiles = self.myboard.tileword
        $tilepermutedset = self.myboard.tileword.permutedset
        $tilewords = $tilepermutedset.select {|astring| astring.isaword}
	end

    def wordfind
        #        require './resource_methodsOO'
        #        require './resource_classSW'
        #        require './resource_classBoard'
        
        possibles = []
        allpossibles = []
        arraySWs = self.myboard.boardSWs
        #arraySWs.each {|aword| aword.print("initial")}
        #Parallel Words
        #this part finds words that can be placed in parallel to existing words wherever there are blank positions.
        #it first finds words that can be made from tiles and also finds existing blank positions that are next to filled positions
        #then it tries to place those words into blank positions, trying each possible register, ensuring that the word falls on the board and
        #ensuring that it does not replace an already filled positions with a different letter.
        #this does not account for trying words that can be created by combining tile letters with already placed letters -this happens below
        
        coordinates = self.myboard.findblankparallelpositions
        possibles = self.myboard.placetilewords($tilewords, coordinates)
        possibles = possibles.uniqSWs
        possibles = possibles.select {|possible|self.myboard.testwordsgeninline(possible)}
        possibles = possibles.select {|possible| self.myboard.testwordsgenortho(possible)}
        possibles.each {|possible| allpossibles << possible}
        
        #for every word already on the board
        #find words that can be made with tiles by placing them orthoganal to the start, middle letters, or end letters
        #find words that can be made with tiles by placing them in line with existing words
        #then test to see if the possible words are entirely on the board (testwordonboard) and select only those
        #then test to see if placing the word will change the letter in any already filled position (testwordoverlap) and reject those
        #then test to see if placing the word incidentally creates another nonword orthogonal/next to the word being placed and reject those
        #then test to see if placing the word incidentally creates another nonword inline with the word being placed and reject those
        #for these last two steps is it incdentally creates a valid word in either (ortho or inline) then computer the supplemental score due to those
        
        while arraySWs.size > 0
            currentSW = arraySWs.pop
            aSWpossibles = []
            currentSW.wordfindortho.each {|aSW| aSWpossibles << aSW }
            currentSW.wordfindorthomid.each {|aSW| aSWpossibles << aSW }
            currentSW.wordfindinline.each {|aSW| aSWpossibles << aSW }
            aSWpossibles = aSWpossibles.uniqSWs
            aSWonboard = aSWpossibles.select {|aSW| self.myboard.testwordonboard(aSW)}
            aSWquarterfinals = aSWonboard.select {|possible| self.myboard.testwordoverlap(possible)}
            aSWsemifinals = aSWquarterfinals.select {|possible| self.myboard.testwordsgenortho(possible)}
            aSWfinals = aSWsemifinals.select {|possible|self.myboard.testwordsgeninline(possible)}
            aSWfinals.each {|aSW| allpossibles << aSW}
        end
        
        
        #compute the score directly attributable to placing the new word and sort by value of direct score plus the supplemental score
        allpossibles = allpossibles.uniqSWs
        allpossibles.each {|possible| possible.scoreword(self.myboard)}
        allpossibles = allpossibles.sort_by {|possible| [-(possible.score + possible.supplement)]}
        self.possiblewords = allpossibles
        return allpossibles
	end
    
end