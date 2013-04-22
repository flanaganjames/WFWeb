class ScrabbleWord
	attr_accessor :astring, :xcoordinate, :ycoordinate, :direction, :score, :supplement
	
	def initialize (astring, xcoordinate, ycoordinate, direction, score, supplement)
		@astring = astring
		@xcoordinate = xcoordinate
		@ycoordinate = ycoordinate
		@direction = direction
		@score = score
		@supplement = supplement
	end
	
	def print (source)
		puts "#{source}>  #{self.astring}, x=#{self.xcoordinate}, y=#{self.ycoordinate}, dirx: #{self.direction}, score: #{self.score}, suppl: #{self.supplement}, total: #{self.score + self.supplement}"
	end
    
    def coordinatesused  #returns array of coordinates covered by aSW
        array = []
        case
        when self.direction == 'right'
            i = 0
            while i < self.astring.length
                array.push([self.xcoordinate, self.ycoordinate + i])
                i += 1
            end
        when self.direction == 'down'
            i = 0
            while i < self.astring.length
                array.push([self.xcoordinate + i, self.ycoordinate])
                i += 1
            end
        end
        return array
    end
	
	

	def scoreword  #calculates only the direct score. testwordsgeninline and testwordsgenortho calculate the cupplement score from indirectly created words
		ascore = 0
		i = 0
		anarray = []
		anarray << 1
		while i < self.astring.length
			case
			when self.direction == "right"
				gridvalue = $aWordfriend.myboard.scoregrid[self.xcoordinate][self.ycoordinate + i]
				if $aWordfriend.myboard.lettergrid[self.xcoordinate][self.ycoordinate + i] == '-'
					then occupied = "false"
					else occupied = "true"
					end
				#puts "gridvalue: #{gridvalue}; occupied: #{occupied}"
			when self.direction == "down"
				gridvalue = $aWordfriend.myboard.scoregrid[self.xcoordinate + i][self.ycoordinate]
				if $aWordfriend.myboard.lettergrid[self.xcoordinate + i][self.ycoordinate] == '-'
					then occupied = "false"
					else occupied = "true"
					end
			end
			
			case			
            when gridvalue == "" #scoregrid is set to "" if a '*' character used on lettergrid
                #no addition to the score in this case
            when gridvalue == "."
				ascore = ascore + $aWordfriend.myboard.lettervalues[self.astring[i]]
			when gridvalue == "l"
				if occupied =="false" 
					then
					ascore = ascore + 2 * $aWordfriend.myboard.lettervalues[self.astring[i]]
					else
					ascore = ascore + $aWordfriend.myboard.lettervalues[self.astring[i]]
					end
			when gridvalue == "L"
				if occupied == "false" 
					then
					ascore = ascore + 3 * $aWordfriend.myboard.lettervalues[self.astring[i]]
					else
					ascore = ascore + $aWordfriend.myboard.lettervalues[self.astring[i]]
					end
			when gridvalue == "w"
				ascore = ascore + $aWordfriend.myboard.lettervalues[self.astring[i]]
				if occupied == "false" 
					then
					anarray << 2
					end
			when gridvalue == "W"
				ascore = ascore + $aWordfriend.myboard.lettervalues[self.astring[i]]
				if occupied == "false" 
					then
					anarray <<  3
					end
			end
			i += 1
		end
		wordscore = ascore * anarray.max
		self.score = wordscore
	end


end






