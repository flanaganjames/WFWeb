class Wordfriend
	attr_accessor :myboard, :gameuser, :gamefile, :possiblewords
    
    require './resource_methodsOO'
	require './resource_classSW'
    require './resource_classBoard'
    
    

	def initialvalues
        self.gameuser = "Games"
        self.gamefile = "lastgame"
		self.myboard = ScrabbleBoard.new
		self.myboard.initialvalues
		# self.readboard
		self.myboard.readscores("SWscoreResource.txt")
		#self.myboard.findBoardSWs
		#self.myboard.findBoardLetters
        #$tiles = self.myboard.tileword
		#$tilepermutedset = $tiles.permutedset
		$words = {}
		wordarray = File.readlines("wordlist.txt").map { |line| line.chomp }
		i = 0
		while i < wordarray.size
			$words[wordarray[i]] = 'true'
			i += 1
		end
		#$tilewords = $tilepermutedset.select {|astring| astring.isaword} #words that can be made with the tiles
		#$possibleWords = self.myboard.findPossibleWords #finds all words that can be made with tiles plus one of the letters on the board
	end
    
    def readboard
        self.myboard.readboard("./" + self.gameuser + "/" + self.gamefile + ".txt")
    end
    
    def updatevalues
        self.readboard
        self.myboard.findBoardSWs
		self.myboard.findBoardLetters
        $tiles = self.myboard.tileword
		$tilepermutedset = $tiles.permutedset
		$tilewords = $tilepermutedset.select {|astring| astring.isaword} #words that can be made with the tiles
		$possibleWords = self.myboard.findPossibleWords#finds all words that can be made with tiles plus one of the letters on the board
    end

	def saveboard
	self.myboard.writeboard("./" + self.gameuser + "/" + self.gamefile + ".txt")
	end

	def RevertBoard
		self.myboard.readboard("Games/" + self.gamefile  + ".txt")
        $tiles = self.myboard.tileword
        $tilepermutedset = $tiles.permutedset
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