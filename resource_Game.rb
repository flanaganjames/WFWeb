class Game
    attr_accessor :currentplayer, :currentplayertileset, :gameplayer1, :gameplayer2, :tilesall, :tilesremain, :tilesplayer1, :tilesplayer2, :scoreplayer1, :scoreplayer2
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
        
        self.tilesremain = self.tilesall
        self.scoreplayer1 = 0
        self.scoreplayer2 = 0
        self.tilesplayer1 = ''
        self.tilesplayer2 = ''
        $aWordfriend = Wordfriend.new
        $aWordfriend.initialvalues
    end
    
    def choosereplacementtile
        if self.tilesremain.size > 0
            atile = self.tilesremain[rand(tilesremain.size)]
            self.tilesremain -= [atile]
            return atile
        else
            return nil
        end
    end
    
    def filltiles(astr) #aplayerstiles may be self.tilesplayer1 or self.tilesplayer2
        atile = ''
        astr = astr.gsub('-','') #replace any '-' characters with '' blanks
        while atile && astr.size < 7  #stop if ever atile becomes nil
            atile = self.choosereplacementtile
            astr += atile if atile  #
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
    
    def initializegame
        self.currentplayer = 0
        self.tilesplayer1 = self.filltiles(self.tilesplayer1)
        self.tilesplayer2 = self.filltiles(self.tilesplayer2)
        $aWordfriend.saveboard(self.tilesplayer1, self.tilesplayer2, $aGame.tilesremain.join(''))
    end
    
    def revertPvC
        self.tilesremain = self.tilesremain + (self.tilesplayer2.scan('') - $aWordfriend.myboard.newtileword.scan(''))  #this adds the tiles used from newtileword back to tilesremain
    end
    
    def resetnewindicator
        $aWordfriend.resetnewindicator
    end
    
    def firstmove
        self.initializegame #sets currentpayer = gameplayer1 and fills both players' tile sets;
        self.currentplayertileset = self.tilesplayer1
        $aWordfriend.updatevalues(self.currentplayertileset) #findSWs, tilepermutedset, $possiblewords(words w tiles and board), $tilewords (words w tiles only)
        
        aSW = $aWordfriend.firstword
        until (aSW)
            self.tilesplayer1 = self.replacealltiles(self.tilesplayer1)  #in case initial tiles generated no possible words, replace and try again.
            aSW = $aWordfriend.firstword
        end
        self.tilesplayer1 = $aWordfriend.placewordfromtiles(aSW)
        self.tilesplayer1 = $aGame.filltiles($aGame.tilesplayer1)
        self.scoreplayer1 = scoreplayer1 + aSW.score + aSW.supplement
        self.currentplayertileset = self.tilesplayer2
    end
    
    def nextmovePlayer2
        self.currentplayertileset = self.tilesplayer2
        $aWordfriend.updatevalues(self.currentplayertileset)
        $aWordfriend.wordfind
    end
    
    def placewordfromtiles(aSW)
        self.currentplayertileset = $aWordfriend.placewordfromtiles(aSW) #hold the remaining tiles in currentplayertileset
    end
    
    def nextmovePlayer1
        self.tilesplayer2 = self.currentplayertileset  #the move just reviewed in '/updated' is now accepted, the remaining tiles in currentplayertileset transferred to  tilesplater2
        self.tilesplayer2 = $aGame.filltiles($aGame.tilesplayer2) #player2 just moved and used some tiles
        self.resetnewindicator
        self.currentplayertileset = self.tilesplayer1
        $aWordfriend.updatevalues(self.currentplayertileset)
        $aWordfriend.wordfind
        aSW = $aWordfriend.possiblewords[0] #get the highest scoring result
        $aWordfriend.myboard.placewordfromtiles(aSW) if aSW # put it on board if not nil
        self.scoreplayer1 = scoreplayer1 + aSW.score + aSW.supplement
        self.currentplayertileset = self.tilesplayer2
        $aWordfriend.updatevalues(self.currentplayertileset)
        $aWordfriend.saveboard($aGame.tilesplayer1,$aGame.tilesplayer2,$aGame.tilesremain.join(''))
    end

end

