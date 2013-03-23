require 'rubygems'
require 'sinatra'



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
    erb:getboard
end


post '/board' do
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
    afile = File.open("board.txt", "w")
    i = 0
    while i < 15
        j = 0
        rowletters = ""
        while j < 15
            rowletters = rowletters + params[@posname[i][j]]
            j += 1
        end
        afile.puts(rowletters)
        i += 1
    end
    afile.close
end


get '/over' do
    ":method_override  is set to " + settings.method_override.to_s
end


get '/reset' do
    set :method_override, false
    "set method_override to false"
end