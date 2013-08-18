require 'rubygems'
require 'sinatra'
require './resource_Wordfriend'
require './resource_Game'
require 'daemons'

# if game exists then ask if resume
#if choose resume then start game in previously defined mode
#if choose new then post /newgame which will show askmode.erb

#if no game exists then show askmode.erb

#askmode will either select PvC and start a new game PvC
#or askmode will select PvP ans start a new game PvP

get '/' do
    #$aWordfriend = Wordfriend.new
    #$aWordfriend.initialvalues
    $aGame = Game.new
    $aGame.initialvalues
    erb:showwelcome  #post /usergames
end


post '/' do
    $aWordfriend.removeuserdirectoryifempty
    
    #    $aWordfriend = Wordfriend.new
    #    $aWordfriend.initialvalues
    
    erb:showwelcome
end

post '/usergame' do
    if (params["ausername"] == '' || params["pin1"] == '' || params["pin2"] == '' || params["pin3"] == '' || params["pin4"] == '')
    then
        $aWordfriend.gameuser = ''
        erb:showwarning
    elsif (params["pin1"] == params["pin2"] && params["pin3"] == params["pin4"] && params["pin2"] == params["pin3"])
            $aWordfriend.gameuser = ''
            erb:showwarning
    else
            $aGame.gameuser = params["ausername"] + params["pin1"] + params["pin2"] + params["pin3"] + params["pin4"]
            $aWordfriend.gameuser = $aGame.gameuser
            $aWordfriend.createuserdirectory #creates the user directory if it does not exist already
            $aGame.getusergame
            if $aGame.newgame == "no" 
                erb:showaskresume 
            else
                $aGame.initializegame
                erb:showaskmode
            end
    end
end


post '/resumegame' do  #this posts from askresume.erb
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
    
    $aGame.newgame = "no"
    $aGame.readgame
    if $aGame.mode == "PlayerVsComputer"
        puts "resume PVC"
        $aGame.resumegamePvC
        erb:showArcaneUsergameboard
    else
        puts "resume Cheat"
        $aGame.resumegameCheat
        erb:showCheatgameboard
    end
end

post '/newgame' do #this posts from askresume.erb
    $aGame.newgame = "yes"
    $aGame.initializegame
    puts "about to ask mode 2"  #the following works
    erb:showaskmode
end


#the following is used only in the "multigame" git version (user can have multiple games
post '/usergames' do
    if (params["ausername"] == '' || params["pin1"] == '' || params["pin2"] == '' || params["pin3"] == '' || params["pin4"] == '')
        then
        $aWordfriend.gameuser = ''
        erb:showwarning
        elsif params["pin1"] == params["pin2"] && params["pin3"] == params["pin4"] && params["pin2"] == params["pin3"]
        $aWordfriend.gameuser = ''
        erb:showwarning
        else
        $aWordfriend.gameuser = params["ausername"] + params["pin1"] + params["pin2"] + params["pin3"] + params["pin4"]
        $aWordfriend.createuserdirectory #creates the user directory if it does not exist already
        $aWordfriend.getusergames
        erb:showgames
    end
end

#start of PvC_______________________________________________________

post '/startgamePvC' do  #this posts from /askmode if PvC is chosen and assumes the gameuser is identfied and that the gamefile is a new file
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

    if $aGame.newgame = "yes"
    $aGame.initializegamePvC
    $aGame.firstmove
    #tileword = tiles1, the computer player1 makes the first move, putting the first word on the board
    end
    #this assumes that the resume game always occurs after computer has made its move and was saved then.
    erb:showArcaneUsergameboard #shows board after player1 w player2 tiles allowing player 2 to choose to showresults
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
    erb:showinvalidmove if not(status)
    $aGame.placewordfromtiles2(aSW) if status
    $aGame.saveboard
    erb:showupdatedPvC if status
end


post '/gettingresultsPvC' do  #posted from showArcanUsergameboard
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
    
    #$aGame.nextmovePlayer2
    
    $aGame.currentplayertileset = $aGame.tilesplayer2
    #$aGame.saveboard
    $aWordfriend.updatevalues($aGame.tilesplayer2)
    $task = Thread.new {
        $aWordfriend.wordfind}
    erb:showberightbackPvC
  
end

post '/resultsPvC' do  #posted from showberightback
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
    
    erb:showresultsPvC
    
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
    
    erb:showupdatedPvC
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
    
    erb:showupdatedPvCFind
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
    
    erb:showArcaneUsergameboard
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
    
    erb:showresultsPvC
end

post '/nextmovePlayer1' do   #posted from showupdatePvC

    $aGame.nextmovePlayer1
    $task = Thread.new {
        $aWordfriend.wordfind}
    erb:showberightbackArcaneMove
end

post '/shownextmovePlayer1' do
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
    $aGame.finishnextmovePlayer1
    erb:showArcaneUsergameboard
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
    erb:showCheatgameboard
end

post '/gettingresults' do
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
    $aGame.saveboard
    $aWordfriend.updatevalues($aGame.tilesplayer2)
    $task = Thread.new {
        $aWordfriend.wordfind
        #call '/results'
        #redirect '/results'
        #task.join
        #erb:showresults
    }
    erb:showberightback
    #$task.join
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
    
    erb:showresults
end

get '/results' do
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
    
    erb:showresults
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

    erb:showupdated
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
    
    erb:showresults
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
    $aGame.nextmoveCheat
    $aGame.saveboard
    erb:showCheatgameboard
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
    
    erb:showboard
end

