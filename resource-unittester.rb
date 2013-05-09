class Unittester
    
    require './resource_Game'
    require './resource_Wordfriend'
    require './resource_methodsOO'
	require './resource_classSW'
    require './resource_classBoard'

def intialvalues
    $aGame = Game.new
    $aGame.initialvalues #init Game, Wordfriend and Board
    $aGame.gameuser="UnitTests"
    $aWordfriend.gameuser = $aGame.gameuser
end

def scoretest (test, file1)
    $aGame.gamefile=file1
    $aWordfriend.gamefile = $aGame.gamefile
    $aGame.readgame
    $aGame.resumegameCheat #sets currentplayertileset and sends updatevalues
    afilename = "./Users/" + $aGame.gameuser + "/" + file1
    afile = File.open(afilename, "r")
    arr = File.readlines(afilename).map { |line| line.chomp } 
    afile.close
    aSW = ScrabbleWord.new(arr[36],arr[37].to_i,arr[38].to_i,arr[39], 0,0)
    targetscore = arr[40]
    status = $aWordfriend.manualwordtest(aSW)
    $aGame.placewordfromtiles2(aSW)
    puts "test#{test} scores: direct #{aSW.score}, supplement #{aSW.supplement} | targetscores: #{targetscore} "
    puts "test#{test} word or placement invalid" if not(status)
end

def wordfindtest (test, file1)
    $aGame.gamefile=file1
    $aWordfriend.gamefile = $aGame.gamefile
    $aGame.readgame
    $aGame.resumegameCheat  #sets currentplayertiles and sends updatevalues
    puts "wordfind test: #{test}"
    $aWordfriend.wordfind
end

end