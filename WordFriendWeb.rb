require 'rubygems'
require 'sinatra'
require './resource_Wordfriend'
require './resource_Game'



get '/' do
    $aWordfriend = Wordfriend.new
    $aWordfriend.initialvalues

    erb:showwelcome
end


post '/' do
    $aWordfriend.removeuserdirectoryifempty
    
    #    $aWordfriend = Wordfriend.new
    #    $aWordfriend.initialvalues
    
    erb:showwelcome
end

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


post '/board' do  #posts from /usergames showgames
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
    
    @choice = params["choice"]
    $aWordfriend.gamefile = params["game"+@choice.to_s]

    $aWordfriend.creategamefile #creates game file and fills it with '-' if it does not exist already
    $aWordfriend.updatevalues
    erb:showboard
end

post '/startgame' do  #this posts from /usergames showgames and assumes the gameuser is identfied and for now assumes the gamefile is a new file
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
    
    @choice = params["choice"]
    $aWordfriend.gamefile = params["game"+@choice.to_s]# created at '/', creates board, reads scoring and dictionary, gameuser, gamefile, possiblewords
    
    $aWordfriend.creategamefile #creates game file and fills it with '-' if it does not exist already
    $aGame = Game.new # players1/2, currentplayer, tiles1/2, score1/2, tilesremain,
    $aGame.initialvalues #tilesremain initialized, score1/2=0, tiles1/2 = ''
    $aWordfriend.initialvalues #creates a new board
    $aWordfriend.updatevalues(0) #readboard, findSWs, tilepermutedset, $possiblewords(words w tiles and board), $tilewords (words w tiles only)
    $aGame.gameplayer2 = $aWordfriend.gameuser
    $aGame.gameplayer1 = "ArcaneWord"
    $aGame.initializegame #sets currentpayer = gameplayer1 and fills both players' tile sets;
    $aGame.firstmove #tileword = tiles1, the computer player1 makes the first move, putting the first word on the board, saves the file under gameuser and gamefile
    $aWordfriend.myboard.tileword = $aGame.tilesplayer2
    $aWordfriend.saveboard($aGame.tilesplayer1,$aGame.tilesplayer2)
    erb:showArcaneUsergameboard #shows board after player1 w player2 tiles allowing player 2 to move (may use automated and see '/results', then '/updated' then '/nextmove')
end

post '/nextmove' do
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
    $aGame.tilesplayer2 = $aWordfriend.myboard.newtileword  #the move just reviewed in '/updated' is now accepted, the remaining tiles in newtileword transferred to thetilesplate2
    $aWordfriend.myboard.resetnewindicator
    $aGame.tilesplayer2 = $aGame.filltiles($aGame.tilesplayer2) #player2 just moved and used some tiles
    $aWordfriend.myboard.tileword = $aGame.tilesplayer2
    $aWordfriend.saveboard($aGame.tilesplayer1,$aGame.tilesplayer2)  #so that gamefile is current w board and new tiles

    $aGame.nextmove
    $aWordfriend.myboard.tileword = $aGame.tilesplayer2
    $aWordfriend.saveboard($aGame.tilesplayer1,$aGame.tilesplayer2)
    erb:showArcaneUsergameboard
end

get '/board' do
"Direct access to the \"/board\" URL has been deprecated. Try going to the root (\"http://dry-brushlands-6613.herokuapp.com/\")"
end

post '/revert' do
    $aWordfriend.readboard
    $aWordfriend.myboard.resetnewindicator
    erb:showresults
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
    
    #   i=0
    #    anarray = []
    #while i < 7
    #    anarray.push(params[@tilename[i]])
    #    i += 1
    #end
    #$aWordfriend.myboard.tileword = anarray.join('')
    
    $aWordfriend.saveboard($aGame.tilesplayer1,$aGame.tilesplayer2)
    $aWordfriend.myboard.resetnewindicator
    $aWordfriend.updatevalues(1)
    $aWordfriend.wordfind
    
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
    
    aSW = ScrabbleWord.new(@word, @xcoordinate.to_i, @ycoordinate.to_i, @direction, 0, 0)
    $aWordfriend.myboard.placewordfromtiles(aSW)
    
    erb:showupdated
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
    
    $aWordfriend.saveboard($aGame.tilesplayer1,$aGame.tilesplayer2)
    
    $aWordfriend.updatevalues
    
    erb:showboard
end

