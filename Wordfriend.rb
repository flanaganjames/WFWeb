require './resource_Wordfriend'

aWordfriend = Wordfriend.new
aWordfriend.initialvalues 
    
aWordfriend.wordfind.each {|possible| possible.print('game')}