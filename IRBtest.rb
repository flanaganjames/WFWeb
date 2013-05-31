require './resource_Game'
$aGame = Game.new
$aGame.initialvalues
$aGame.gameuser="UnitTests"
$aWordfriend.gameuser = $aGame.gameuser
$aGame.gamefile="wordscores6.txt"
$aWordfriend.gamefile = $aGame.gamefile
$aGame.readgame
$aGame.resumegameCheat
$wf = $aWordfriend
$board = $wf.myboard
$board.describehotspots
#$board.findhotspotSWs