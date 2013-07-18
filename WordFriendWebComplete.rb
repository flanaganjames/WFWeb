APP_DIR = File.expand_path File.dirname(__FILE__)
GEM_DIR = File.join(APP_DIR, 'vendor', 'gems')
PUBLIC_DIR = File.join(APP_DIR, 'public')

# Vendorize all gems in vendor directory.
Dir.entries(GEM_DIR).each do |dir|
    gem_lib = File.join GEM_DIR, dir, 'lib'
$LOAD_PATH << gem_lib if File.exist?(gem_lib)
end

require "rack"
require "sinatra/base"
require 'android'
require 'sinatra'

# if game exists then ask if resume
#if choose resume then start game in previously defined mode
#if choose new then post /newgame which will show askmode.erb

#if no game exists then show askmode.erb

#askmode will either select PvC and start a new game PvC
#or askmode will select PvP ans start a new game PvP



class WordFriend < Sinatra::Base
$droid = Android.new

get '/' do
    $droid.makeToast "starting aGame.new"
    $aGame = Game.new
    $droid.makeToast  "finished aGame.new, starting aGame.initialvalues"
    $aGame.initialvalues
    $aGame.gameuser = "auser"
    $aWordfriend.gameuser = $aGame.gameuser
    $aGame.newgame = "yes"
    $droid.makeToast "initialize game"
    $aGame.initializegame
    $droid.makeToast  "initializing PvC"
    $aGame.initializegamePvC
    $droid.makeToast "firstmove"
    $aGame.firstmove
    $droid.makeToast "now go to show"
end

get '/show' do
arcaneusergameboard_view
end


post '/manualmovePvC' do #posted from showArcanUsergameboard
    i=0
    @posname = {}
    while i < 15
        j = 0
        lhash = {}
        while j < 15
            lhash[j] = ":i" + i.to_s + "j" + j.to_s
            j += 1
        end
        @posname[i] = lhash
        i += 1
    end
    
    @tilename = {}
    i = 0
    while i < 7
        @tilename[i] = "tile" + i.to_s
        i += 1
    end
    
    
    @word = params["word"]
    @xcoordinate = params["xcoordinate"]
    @ycoordinate = params["ycoordinate"]
    @direction = params["direction"]

    aSW = ScrabbleWord.new(@word, @xcoordinate.to_i, @ycoordinate.to_i, @direction, 0, 0)
    $aWordfriend.updatevalues($aGame.tilesplayer2)
    status = $aWordfriend.manualwordtest(aSW) #this changes scoregrid if  a '*' to be used. Be sure to roll back if move not accepted
    #puts "status = #{status}"
    #puts "hello if true" if status
    #puts "hello if nil" if not(status)
    invalidmove_view if not(status)
    $aGame.placewordfromtiles2(aSW) if status
    updatedPVC_view if status
end


post '/resultsPvC' do  #posted from showArcanUsergameboard
    i=0
    @posname = {}
    while i < 15
        j = 0
        lhash = {}
        while j < 15
            lhash[j] = ":i" + i.to_s + "j" + j.to_s
            j += 1
        end
        @posname[i] = lhash
        i += 1
    end
    
    @tilename = {}
    i = 0
    while i < 7
        @tilename[i] = "tile" + i.to_s
        i += 1
    end
    
    $aGame.nextmovePlayer2
    
    resultsPVC_view
end



post '/updatedPvC' do  #posted from showresultsPvC after manual move
    i=0
    @posname = {}
    while i < 15
        j = 0
        lhash = {}
        while j < 15
            lhash[j] = ":i" + i.to_s + "j" + j.to_s
            j += 1
        end
        @posname[i] = lhash
        i += 1
    end
    
    @tilename = {}
    i = 0
    while i < 7
        @tilename[i] = "tile" + i.to_s
        i += 1
    end
    
    @choice = params["choice"]
    @word = params["word"+@choice.to_s]
    @xcoordinate = params["xcoordinate"+@choice.to_s]
    @ycoordinate = params["ycoordinate"+@choice.to_s]
    @direction = params["direction"+@choice.to_s]
    @score = params["score"+@choice.to_s]
    @supplement = params["supplement"+@choice.to_s]
    
    aSW = ScrabbleWord.new(@word, @xcoordinate.to_i, @ycoordinate.to_i, @direction, @score.to_i, @supplement.to_i)
    
    $aGame.placewordfromtiles2(aSW)
    
    updatedPVC_view
end

post '/updatedPvCFind' do  #posted from showresultsPvC after Find Moves
    i=0
    @posname = {}
    while i < 15
        j = 0
        lhash = {}
        while j < 15
            lhash[j] = ":i" + i.to_s + "j" + j.to_s
            j += 1
        end
        @posname[i] = lhash
        i += 1
    end
    
    @tilename = {}
    i = 0
    while i < 7
        @tilename[i] = "tile" + i.to_s
        i += 1
    end
    
    @choice = params["choice"]
    @word = params["word"+@choice.to_s]
    @xcoordinate = params["xcoordinate"+@choice.to_s]
    @ycoordinate = params["ycoordinate"+@choice.to_s]
    @direction = params["direction"+@choice.to_s]
    @score = params["score"+@choice.to_s]
    @supplement = params["supplement"+@choice.to_s]
    
    aSW = ScrabbleWord.new(@word, @xcoordinate.to_i, @ycoordinate.to_i, @direction, @score.to_i, @supplement.to_i)

    $aGame.placewordfromtiles2(aSW)
    
    updatedPVCFind_view
end



post '/revertPvC' do
    i=0
    @posname = {}
    while i < 15
        j = 0
        lhash = {}
        while j < 15
            lhash[j] = ":i" + i.to_s + "j" + j.to_s
            j += 1
        end
        @posname[i] = lhash
        i += 1
    end
    
    @tilename = {}
    i = 0
    while i < 7
        @tilename[i] = "tile" + i.to_s
        i += 1
    end

    $aGame.revertPvC
    
    arcaneusergameboard_view
end

post '/revertPvCFind' do
    i=0
    @posname = {}
    while i < 15
        j = 0
        lhash = {}
        while j < 15
            lhash[j] = ":i" + i.to_s + "j" + j.to_s
            j += 1
        end
        @posname[i] = lhash
        i += 1
    end
    
    @tilename = {}
    i = 0
    while i < 7
        @tilename[i] = "tile" + i.to_s
        i += 1
    end

    $aGame.revertPvC
    
    resultsPVC_view
end

post '/nextmovePlayer1' do   #posted from showupdatePvC
    i=0
    @posname = {}
    while i < 15
        j = 0
        lhash = {}
        while j < 15
            lhash[j] = ":i" + i.to_s + "j" + j.to_s
            j += 1
        end
        @posname[i] = lhash
        i += 1
    end
    $aGame.nextmovePlayer1

    arcaneusergameboard_view
end


#start of Cheat________________________________________________________________

get '/board' do
"Direct access to the \"/board\" URL has been deprecated. Try going to the root (\"http://dry-brushlands-6613.herokuapp.com/\")"
end

post '/startgameCheat' do  #this from showaskmode.erb if Cheat is chosen and assumes the gameuser is identfied and aassumes a new game
    i= 0
    @posname = {}
    while i < 15
        j = 0
        lhash = {}
        while j < 15
            lhash[j] = ":i" + i.to_s + "j" + j.to_s
            j += 1
        end
        @posname[i] = lhash
        i += 1
    end
    
    @tilename = {}
    i = 0
    while i < 7
        @tilename[i] = "tile" + i.to_s
        i += 1
    end
    if $aGame.newgame = "yes"
    $aGame.initializegameCheat
    end
    cheatgameboard_view
end



post '/results' do
    i=0
    @posname = {}
    while i < 15
        j = 0
        lhash = {}
        while j < 15
            lhash[j] = ":i" + i.to_s + "j" + j.to_s
            j += 1
        end
        @posname[i] = lhash.dup
        i += 1
    end
    
    @tilename = {}
    i = 0
    while i < 7
        @tilename[i] = "tile" + i.to_s
        i += 1
    end
    
    i = 0
    while i < 15
        j = 0
        rowletters = ""
        while j < 15
            rowletters = rowletters + params[@posname[i][j]]
            $aWordfriend.myboard.lettergrid[i][j] = params[@posname[i][j]] if 'abcdefghijklmnopqrstuvwxyz'.to_chars().include?(params[@posname[i][j]])
            j += 1
        end
        i += 1
    end
    #puts "captured lettergrid"
    #puts $aWordfriend.myboard.lettergrid
    anarray = []
    i = 0
    while i < 7
        anarray[i] = params[@tilename[i]]
        i += 1
    end
    $aGame.tilesplayer2 = anarray.join('')
    $aGame.currentplayertileset = $aGame.tilesplayer2
    #puts "tileset captured: #{$aGame.currentplayertileset }"
    $aGame.saveboard
    $aWordfriend.updatevalues($aGame.tilesplayer2)
    $aWordfriend.wordfind
    
    results_view
end



post '/updated' do
    i=0
    @posname = {}
    while i < 15
        j = 0
        lhash = {}
        while j < 15
            lhash[j] = ":i" + i.to_s + "j" + j.to_s
            j += 1
        end
        @posname[i] = lhash
        i += 1
    end
    
    @tilename = {}
    i = 0
    while i < 7
        @tilename[i] = "tile" + i.to_s
        i += 1
    end
    
    @choice = params["choice"]
    @word = params["word"+@choice.to_s]
    @xcoordinate = params["xcoordinate"+@choice.to_s]
    @ycoordinate = params["ycoordinate"+@choice.to_s]
    @direction = params["direction"+@choice.to_s]
    @score = params["score"+@choice.to_s]
    @supplement = params["supplement"+@choice.to_s]
    
    aSW = ScrabbleWord.new(@word, @xcoordinate.to_i, @ycoordinate.to_i, @direction, @score.to_i, @supplement.to_i)

    $aGame.placewordfromtiles2(aSW)

    updated_view
end

post '/revert' do
    i=0
    @posname = {}
    while i < 15
        j = 0
        lhash = {}
        while j < 15
            lhash[j] = ":i" + i.to_s + "j" + j.to_s
            j += 1
        end
        @posname[i] = lhash
        i += 1
    end
    
    @tilename = {}
    i = 0
    while i < 7
        @tilename[i] = "tile" + i.to_s
        i += 1
    end
    
    $aGame.revertCheat
    
    results_view
end

post '/nextmove' do   #posted from showupdated
    i=0
    @posname = {}
    while i < 15
        j = 0
        lhash = {}
        while j < 15
            lhash[j] = ":i" + i.to_s + "j" + j.to_s
            j += 1
        end
        @posname[i] = lhash
        i += 1
    end
    @tilename = {}
    i = 0
    while i < 7
        @tilename[i] = "tile" + i.to_s
        i += 1
    end
    
    Cheatgameboard_view
end

post '/saveboard' do
    i=0
    @posname = {}
    while i < 15
        j = 0
        lhash = {}
        while j < 15
            lhash[j] = ":i" + i.to_s + "j" + j.to_s
            j += 1
        end
        @posname[i] = lhash
        i += 1
    end
    
    @tilename = {}
    i = 0
    while i < 7
        @tilename[i] = "tile" + i.to_s
        i += 1
    end
    
    i = 0
    while i < 15
        j = 0
        rowletters = ""
        while j < 15
            rowletters = rowletters + params[@posname[i][j]]
            $aWordfriend.myboard.lettergrid[i][j] = params[@posname[i][j]]
            j += 1
        end
        i += 1
    end
    
    i=0
    anarray = []
    while i < 7
        anarray.push(params[@tilename[i]])
        i += 1
    end
    $aWordfriend.myboard.tileword = anarray.join('')
    
    $aWordfriend.saveboard($aGame.tilesplayer1,$aGame.tilesplayer2,$aGame.tilesremain.join(''))  #need to fix this
    
    $aWordfriend.updatevalues  #need to fix this
    
    arcaneusergameboard_view
end
end
#############################
class Game
    attr_accessor :currentplayer, :currentplayertileset, :scoreadd, :gameplayer1, :gameplayer2, :tilesall, :tilesremain, :pushtilesremain, :tilesplayer1, :tilesplayer2, :pushtilesplayer2, :scoreplayer1, :scoreplayer2, :gameuser, :gamefile, :newgame, :mode
    #tilesplayer1/2 is each a single string of the concatenated tiles

    
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
        self.tilesall += ['*']*0
        $droid.makeToast  "assigned letter quantities"
        self.tilesremain = self.tilesall.join('')
        self.scoreplayer1 = 0
        self.scoreplayer2 = 0
        self.scoreadd = 0
        self.tilesplayer1 = ''
        self.tilesplayer2 = ''
        $droid.makeToast  "starting Wordfriend.new"
        $aWordfriend = Wordfriend.new
        $droid.makeToast  "finished Wordfriend.new, starting Wordfriend.initial values"
        $aWordfriend.initialvalues
        $droid.makeToast  "finished Wordfriend.initial values"
        $allowedcharacters = 'abcdefghijklmnopqrstuvwxyz'
        $maxallowed = 10
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
        #cannot do the following until mode is set
        #$aWordfriend.saveboard(self.tilesplayer1, self.tilesplayer2, $aGame.tilesremain, self.mode, self.scoreplayer1.to_s, self.scoreplayer2.to_s)
    end
    
    def initializegameCheat
        self.currentplayer = 1
        $aGame.mode = "Cheat"
        $aGame.gameplayer2 = $aGame.gameuser
        $aGame.gameplayer1 = "none"
        self.currentplayertileset = self.tilesplayer2
        $aWordfriend.updatevalues(self.currentplayertileset)
        $aWordfriend.saveboard(self.tilesplayer1, self.tilesplayer2, self.tilesremain, self.mode, self.scoreplayer1.to_s, self.scoreplayer2.to_s )
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
        $aWordfriend.saveboard(self.tilesplayer1, self.tilesplayer2, self.tilesremain, self.mode, self.scoreplayer1.to_s, self.scoreplayer2.to_s)
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
        $aWordfriend.saveboard(self.tilesplayer1,self.tilesplayer2,self.tilesremain, self.mode, self.scoreplayer1.to_s, self.scoreplayer2.to_s) #saves board after player2 accepts move
        self.tilesplayer2 = self.currentplayertileset  #the move just reviewed in '/updated' is now accepted, the remaining tiles in currentplayertileset transferred to  tilesplater2
        self.scoreplayer2 = self.scoreplayer2 + self.scoreadd
        self.tilesplayer2 = $aGame.filltiles(self.tilesplayer2) #player2 just moved and used some tiles
        self.resetnewindicator
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
        $aWordfriend.updatevalues(self.currentplayertileset)
        $aWordfriend.saveboard(self.tilesplayer1, self.tilesplayer2, $aGame.tilesremain, self.mode, self.scoreplayer1.to_s, self.scoreplayer2.to_s) #saves board after player 1 moves
    end

end
##########################

class Wordfriend
	attr_accessor :myboard, :gameuser, :gamefile, :usergames, :newgame, :possiblewords
    #these instance variables view the current user (user whose turn it is currently)
    #the board is the same, though out of phase as each turn occurs, and the tiles are different
    #see Class Game which supports two users - usually a user versus the computer
    #as each user takes his turn, the instance variables of this class are switched

	def initialvalues
        $droid.makeToast  "starting Scarbbleboard.new"
        self.myboard = ScrabbleBoard.new
        $droid.makeToast "finished Scrabbleboard.new, starting intial values"
		self.myboard.initialvalues
        $droid.makeToast "finished Scrabbleboard.initialvalues"
        $words = {}
        wordarray = File.readlines("wordlist.txt").map { |line| line.chomp }
        i = 0
        while i < wordarray.size
            $words[wordarray[i]] = 'true'
            i += 1
        end
        
        $words_plus = {}
		wordarray = File.readlines("wordlist.txt").map { |line| line.chomp }
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
        self.possiblewords = self.myboard.findhotspotSWs
	end
    
end
###############

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
        $droid.makeToast "board starting to create arrays"
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
        $droid.makeToast  "finished creating arrays"
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
        setSWs = []
        #puts "hotspots: #{self.hotspots.size}"
        self.hotspots.each {|hs|
            
            (setSWs = setSWs + wordsonblank(hs,"right")) if isblankright(hs)
            
            (setSWs = setSWs + wordsonblank(hs,"down")) if isblankdown(hs)
            
            (setSWs = setSWs + stringsplusright(hs)) if hs["rightdist"] == 1

            (setSWs = setSWs + stringsplusdown(hs)) if hs["downdist"] == 1
            
            (setSWs = setSWs + stringsplusleft(hs)) if hs["leftdist"] == 1
            
            (setSWs = setSWs + stringsplusup(hs)) if hs["updist"] == 1
            
            if hs["rightdist"]
                if hs["rightdist"] > 1
                    (setSWs = setSWs + wordsonblanksize(hs,"right", hs["rightdist"] - 1))
                end
            end
            
            if hs["downdist"]
                if hs["downdist"] > 1
                    (setSWs = setSWs + wordsonblanksize(hs, "down", hs["downdist"] - 1))
                end
            end
        }
        self.hotspotSWs = setSWs.sort_by {|possible| [-(possible.score + possible.supplement)]}

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
		$droid.makeToast  "start reading scores"
#        rows = File.readlines(afilename).map { |line| line.chomp } #this is an array of the board rows each as a string
        rows = []
        rows[0] = '---W--L-L--W---'
        rows[1] = '--l--w---w--l--'
        rows[2] = '-l--l-----l--l-'
        rows[3] = 'W--L---w---L--W'
        rows[4] = '--l---l-l---l--'
        rows[5] = '-w---L---L---w-'
        rows[6] = 'L---l-----l---L'
        rows[7] = '---w-------w---'
        rows[8] = 'L---l-----l---L'
        rows[9] = '-w---L---L---w-'
        rows[10] = '--l---l-l---l--'
        rows[11] = 'W--L---w---L--W'
        rows[12] = '-l--l-----l--l-'
        rows[13] = '--l--w---w--l--'
        rows[14] = '---W--L-L--W---'
        $droid.makeToast  "finished reading scores"
        rows.each_index {|i|
        rowletters = rows[i].to_chars # this is an array of characters for one of the rows
        rowletters.each_index {|j|
        self.scoregrid[i][j] = rowletters[j]
        }
		}
        $droid.makeToast  "setting score grid"
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
    
    if  status && permanent
        aSW.score = ascore * anarray.max
        #puts "aSW.score #{aSW.score}"
        return self.newtileword
        self.boardchanged = true
    elsif status
        aSW.score = ascore * anarray.max
        #puts "aSW.score #{aSW.score}"
        self.popgrids
        return self.newtileword
    else 
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

########################
class ScrabbleWord
	attr_accessor :astring, :xcoordinate, :ycoordinate, :direction, :score, :supplement, :suppwords
	
	def initialize (astring, xcoordinate, ycoordinate, direction, score, supplement)
		@astring = astring
		@xcoordinate = xcoordinate
		@ycoordinate = ycoordinate
		@direction = direction
		@score = score
		@supplement = supplement
        @suppwords = {self.createkey => 'true'} #this hash will hold words created by placing a word o the board; key will be astring-xc-yc-dirx
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

    def createkey
        return self.astring + self.xcoordinate.to_s + self.ycoordinate.to_s + self.direction
    end

end
###################

class Array
	def uniqSWs
	newarray = []
	while self.size > 0
		aSW = self.pop
		duplicate = false
		newarray.each {|bSW| duplicate = true if aSW.astring == bSW.astring && aSW.xcoordinate == bSW.xcoordinate && aSW.ycoordinate == bSW.ycoordinate}
		newarray.push(aSW) if duplicate == false
	end
	return newarray
	end
    
    def maxallowedSWs
    newarray =[]
        while self.size > 0
            aSW = self.pop
            if newarray.size < $maxallowed
                newarray << aSW
                newarray = newarray.sort_by {|possible| [(possible.score + possible.supplement)]}
            else
                newarray[0] = aSW if (aSW.score + aSW.supplement) > (newarray[0].score + newarray[0].supplement)
                newarray = newarray.sort_by {|possible| [(possible.score + possible.supplement)]}
            end
        end
    return newarray
    end
    
end

class String
  def to_chars
    self.scan(/./)
  end
end

#class String  #deprecated
#	def findtilewords  #from all words select those that can be made using existing tiles as a string only (all other word options are found by anchoring to existing boardSWs)
#	tileset = self.to_chars #tileset is a string composed of the tiles; tiles is an array of characters from this string
#	tilepower = tileset.powerset # tilepower is a powerset, ie all possible sets that can be made form the array of characters
#	tilewords = tilepower.collect{|anarray| anarray.join('')}.select{|element| element.isaword} # tilewords are  the strings corresponding to those subsets that are words inthe dictionary
#	end
#end


class String
    def writewordfile
        afile = File.open("wordlist_plus_new.txt", "w")
        $words.each_key {|aword|
            afile.puts(aword)
            wordarr = aword.scan(/./)
            i = 0
            while i < aword.size
                subword = []
                wordarr.each {|achar| subword << achar}
                subword[i] = '*'
                afile.puts(subword.join(''))
                i += 1
            end
            }
        afile.close
    end
end

class String
	def permutedset #returns a set of strings representing every permutation of every subset of characters
	arr = self.to_chars
	set = []
	i = 1
	while i < arr.size + 1
		set = set + arr.permutation(i).to_a
		i += 1
	end
	set.collect {|aset| aset.join('')}
	end
    
    def permutedsetofsize(size)  #returns a set of strings representing every permutation of size "size"
        arr = self.to_chars
        set = arr.permutation(size).to_a
        set.collect {|aset| aset.join('')}
    end
end

class Array
    def actualwords
        set = []
        alpha = 'abcdefghijklmnopqrstuvwxyz'.to_chars #creates array of alphabetic letters
        self.each {|astarword|
                        alpha.each {|aletter|
                                subword = astarword.sub('*',aletter)
                                set << subword if subword.isaword
                                }
                    }
        return set
    end
end

class String
    def permutedset_expandstar #returns a set of strings representing every permutation of every subset of characters; if a * is present, it is replaced with allowed characters
        arr = self.to_chars
        set = []
        expandedset = []
        i = 1
        while i < arr.size + 1
            set = set + arr.permutation(i).to_a
            i += 1
        end
        set.each {|apermutationset|
            expandedset = expandedset + apermutationset.join('').startoallowedcharacters #expands * to every possible allowed character
        }
        return expandedset
    end
end

class String
    def startoallowedcharacters
        set = [ self ] #at minimum retun self
        if self.include?('*')
            alpha = $allowedcharacters.to_chars #creates array of alphabetic letters
            alpha.each {|aletter|
                subword = self.sub('*',aletter)
                set << subword
            }
        end
        return set
    end
end

class String
	def permutaround(imbeddedstring) #returns a set of strings representing additions of self to beginning and end of astring
		possibles = []
		fullset = self.to_chars
		permutedfull = self.permutedset
		permutedfull.each do |prestring|
			remainder = fullset - prestring.to_chars #the chracters that remain
			permutedremainder = remainder.join('').permutedset
			permutedremainder.each do |poststring|
				possibles.push(prestring + imbeddedstring + poststring)
			end		
		end
		return possibles
	end
end

class String
def wordsendingwith(added)
	words_match = []
	case 
		when added < 0 
			$words.each_value {|word| words_match << word if word =~ /\A..*#{self}\Z/}
		when added == 1 
			$words.each_value {|word| words_match << word if word =~ /\A.#{self}\Z/}
		when added == 2
			$words.each_value {|word| words_match << word if word =~ /\A..#{self}\Z/}
		when added == 3
			$words.each_value {|word| words_match << word if word =~ /\A...#{self}\Z/}
		when added == 4
			$words.each_value {|word| words_match << word if word =~ /\A....#{self}\Z/}
		when added == 5
			$words.each_value {|word| words_match << word if word =~ /\A.....#{self}\Z/}
		when added == 0 
			$words.each_value {|word| words_match << word if word =~ /\A#{self}\Z/}
		end	
return words_match
end
end

class String
def wordsbeginningwith(added)
	words_match = []
	case 
		when added < 0 
			$words.each_key {|word| words_match << word if word =~ /\A#{self}..*\Z/}
		when added == 1 
			$words.each_key {|word| words_match << word if word =~ /\A#{self}.\Z/}		
		when added == 2 
			$words.each_key {|word| words_match << word if word =~ /\A#{self}..\Z/}
		when added == 3 
			$words.each_key {|word| words_match << word if word =~ /\A#{self}...\Z/}
		when added == 4 
			$words.each_key {|word| words_match << word if word =~ /\A#{self}....\Z/}
		when added == 5 
			$words.each_key {|word| words_match << word if word =~ /\A#{self}.....\Z/}
		when added == 0 
			$words.each_key {|word| words_match << word if word =~ /\A#{self}\Z/}
		end
return words_match
end
end

class String
def iswithinwords
#	words_match = []
#	$words.each_key {|word| words_match << word if word =~ /\A..*#{self}..*\Z/}
#	return words_match
	words_match = $words.select{|word, value| word =~ /\A..*#{self}..*\Z/ }.keys
end
end

class String
def iscontainedwords
	words_match = []
	$words.each_key {|word| words_match << word if word =~ /\A.*#{self}.*\Z/}
	return words_match
end
end

class String
    def isaword
        $words.has_key?(self)
    end
    
    def isaword_plus  #this looks in the hash of words with every possible possible position substituted with a '*'
        return $words_plus[ self ] #returns an array of words consistent with a string that may have a star in it
    end
end

class String
    def matchingwordsexist  #receives a string with imbedded ., returns true if there is a matching word
        !!$words.keys.detect{ |k| k  =~ /\A#{self}\Z/ }
    end
end

class Array
	def powerset
		num = 2**size
		ps = Array.new(num, [])
		self.each_index do |i|
			a = 2**i
			b = 2**(i+1) - 1
			j = 0
			while j < num-1
				for j in j+a..j+b
				ps[j] += [self[i]]
				end
				j += 1
			end
		end
	ps
	end
end

class Array
  def >(other_set)
    (other_set - self).empty?
  end
end

class Array
	def subset?(other)
	    self.each do |x|
	     if !(other.include? x)
	      return false
	     end
	    end
	    true
	end
	def superset?(other)
	    other.subset?(self)
	end
end
###########################


def welcome_view
    aForm = " <form method=\"post\"> "
    aForm = aForm + "<head> <title>Welcome</title> </head> <body>"
    aForm = aForm + " <div> Welcome to The Arcane Word </div> "
    
    
    aForm = aForm + " <div> <table> "
    aForm = aForm + "<th>User Name</th> <th>PIN </th>"
    aForm = aForm + "<tr>"
    
    
    aForm = aForm + "<td> <input type = \"text\" name = \"ausername\" value =\"\" size = \"20\"</td>"
    aForm = aForm + "<td> <input type = \"text\" name = \"pin1\" value =\"\" size = \"2\"</td>"
    aForm = aForm + "<td> <input type = \"text\" name = \"pin2\" value =\"\" size = \"2\"</td>"
    aForm = aForm + "<td> <input type = \"text\" name = \"pin3\" value =\"\" size = \"2\"</td>"
    aForm = aForm + "<td> <input type = \"text\" name = \"pin4\" value =\"\" size = \"2\"</td>"
    aForm = aForm  + "<td> <input type = \"submit\" name=\"Open\" value = \"Open\" formaction = \"/usergame\"/> </td> "
    
    aForm = aForm + "</table></div>"
    
    aForm = aForm + "</body> </form> "
    
    aForm = aForm + "</html>"
    
    return aForm

end


def warning_view
aForm =  " <form method=\"post\"> "
aForm = aForm + "<head> <title>Warning</title> </head> <body>"
aForm = aForm + " <div> Invalid PIN </div> "


aForm = aForm + " <div> <table> "
aForm = aForm + "<th>User Name</th> <th>PIN </th>"
aForm = aForm + "<tr>"
aForm = aForm + "<td> <input type = \"text\" name = \"ausername\" value =\"\" size = \"20\"</td>"
aForm = aForm + "<td> <input type = \"text\" name = \"pin1\" value =\"\" size = \"2\"</td>"
aForm = aForm + "<td> <input type = \"text\" name = \"pin2\" value =\"\" size = \"2\"</td>"
aForm = aForm + "<td> <input type = \"text\" name = \"pin3\" value =\"\" size = \"2\"</td>"
aForm = aForm + "<td> <input type = \"text\" name = \"pin4\" value =\"\" size = \"2\"</td>"
aForm = aForm  + "<td> <input type = \"submit\" name=\"Open\" value = \"Open\" formaction = \"/usergame\"/> </td> "

aForm = aForm + "</table></div>"

aForm = aForm + "</body> </form> "

aForm = aForm + "</html>"

return aForm
end

def updatedPVCFind_view
    #puts "hello from showupdatedPvC"
aForm =  " <form method=\"post\"> "
aForm = aForm +  "<head> <style> .jander2 {font-weight: bold;} </style> <title>Updated Board</title> </head> <body> "

aForm = aForm + " <div> <table> <tr>"
aForm = aForm + "<td> Scores: </td> "
aForm = aForm + "<td> Computer  </td>"
aForm = aForm + "<td bgcolor=#0000FF > <font color=\"white\"> #{$aGame.scoreplayer1} </font> </td>"
aForm = aForm + "<td> vs.  </td>"
aForm = aForm + "<td> Player  </td>"
aForm = aForm + "<td bgcolor=#00FF00>  #{$aGame.scoreplayer2 + $aGame.scoreadd} </td>"
aForm = aForm + "<td> if Move Accepted </td>"
aForm = aForm + "</tr></table> </div/"

aForm = aForm +  " <div> <table> <tr> <td> Tiles If Move Accepted </td>"
i = 0
while i < 7
    aForm = aForm + "<td> <input type = \"text\" disabled=\"disabled\" size =\"1\" name =\"tile#{i}\" value =\"#{$aGame.currentplayertileset[i]}\" </td> "
    i += 1
end
aForm = aForm  + "<td> <input type = \"submit\" value = \"Undo\" formaction = \"/revertPvCFind\"/> </td>"
aForm = aForm  + "<td> <input type = \"submit\" value = \"Accept Move\" formaction = \"/nextmovePlayer1\"/> </td> "

aForm = aForm +  " </tr> </table> </div>"

aForm = aForm + " <div>Board if Move Accepted<table> "

aForm = aForm + "<tr> <td> ... </td> "
i = 0
while i < 15
    aForm = aForm + "<td>#{i}</td>"
    i += 1
end
aForm = aForm + "</tr> "

i = 0
while i < 15
    aForm = aForm + "<tr>"
    aForm = aForm + "<td>#{i}</td>"
    j = 0
    while j < 15
        aForm = aForm + "<td"
        aForm = aForm + " bgcolor=#00FF00" if ($aWordfriend.myboard.newgrid[i][j] == 'n')
        aForm = aForm + " bgcolor=#000000" if ($aWordfriend.myboard.lettergrid[i][j] != '-')
        aForm = aForm + ">"
        aForm = aForm + "<input type = \"text\" class=\"jander2\" disabled=\"disabled\" "
        
        if $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'W'
            aForm = aForm + " placeholder =\"tw\""
            elsif $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'w'
            aForm = aForm + " placeholder =\"dw\""
            elsif $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'L'
            aForm = aForm + " placeholder =\"tl\""
            elsif $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'l'
            aForm = aForm + " placeholder =\"dl\""
            else aForm = aForm + " value =\"#{$aWordfriend.myboard.lettergrid[i][j]}\""
        end
        
        aForm = aForm + " size =\"1\" name =\"#{@posname[i][j]}\""
        j += 1
        aForm = aForm + " </td>"
    end
	aForm = aForm + "</tr>"
    i += 1
end
aForm = aForm + "</table></div>"

aForm = aForm + "</body> </form> </html>"

return aForm
end


def updatedPVC_view
aForm =  " <form method=\"post\"> "
aForm = aForm +  "<head> <style> .jander2 {font-weight: bold;} </style> <title>Updated Board</title> </head> <body> "
aForm = aForm + " <div> <table> <tr>"
aForm = aForm + "<td> Scores: </td> "
aForm = aForm + "<td> Computer  </td>"
aForm = aForm + "<td bgcolor=#0000FF > <font color=\"white\"> #{$aGame.scoreplayer1} </font> </td>"
aForm = aForm + "<td> vs.  </td>"
aForm = aForm + "<td> Player  </td>"
aForm = aForm + "<td bgcolor=#00FF00>  #{$aGame.scoreplayer2 + $aGame.scoreadd} </td>"
aForm = aForm + "<td> if Move Accepted </td>"
aForm = aForm + "</tr></table> </div/"

aForm = aForm +  " <div> <table> <tr> <td> Tiles If Move Accepted </td>"
i = 0
while i < 7
    aForm = aForm + "<td> <input type = \"text\" disabled=\"disabled\" size =\"1\" name =\"tile#{i}\" value =\"#{$aGame.currentplayertileset[i]}\" </td> "
    i += 1
end
aForm = aForm  + "<td> <input type = \"submit\" value = \"Undo\" formaction = \"/revertPvC\"/> </td>"
aForm = aForm  + "<td> <input type = \"submit\" value = \"Accept Move\" formaction = \"/nextmovePlayer1\"/> </td> "

aForm = aForm +  " </tr> </table> </div>"

aForm = aForm + " <div>Board if Move Accepted<table> "

aForm = aForm + "<tr> <td> ... </td> "

i = 0
while i < 15
    aForm = aForm + "<td>#{i}</td>"
    i += 1
end
aForm = aForm + "</tr> "

i = 0
while i < 15
    aForm = aForm + "<tr>"
    aForm = aForm + "<td>#{i}</td>"
    j = 0
    while j < 15
        aForm = aForm + "<td"
        aForm = aForm + " bgcolor=#00FF00" if ($aWordfriend.myboard.newgrid[i][j] == 'n')
        aForm = aForm + " bgcolor=#000000" if ($aWordfriend.myboard.lettergrid[i][j] != '-')
        aForm = aForm + ">"
        aForm = aForm + "<input type = \"text\" class=\"jander2\" disabled=\"disabled\" "
        
        if $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'W'
            aForm = aForm + " placeholder =\"tw\""
            elsif $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'w'
            aForm = aForm + " placeholder =\"dw\""
            elsif $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'L'
            aForm = aForm + " placeholder =\"tl\""
            elsif $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'l'
            aForm = aForm + " placeholder =\"dl\""
            else aForm = aForm + " value =\"#{$aWordfriend.myboard.lettergrid[i][j]}\""
        end
        
        aForm = aForm + " size =\"1\" name =\"#{@posname[i][j]}\""
        j += 1
        aForm = aForm + " </td>"
    end
	aForm = aForm + "</tr>"
    i += 1
end

aForm = aForm + "</table></div>"
aForm = aForm + "</body> </form> </html>"

return aForm
end

def updated_view
aForm =  " <form method=\"post\"> "
aForm = aForm + "<head> <title>Updated Board</title> </head> <body> <div> <table> "
aForm = aForm + "<th>Choice: #{@choice}, </th> <th>Score: #{@score}, </th> <th>Word: <i>#{@word}</i>, </th> <th>Row: #{@xcoordinate}, </th> <th>Col: #{@ycoordinate}, </th> <th>Direction: #{@direction}</th>"
aForm = aForm + "</table></div>"

aForm = aForm +  " <div> <table> <tr> <td> Tiles If Move Accepted </td>"
i = 0
while i < 7
    aForm = aForm + "<td> <input type = \"text\" disabled=\"disabled\" size =\"1\" name =\"tile#{i}\" value =\"#{$aGame.currentplayertileset[i]}\" </td> "
    i += 1
end
aForm = aForm  + "<td> <input type = \"submit\" value = \"Undo\" formaction = \"/revert\"/> </td>"
aForm = aForm  + "<td> <input type = \"submit\" value = \"Accept Move\" formaction = \"/nextmove\"/> </td> "

aForm = aForm +  " </tr> </table> </div>"

aForm = aForm + " <div>Board if Move Accepted<table> "

aForm = aForm + "<tr> <td> ... </td> "
i = 0
while i < 15
    aForm = aForm + "<td>#{i}</td>"
    i += 1
end
aForm = aForm + "</tr> "

i = 0
while i < 15
    aForm = aForm + "<tr>"
    aForm = aForm + "<td>#{i}</td>"
    j = 0
    while j < 15
        aForm = aForm + "<td"
        aForm = aForm + " bgcolor=#00FF00" if ($aWordfriend.myboard.newgrid[i][j] == 'n')
        aForm = aForm + " bgcolor=#000000" if ($aWordfriend.myboard.lettergrid[i][j] != '-')
        aForm = aForm + ">"
        aForm = aForm + "<input type = \"text\" class=\"jander2\" disabled=\"disabled\" "
        
        if $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'W'
            aForm = aForm + " placeholder =\"tw\""
            elsif $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'w'
            aForm = aForm + " placeholder =\"dw\""
            elsif $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'L'
            aForm = aForm + " placeholder =\"tl\""
            elsif $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'l'
            aForm = aForm + " placeholder =\"dl\""
            else aForm = aForm + " value =\"#{$aWordfriend.myboard.lettergrid[i][j]}\""
        end
        
        aForm = aForm + " size =\"1\" name =\"#{@posname[i][j]}\""
        j += 1
        aForm = aForm + " </td>"
    end
	aForm = aForm + "</tr>"
    i += 1
end
aForm = aForm + "</table></div>"

aForm = aForm + "</body> </form> </html>"

return aForm
end

def resultsPVC_view
aForm =  " <form method=\"post\"> "
aForm = aForm +  "<head> <title>Results</title> </head> <body> <div> <table> "
aForm = aForm + "<th>Total</th> <th>Direct</th> <th>Supplement</th> <th>Word</th> <th>Row</th> <th>Col</th> <th>Drx</th> <th>Choose</th>"
$aWordfriend.possiblewords.take(100).each_index {|i| aSW = $aWordfriend.possiblewords[i]
    aForm = aForm + "<tr>"
    aForm = aForm + "<td> <input type = \"text\" name = \"scoretotal#{i}\" value =\"#{aSW.score + aSW.supplement}\" size = \"4\"</td>"
    aForm = aForm + "<td> <input type = \"text\" name = \"score#{i}\" value =\"#{aSW.score}\" size = \"4\"</td>"
    aForm = aForm + "<td> <input type = \"text\" name = \"supplement#{i}\" value =\"#{aSW.supplement}\" size = \"4\"</td>"
    aForm = aForm + "<td> <input type = \"text\" name = \"word#{i}\" value =\"#{aSW.astring}\" </td>"
    aForm = aForm + "<td> <input type = \"text\" name = \"xcoordinate#{i}\" value =\"#{aSW.xcoordinate}\" size = \"2\"</td>"
    aForm = aForm + "<td> <input type = \"text\" name = \"ycoordinate#{i}\" value =\"#{aSW.ycoordinate}\" size = \"2\"</td>"
    aForm = aForm + "<td> <input type = \"text\" name = \"direction#{i}\" value =\"#{aSW.direction}\" size = \"4\"</td>"
    aForm = aForm  + "<td> <input type = \"submit\" name=\"choice\" value = \"#{i}\" formaction = \"/updatedPvCFind\"/> </td> "
}
aForm = aForm + "</table></div>"


aForm = aForm + "</body> </form> </html>"

return aForm
end

def results_view
aForm =  " <form method=\"post\"> "
aForm = aForm +  "<head> <title>Results</title> </head> <body> <div> <table> "
aForm = aForm + "<th>Total</th> <th>Direct</th> <th>Supplement</th> <th>Word</th> <th>Row</th> <th>Col</th> <th>Drx</th> <th>Choose</th>"
$aWordfriend.possiblewords.each_index {|i| aSW = $aWordfriend.possiblewords[i]
    aForm = aForm + "<tr>"
    aForm = aForm + "<td> <input type = \"text\" name = \"scoretotal#{i}\" value =\"#{aSW.score + aSW.supplement}\" size = \"4\"</td>"
    aForm = aForm + "<td> <input type = \"text\" name = \"score#{i}\" value =\"#{aSW.score}\" size = \"4\"</td>"
    aForm = aForm + "<td> <input type = \"text\" name = \"supplement#{i}\" value =\"#{aSW.supplement}\" size = \"4\"</td>"
    aForm = aForm + "<td> <input type = \"text\" name = \"word#{i}\" value =\"#{aSW.astring}\" </td>"
    aForm = aForm + "<td> <input type = \"text\" name = \"xcoordinate#{i}\" value =\"#{aSW.xcoordinate}\" size = \"2\"</td>"
    aForm = aForm + "<td> <input type = \"text\" name = \"ycoordinate#{i}\" value =\"#{aSW.ycoordinate}\" size = \"2\"</td>"
    aForm = aForm + "<td> <input type = \"text\" name = \"direction#{i}\" value =\"#{aSW.direction}\" size = \"4\"</td>"
    aForm = aForm  + "<td> <input type = \"submit\" name=\"choice\" value = \"#{i}\" formaction = \"/updated\"/> </td> "
}
aForm = aForm + "</table></div>"


aForm = aForm + "</body> </form> </html>"

return aForm
end

def invalidmove_view
aForm =  " <form method=\"post\"> "
aForm = aForm +  "<head> <style> .jander2 {font-weight: bold;} </style> <title>Unchanged Board</title> </head> <body> "
aForm = aForm + "Invalid Move! Try again:"
aForm = aForm + " <div> <table> <tr>"
aForm = aForm + "<td> Computer  </td>"
aForm = aForm + "<td bgcolor=#0000FF > <font color=\"white\"> #{$aGame.scoreplayer1} </font> </td>"
aForm = aForm + "<td> vs.  </td>"
aForm = aForm + "<td> Player  </td>"
aForm = aForm + "<td bgcolor=#00FF00>  #{$aGame.scoreplayer2} </td>"
aForm = aForm +  " <td> || </td>"
aForm = aForm + "<td> Tiles Remaining:  </td>"
aForm = aForm + "<td >  #{$aGame.tilesremain.size} </td>"
aForm = aForm +  " </tr> </table> </div>"
aForm = aForm +  "<div> <table> <td> Your Tiles </td> "

i = 0
while i < 7
    aForm = aForm + "<td> <input type = \"text\" disabled=\"disabled\" size =\"1\" name =\"tile#{i}\" value =\"#{$aGame.currentplayertileset[i]}\" </td> "
    i += 1
end
aForm = aForm +  " </tr> </table> </div>"
aForm = aForm + "<div> <table>"
aForm = aForm + "<tr>"
aForm = aForm +  " <td> Your Move </td>"
aForm = aForm + "<td> <input type = \"text\" name = \"word\" placeholder =\"word\" size \"10\" </td>"
aForm = aForm + "<td> <input type = \"text\" name = \"xcoordinate\" placeholder =\"row\" size = \"2\"</td>"
aForm = aForm + "<td> <input type = \"text\" name = \"ycoordinate\" placeholder =\"col\" size = \"2\"</td>"
aForm = aForm + "<td> <input type = \"text\" name = \"direction\" placeholder =\"direction\" size = \"8\"</td>"
aForm = aForm + "<input type = \"submit\" value = \"Place Move\" formaction = \"/manualmovePvC\"/>"
aForm = aForm + "</tr> </table></div>"


aForm = aForm + "<table> "

aForm = aForm + "<tr> <td> ... </td> "
i = 0
while i < 15
    aForm = aForm + "<td>#{i}</td>"
    i += 1
end
aForm = aForm + "</tr> "

i = 0
while i < 15
    aForm = aForm + "<tr>"
    aForm = aForm + "<td>#{i}</td>"
    j = 0
    while j < 15
        aForm = aForm + "<td"
        aForm = aForm + " bgcolor=#0000FF" if ($aWordfriend.myboard.newgrid[i][j] == 'n')
        aForm = aForm + " bgcolor=#000000" if ($aWordfriend.myboard.lettergrid[i][j] != '-')
        aForm = aForm + "> <B>"
        aForm = aForm + "<input type = \"text\" class=\"jander2\" disabled=\"disabled\" "
        if $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'W'
            aForm = aForm + " placeholder =\"tw\""
            elsif $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'w'
            aForm = aForm + " placeholder =\"dw\""
            elsif $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'L'
            aForm = aForm + " placeholder =\"tl\""
            elsif $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'l'
            aForm = aForm + " placeholder =\"dl\""
            else aForm = aForm + " value =\"#{$aWordfriend.myboard.lettergrid[i][j]} \" "
        end
        aForm = aForm + " size =\"1\" name =\"#{@posname[i][j]}\""
        j += 1
        aForm = aForm + " </B> </td>"
    end
    aForm = aForm + "</tr>"
    i += 1
end
aForm = aForm + "</table></div>"

aForm = aForm  + "<div> <input type = \"submit\" value = \"Help me out! Find Moves\" formaction = \"/resultsPvC\"/> </div> "
aForm = aForm + "</body> </form> </html>"

return aForm
end


def games_view
aForm =  " <form method=\"post\"> "
aForm = aForm +  "<head> <title>Games</title> </head> <body> <div> <table> "
aForm = aForm + "<th>Game</th> <th>Choose</th>"

newi = $aWordfriend.usergames.size
$aWordfriend.usergames.each_index {|i| agame = $aWordfriend.usergames[i]
    aForm = aForm + "<tr>"
    aForm = aForm + "<td> <input type = \"text\" name = \"game#{i}\" value =\"#{agame}\" size = \"20\"</td>"
    aForm = aForm  + "<td> <input type = \"submit\" name=\"choice\" value = \"PvP #{i}\" formaction = \"/startgamePvP\"/> </td> "
    aForm = aForm  + "<td> <input type = \"submit\" name=\"choice\" value = \"PvC #{i}\" formaction = \"/startgamePvC\"/> </td> "
}
aForm = aForm + "<tr>"
aForm = aForm + "<td> <input type = \"text\" name = \"game#{newi}\" value =\"\" size = \"20\"</td>"
aForm = aForm  + "<td> <input type = \"submit\" name=\"choice\" value = \"PvP #{newi}\" formaction = \"/startgamePvP\"/> </td> "
aForm = aForm  + "<td> <input type = \"submit\" name=\"choice\" value = \"PvC #{newi}\" formaction = \"/startgamePvC\"/> </td> "

aForm = aForm + "</table></div>"
aForm = aForm  + "<input type = \"submit\" name=\"choice\" value = \"Wait! These aren't my games! Go back!\" formaction = \"/\"/>  "

aForm = aForm + "</body> </form> </html>"

return aForm
end


def cheatgameboard_view
aForm =  " <form method=\"post\"> "
aForm = aForm +  "<head> <title>Current Board</title> </head> <body>"

aForm = aForm +  " <div> Enter Your Tiles<table>  <tr> "

i = 0
while i < 7
    aForm = aForm + "<td>"
    aForm = aForm + "<input type = \"text\""
    aForm = aForm + " value = \"#{$aGame.currentplayertileset[i]}\" "
    aForm = aForm + " size =\"1\" name = \"#{@tilename[i]}\" "
    aForm = aForm + " </td>"
    i += 1
end

aForm = aForm  + "<td> <input type = \"submit\" value = \"Find Moves\" formaction = \"/results\"/> </td> "
aForm = aForm +  " </tr> </table> </div>"

aForm = aForm +  " <div> Enter Current Board <table> "
aForm = aForm + "<table> "
aForm = aForm + "<tr> <td> ... </td> "
i = 0
while i < 15
    aForm = aForm + "<td>#{i}</td>"
    i += 1
end
i = 0
aForm = aForm + "</tr> "

while i < 15
    aForm = aForm + "<tr>"
    aForm = aForm + "<td>#{i}</td>"
    j = 0
    while j < 15
        aForm = aForm + "<td"
        aForm = aForm + " bgcolor=#0000FF" if ($aWordfriend.myboard.newgrid[i][j] == 'n')
        aForm = aForm + " bgcolor=#000000" if ($aWordfriend.myboard.lettergrid[i][j] != '-')
        aForm = aForm + ">"
        aForm = aForm + "<input type = \"text\" class=\"jander2\"  "
        if $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'W'
            aForm = aForm + " placeholder =\"tw\""
            elsif $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'w'
            aForm = aForm + " placeholder =\"dw\""
            elsif $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'L'
            aForm = aForm + " placeholder =\"tl\""
            elsif $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'l'
            aForm = aForm + " placeholder =\"dl\""
            else aForm = aForm + " value =\"#{$aWordfriend.myboard.lettergrid[i][j]}\""
        end
        aForm = aForm + " size =\"1\" name =\"#{@posname[i][j]}\""
        j += 1
        aForm = aForm + " </td>"
    end
	aForm = aForm + "</tr>"
    i += 1
end
aForm = aForm + "</table></div>"

aForm = aForm + "</body> </form> </html>"

return aForm
end

def askresume_view
aForm =  " <form method=\"post\"> "
aForm = aForm +  "<head> <title>Resume Game ?</title> </head> <body>"

aForm = aForm + " <div> <table> "
aForm = aForm + "<th>There is an existing game: Please choose</th>"
aForm = aForm + "<tr>"
aForm = aForm  + "<td> <input type = \"submit\" name=\"Resume Game\" value = \"Resume Game\" formaction = \"/resumegame\"/> </td> "
aForm = aForm  + "<td> <input type = \"submit\" name=\"New Game\" value = \"Start New Game\" formaction = \"/newgame\"/> </td> "
aForm = aForm + "</table></div>"

aForm = aForm + "</body> </form> "

aForm = aForm + "</html>"

return aForm
end


def askmode_view
aForm =  " <form method=\"post\"> "
aForm = aForm +  "<head> <title>Set Mode</title> </head> <body>"

aForm = aForm + " <div> <table> "
aForm = aForm + "<th>New Game: Please choose mode</th>"
aForm = aForm + "<tr>"
aForm = aForm  + "<td> <input type = \"submit\" name=\"PlayComputer\" value = \"Play vs Computer\" formaction = \"/startgamePvC\"/> </td> "
aForm = aForm + "</table></div>"

aForm = aForm + "</body> </form> "

aForm = aForm + "</html>"

return aForm
end


def arcaneusergameboard_view
aForm =  " <form method=\"post\"> "
aForm = aForm + "<head> <style> .jander2 {font-weight: bold;} </style> <title>Unchanged Board</title> </head> <body> "
aForm = aForm + " <div> <table> <tr>"
aForm = aForm + "<td> Computer  </td>"
aForm = aForm + "<td bgcolor=#0000FF > <font color=\"white\"> #{$aGame.scoreplayer1} </font> </td>"
aForm = aForm + "<td> vs.  </td>"
aForm = aForm + "<td> Player  </td>"
aForm = aForm + "<td bgcolor=#00FF00>  #{$aGame.scoreplayer2} </td>"
aForm = aForm +  " <td> || </td>"
aForm = aForm + "<td> Tiles Remaining:  </td>"
aForm = aForm + "<td >  #{$aGame.tilesremain.size} </td>"
aForm = aForm +  " </tr> </table> </div>"
aForm = aForm +  "<div> <table> <td> Your Tiles </td> "
i = 0
while i < 7
    aForm = aForm + "<td> <input type = \"text\" disabled=\"disabled\" size =\"1\" name =\"tile#{i}\" value =\"#{$aGame.currentplayertileset[i]}\" </td> "
    i += 1
end
aForm = aForm +  " </tr> </table> </div>"
aForm = aForm + "<div> <table>"
aForm = aForm + "<tr>"
aForm = aForm +  " <td> Your Move </td>"
aForm = aForm + "<td> <input type = \"text\" name = \"word\" placeholder =\"word\" size \"10\" </td>"
aForm = aForm + "<td> <input type = \"text\" name = \"xcoordinate\" placeholder =\"row\" size = \"2\"</td>"
aForm = aForm + "<td> <input type = \"text\" name = \"ycoordinate\" placeholder =\"col\" size = \"2\"</td>"
aForm = aForm + "<td> <input type = \"text\" name = \"direction\" placeholder =\"direction\" size = \"8\"</td>"
aForm = aForm + "<input type = \"submit\" value = \"Place Move\" formaction = \"/manualmovePvC\"/>"
aForm = aForm + "</tr> </table></div>"
aForm = aForm + "<table> "
aForm = aForm + "<tr> <td> ... </td> "
i = 0
while i < 15
    aForm = aForm + "<td>#{i}</td>"
    i += 1
end
i = 0
aForm = aForm + "</tr> "

while i < 15
    aForm = aForm + "<tr>"
    aForm = aForm + "<td>#{i}</td>"
    j = 0
    while j < 15
        aForm = aForm + "<td"
        aForm = aForm + " bgcolor=#0000FF" if ($aWordfriend.myboard.newgrid[i][j] == 'n')
        aForm = aForm + " bgcolor=#000000" if ($aWordfriend.myboard.lettergrid[i][j] != '-')
        aForm = aForm + ">"
        aForm = aForm + "<input type = \"text\" class=\"jander2\" disabled=\"disabled\" "
        if $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'W'
            aForm = aForm + " placeholder =\"tw\""
            elsif $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'w'
            aForm = aForm + " placeholder =\"dw\""
            elsif $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'L'
            aForm = aForm + " placeholder =\"tl\""
            elsif $aWordfriend.myboard.lettergrid[i][j] == '-' && $aWordfriend.myboard.scoregrid[i][j] == 'l'
            aForm = aForm + " placeholder =\"dl\""
            else aForm = aForm + " value =\"#{$aWordfriend.myboard.lettergrid[i][j]}\""
        end
        aForm = aForm + " size =\"1\" name =\"#{@posname[i][j]}\""
        j += 1
        aForm = aForm + " </td>"
    end
	aForm = aForm + "</tr>"
    i += 1
end
aForm = aForm + "</table></div>"

aForm = aForm  + "<div> <input type = \"submit\" value = \"Help me out! Find Moves\" formaction = \"/resultsPvC\"/> </div> "
aForm = aForm + "</body> </form> </html>"

return aForm
end


def getboard_view
rows = File.readlines("board.txt").map { |line| line.chomp } #this is an array of the board rows each as a string
aForm = "<head> <title>Current Board</title> </head> <body> <div> <table> "
i = 0
while i < 15
    aForm = aForm + "<tr>"
    j = 0
    rowletters = rows[i].scan(/./)
    while j < 15
        aForm = aForm + "<td>"
        aForm = aForm + "<input type = \"text\" "
        aForm = aForm + "value ="
        aForm = aForm + "\"" + rowletters[j] + "\""
        aForm = aForm + " size =\"1\" name =\"#{@posname[i][j]}\""
        j += 1
        aForm = aForm + " </td>"
    end
	aForm = aForm +"</tr>"
    i += 1
end
aForm = aForm  + " </table></div> <div> <input type = \"submit\" /> </div> </body> </form> </html>"

return aForm
end
################


WordFriend.run!