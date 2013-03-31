require 'rubygems'
require 'sinatra'
require './resource_Wordfriend'



get '/' do
    $aWordfriend = Wordfriend.new
    $aWordfriend.initialvalues
    

    erb:showwelcome
end

post '/usergames' do
    $aWordfriend.gameuser = params["ausername"] + params["pin1"] + params["pin2"] + params["pin3"] + params["pin4"]
    $aWordfriend.createuserdirectory
    $aWordfriend.getusergames
    
    erb:showgames
end

post '/board' do
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
    $aWordfriend.createuserdirectory #creates the user directory if it does not exist already
    $aWordfriend.creategamefile #creates game file and fills it with '-' if it does not exist already
    $aWordfriend.updatevalues
    erb:showboard
end

get '/board' do
"Direct access to the \"/board\" URL has been deprecated. Try going to the root (\"http://dry-brushlands-6613.herokuapp.com/\")"
end

post '/revert' do
    $aWordfriend.readboard
    i = 0
    while i < $aWordfriend.myboard.dimension
        j = 0
        nhash = {}
        while j < $aWordfriend.myboard.dimension
            nhash[j] = '-'
            j += 1
        end
        $aWordfriend.myboard.newgrid[i] = nhash
        i += 1
    end
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
    
    i=0
    anarray = []
    while i < 7
        anarray.push(params[@tilename[i]])
        i += 1
    end
    $aWordfriend.myboard.tileword = anarray.join('')
    
    $aWordfriend.saveboard
    
    $aWordfriend.updatevalues
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
    
    case
		when @direction == "right"
        i = 0
        while i < @word.length
            $aWordfriend.myboard.lettergrid[@xcoordinate.to_i][@ycoordinate.to_i + i] = @word[i]
            $aWordfriend.myboard.newgrid[@xcoordinate.to_i][@ycoordinate.to_i + i] = 'n'
            i += 1
        end
		when @direction == "down"
        i = 0
        while i < @word.length
           $aWordfriend.myboard.lettergrid[@xcoordinate.to_i + i][@ycoordinate.to_i] = @word[i]
            $aWordfriend.myboard.newgrid[@xcoordinate.to_i + i][@ycoordinate.to_i] = 'n'
            i += 1
        end	
    end
    
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
    
    $aWordfriend.saveboard
    
    $aWordfriend.updatevalues
    
    erb:showboard
end

