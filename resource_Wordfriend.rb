class Wordfriend
	attr_accessor :myboard, :gameuser, :gamefile, :usergames, :newgame, :possiblewords
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
        
        $words_plus = {}
		wordarray = File.readlines("wordlist_plus.txt").map { |line| line.chomp }
        #this word list has every possible word with * in place of every possible letter
		i = 0
		while i < wordarray.size
            aword = wordarray[i] if wordarray[i].isaword
			if !$words_plus[wordarray[i]]
                then
                $words_plus[wordarray[i]] = [aword]
                else
                $words_plus[wordarray[i]] << aword
            end
			i += 1
		end
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
        self.newgame = "no"
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

    
    def updatevalues(aplayertileset)
        self.myboard.tileword = aplayertileset
        self.myboard.describehotspots
        self.myboard.tilewordwords = self.myboard.findPossibleWords('')
        self.myboard.tilewordstrings = self.myboard.findPossibleStrings
        self.myboard.tilewordstringsofsize = self.myboard.findPossibleStringsofSize
        self.myboard.tilewordwordsofsize = self.myboard.findPossibleWordsofSize
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
        (puts('notvalidcoord');return status) if not(self.myboard.usesvalidmovecoordinates(aSW)) #returns nil if does not cross (intersect) or be adjacent to an existing word
        (puts('notonboard');return status) if not(self.myboard.testwordonboard(aSW))
        (puts('overlap');return status) if not(self.myboard.testwordoverlap(aSW))
        (puts('geninline');return status) if not(self.myboard.testwordsgeninline(aSW)) #updates score or supplement or returns nil
        (puts('genortho');return status) if not(self.myboard.testwordsgenortho(aSW)) #updates score or supplement or returns nil
        (puts('placefromtiles');return status) if not(self.myboard.couldplacewordfromtiles(aSW, $aGame.tilesplayer2)) #checks whether the word can be placed with players tiles or board letters without changing a board letter, else returns nil
        status = 'true'
        return status
    end
    
    def wordfind 
        self.myboard.findhotspotSWs
	end
    
end