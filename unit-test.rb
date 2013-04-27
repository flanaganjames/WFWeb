class Wordfriend
	attr_accessor :myboard, :gameuser, :gamefile, :possiblewords, :usergames, :newgame, :testname
    
    require './resource_Game'
    require './resource_Wordfriend'
    require './resource_methodsOO'
	require './resource_classSW'
    require './resource_classBoard'

	
    $aGame = Game.new
    $aGame.initialvalues #init Game, Wordfriend and Board
    $aGame.gameuser="unit-test"
    $aWordfriend.gameuser = $aGame.gameuser

    $aGame.gamefile="wordscores1"
    $aWordfriend.gamefile = $aGame.gamefile
    anarray = $aGame.readgame
    targetword = annarray[6]
    xcoord = anarray[7]
    ycoord = anarray[8]
    dirx = anarray[9]
    targetscore = anarray[10]
    aSW = ScrabbleWord.new(targetword,xcoord, ycoord, dirx, 0,0)
    status = $aWordfriend.manualwordtest(aSW)
    if (status)
    then
    aSW.scoreword
    $aGame.placewordfromtiles2(aSW)
    
    else
    aSW.scoreword

    end


    