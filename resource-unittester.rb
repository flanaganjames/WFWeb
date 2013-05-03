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
    $aGame.resumegameCheat
    afilename = "./Users/" + $aGame.gameuser + "/" + file1
    afile = File.open(afilename, "r")
    arr = File.readlines(afilename).map { |line| line.chomp } 
    afile.close
    aSW = ScrabbleWord.new(arr[21],arr[22].to_i,arr[23].to_i,arr[24], 0,0)
    targetscore = arr[25]
    status = $aWordfriend.manualwordtest(aSW)
    $aGame.placewordfromtiles2(aSW)
    puts "test#{test} scores: direct #{aSW.score}, supplement #{aSW.supplement} | targetscores: #{targetscore} "
    puts "test#{test} word or placement invalid" if not(status)
end

end
