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



end






