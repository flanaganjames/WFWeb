class Game
    attr_accessor :currentplayer, :currentplayertileset, :scoreadd, :gameplayer1, :gameplayer2, :tilesall, :tilesremain, :pushtilesremain, :tilesplayer1, :tilesplayer2, :pushtilesplayer2, :scoreplayer1, :scoreplayer2, :gameuser, :gamefile, :newgame, :mode
    #tilesplayer1/2 is each a single string of the concatenated tiles
    require './resource_Wordfriend'
    
    def initialvalues
        self.tilesall = []
        self.tilesall += ['a']*9
        self.tilesall += ['b']*2
        self.tilesall += ['c']*2
        self.tilesall += ['d']*4
        self.tilesall += ['e']*12
        self.tilesall += ['f']*2
        self.tilesall += ['g']*3
        self.tilesall += ['h']*2
        self.tilesall += ['i']*9
        self.tilesall += ['j']*1
        self.tilesall += ['k']*1
        self.tilesall += ['l']*4
        self.tilesall += ['m']*2
        self.tilesall += ['n']*6
        self.tilesall += ['o']*8
        self.tilesall += ['p']*2
        self.tilesall += ['q']*1
        self.tilesall += ['r']*6
        self.tilesall += ['s']*4
        self.tilesall += ['t']*6
        self.tilesall += ['u']*4
        self.tilesall += ['v']*2
        self.tilesall += ['w']*2
        self.tilesall += ['x']*1
        self.tilesall += ['y']*2
        self.tilesall += ['z']*1
        self.tilesall += ['*']*2
        
        self.tilesremain = self.tilesall.join('')
        self.scoreplayer1 = 0
        self.scoreplayer2 = 0
        self.scoreadd = 0
        self.tilesplayer1 = ''
        self.tilesplayer2 = ''
        $aWordfriend = Wordfriend.new
        $aWordfriend.initialvalues
        $allowedcharacters = 'abcdefghijklmnopqrstuvwxyz'
        $maxallowed = 25
        $stopafter = 2
    end
    
    
    def getusergame
        $aWordfriend.getusergames
        self.gamefile = "gamefile" #in this version, only one gamefile permitted
        $aWordfriend.gamefile = self.gamefile
        self.newgame = $aWordfriend.creategamefile #creates game file and fills it with '-' if it does not exist already and if so set newgame to "yes", else "no"
    end
    
    def choosereplacementtile
        if self.tilesremain.size > 0
            atile = self.tilesremain[rand(tilesremain.size)]
            self.tilesremain = self.tilesremain.sub(atile,'')
            return atile
        else
            return nil
        end
    end
    
    def filltiles(astr) #aplayerstiles may be self.tilesplayer1 or self.tilesplayer2
        atile = ''
        onestaronly = 0
        astr = astr.gsub('-','') #replace any '-' characters with '' blanks
        while atile && astr.size < 7 #stop if ever atile becomes nil
            atile = self.choosereplacementtile
            if (atile == '*') && (onestaronly > 0)
                self.tilesremain = self.tilesremain + '*'  # put it back, choose another
            else
                astr += atile if atile
                onestaronly += 1 if atile == '*'
            end
        end
        return astr
    end
    
    def replacealltiles(aplayerstiles) #aplayerstiles may be self.tilesplayer1 or self.tilesplayer2
        i = aplayerstiles.size
        while i > 0
            aletter = aplayerstiles[i-1]
            self.tilesremain << aletter # add the letters back to tile remaining
            aplayerstiles = aplayerstiles.sub(aletter, '') # and remove from aplayerstiles
            i -= 1
        end
        while aplayerstiles.size < 7
            atile = self.choosereplacementtile
            return if not(atile) #stops filling the tiles if there are no more tiles
            aplayerstiles += atile
        end
        return aplayerstiles
    end
    
    def initializegame  #new game was chosen
        $aWordfriend.initialvalues #creates new blank game board
        self.tilesplayer1 = '-------'
        self.tilesplayer2 = '-------'
        self.scoreplayer2 = 0
        self.scoreplayer1 = 0
    end
    
    def initializegameCheat
        self.currentplayer = 1
        $aGame.mode = "Cheat"
        $aGame.gameplayer2 = $aGame.gameuser
        $aGame.gameplayer1 = "none"
        self.currentplayertileset = self.tilesplayer2
        $aWordfriend.updatevalues(self.currentplayertileset)
        self.saveboard
    end
    
    def initializegamePvC
        self.tilesplayer1 = $aGame.filltiles(self.tilesplayer1)
        self.tilesplayer2 = $aGame.filltiles(self.tilesplayer2)
        $aGame.gameplayer2 = $aGame.gameuser
        $aGame.gameplayer1 = "ArcaneWord"
        $aGame.mode = "PlayerVsComputer"
        self.currentplayer = 0
        self.currentplayertileset = self.tilesplayer1
        $aWordfriend.updatevalues(self.currentplayertileset)
        self.saveboard
    end
    
    def revertPvC
        self.tilesremain = self.pushtilesremain.dup
        self.currentplayertileset = self.pushtilesplayer2.dup
        $aWordfriend.revertboard
    end
    
    def revertCheat
        self.tilesremain = self.pushtilesremain.dup
        self.currentplayertileset = self.pushtilesplayer2.dup
        $aWordfriend.revertboard
    end
    
    def nextmoveCheat
        self.tilesplayer2 = self.currentplayertileset
    end
    
    def resetnewindicator
        $aWordfriend.resetnewindicator
    end
    
    def firstmove
        #self.initializegame #sets currentpayer = gameplayer1 and fills both players' tile sets;
        self.currentplayertileset = self.tilesplayer1
        aSW = $aWordfriend.firstword
        until (aSW)
            self.tilesplayer1 = self.replacealltiles(self.tilesplayer1)  #in case initial tiles generated no possible words, replace and try again.
            aSW = $aWordfriend.firstword
        end
        self.placewordfromtiles(aSW)  #scoreandplacewordfromtiles(aSW, fromtiles)
        self.tilesplayer1 = self.currentplayertileset
        self.tilesplayer1 = $aGame.filltiles(self.tilesplayer1)
        self.scoreplayer1 = scoreplayer1 + aSW.score + aSW.supplement
        self.currentplayertileset = self.tilesplayer2
    end

    def readgame
        anarray = $aWordfriend.readboard  #this reads in the lettergrid and scoregrid and the following:
        self.tilesplayer1 = anarray[0]
        self.tilesplayer2 = anarray[1]
        self.tilesremain = anarray[2]
        self.mode = anarray[3]
        self.scoreplayer1 = anarray[4]
        self.scoreplayer2 = anarray[5]
        return anarray
    end
    
    def resumegamePvC
        self.currentplayer = 0
        self.currentplayertileset = self.tilesplayer1
        $aWordfriend.updatevalues(self.currentplayertileset)
        $aWordfriend.wordfind
        aSW = $aWordfriend.possiblewords[0] #get the highest scoring result
        if aSW
            self.placewordfromtiles(aSW)
            self.tilesplayer1 =  self.currentplayertileset
            self.scoreplayer1 = scoreplayer1 + aSW.score + aSW.supplement
            self.tilesplayer1 = self.filltiles(self.tilesplayer1)
        end
        self.currentplayertileset = self.tilesplayer2
    end

    def resumegameCheat
        self.currentplayer = 1
        self.currentplayertileset = self.tilesplayer2
        $aWordfriend.updatevalues(self.currentplayertileset) #findSWs, tilepermutedset, $possiblewords(words w tiles and board), $tilewords (words w tiles only)
    end

    
    def nextmovePlayer2
        self.currentplayertileset = self.tilesplayer2
        $aWordfriend.updatevalues(self.currentplayertileset)
        $aWordfriend.wordfind
    end
    
    def placewordfromtiles(aSW)
        self.currentplayertileset = $aWordfriend.placewordfromtiles(aSW, self.currentplayertileset) #hold the remaining tiles in currentplayertileset
        self.scoreadd = aSW.score + aSW.supplement
    end
    
    def placewordfromtiles2(aSW)
        self.pushtilesplayer2 = self.tilesplayer2.dup #in case of a revert
        self.pushtilesremain = self.tilesremain.dup
        self.currentplayertileset = $aWordfriend.placewordfromtiles(aSW, self.currentplayertileset) #hold the remaining tiles in currentplayertileset
        self.scoreadd = aSW.score + aSW.supplement
        #puts "aSW.supplement = #{aSW.supplement}"
    end
    
    def saveboard
        $aWordfriend.saveboard(self.tilesplayer1,self.tilesplayer2,self.tilesremain, self.mode, self.scoreplayer1.to_s, self.scoreplayer2.to_s)
    end
    
    def nextmovePlayer1
        self.saveboard #saves board after player2 accepts move
        self.tilesplayer2 = self.currentplayertileset  #the move just reviewed in '/updated' is now accepted, the remaining tiles in currentplayertileset transferred to  tilesplater2
        self.scoreplayer2 = self.scoreplayer2 + self.scoreadd
        self.tilesplayer2 = $aGame.filltiles(self.tilesplayer2) #player2 just moved and used some tiles
        self.resetnewindicator
        self.currentplayertileset = self.tilesplayer1
        $aWordfriend.updatevalues(self.currentplayertileset)
     end
    
     def finishnextmovePlayer1
        aSW = $aWordfriend.possiblewords[0] #get the highest scoring result
        if aSW
            self.placewordfromtiles(aSW)
            self.tilesplayer1 =  self.currentplayertileset
            self.scoreplayer1 = scoreplayer1 + aSW.score + aSW.supplement
            self.tilesplayer1 = self.filltiles(self.tilesplayer1)
        end
        self.currentplayertileset = self.tilesplayer2
        $aWordfriend.updatevalues(self.currentplayertileset)
    end

end

