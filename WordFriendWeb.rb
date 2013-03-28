require 'rubygems'
require 'sinatra'
require './resource_Wordfriend'



get '/' do
"Welcome to Word Friend!"
end

get '/board' do
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
     $aWordfriend = Wordfriend.new
     $aWordfriend.initialvalues
    
    erb:showboard
end

post '/revert' do
    $aWordfriend.myboard.readboard("Games/" + $aWordfriend.boardfile + ".txt")
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
    
    afile = File.open("Games/" + $aWordfriend.boardfile + ".txt", "w")
    i = 0
    while i < 15
        j = 0
        rowletters = ""
        while j < 15
            rowletters = rowletters + params[@posname[i][j]]
            $aWordfriend.myboard.lettergrid[i][j] = params[@posname[i][j]]
            j += 1
        end
        afile.puts(rowletters)
        i += 1
    end
    afile.close
    
    $aWordfriend.myboard.writeboard("Games/confirm.txt")
    
    i=0
    anarray = []
    while i < 7
        anarray.push(params[@tilename[i]])
        i += 1
    end
    $aWordfriend.tileword = anarray.join('')
    
    afile = File.open("Games/lastgame.txt", "w")
    afile.puts($aWordfriend.gamefile[0])
    afile.puts($aWordfriend.tileword)
    afile.close
    
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
    
    afile = File.open("Games/" + $aWordfriend.boardfile + ".txt", "w")
    i = 0
    while i < 15
        j = 0
        rowletters = ""
        while j < 15
            rowletters = rowletters + params[@posname[i][j]]
            $aWordfriend.myboard.lettergrid[i][j] = params[@posname[i][j]]
            j += 1
        end
        afile.puts(rowletters)
        i += 1
    end
    afile.close
    
    $aWordfriend.myboard.writeboard("Games/confirm.txt")
    
    i=0
    anarray = []
    while i < 7
        anarray.push(params[@tilename[i]])
        i += 1
    end
    $aWordfriend.tileword = anarray.join('')
    
    afile = File.open("Games/lastgame.txt", "w")
    afile.puts($aWordfriend.gamefile[0])
    afile.puts($aWordfriend.tileword)
    afile.close
    
    $aWordfriend.updatevalues
    
    erb:showboard
end

