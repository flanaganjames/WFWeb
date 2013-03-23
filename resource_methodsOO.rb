class Array
	def uniqSWs
	newarray = []
	while self.size > 0
		aSW = self.pop
		duplicate = false
		newarray.each {|bSW| duplicate = true if aSW.astring == bSW.astring && aSW.xcoordinate == bSW.xcoordinate && aSW.ycoordinate == bSW.ycoordinate}
		newarray.push(aSW) if duplicate == false
	end
	return newarray
	end
end

class String
  def to_chars
    self.scan(/./)
  end
end

#class String  #deprecated
#	def findtilewords  #from all words select those that can be made using existing tiles as a string only (all other word options are found by anchoring to existing boardSWs)
#	tileset = self.to_chars #tileset is a string composed of the tiles; tiles is an array of characters from this string
#	tilepower = tileset.powerset # tilepower is a powerset, ie all possible sets that can be made form the array of characters
#	tilewords = tilepower.collect{|anarray| anarray.join('')}.select{|element| element.isaword} # tilewords are  the strings corresponding to those subsets that are words inthe dictionary
#	end
#end

class String
	def permutedset #returns a set of strings representing every permutation of every subset of characters
	arr = self.to_chars
	set = []
	i = 1
	while i < arr.size + 1
		set = set + arr.permutation(i).to_a
		i += 1
	end
	set.collect {|aset| aset.join('')}
	end
end

class String
	def permutaround(imbeddedstring) #returns a set of strings representing additions of self to beginning and end of astring
		possibles = []
		fullset = self.to_chars
		permutedfull = self.permutedset
		permutedfull.each do |prestring|
			remainder = fullset - prestring.to_chars #the chracters that remain
			permutedremainder = remainder.join('').permutedset
			permutedremainder.each do |poststring|
				possibles.push(prestring + imbeddedstring + poststring)
			end		
		end
		return possibles
	end
end

class String
def wordsendingwith(added)
	words_match = []
	case 
		when added < 0 
			$words.each_value {|word| words_match << word if word =~ /\A..*#{self}\Z/}
		when added == 1 
			$words.each_value {|word| words_match << word if word =~ /\A.#{self}\Z/}
		when added == 2
			$words.each_value {|word| words_match << word if word =~ /\A..#{self}\Z/}
		when added == 3
			$words.each_value {|word| words_match << word if word =~ /\A...#{self}\Z/}
		when added == 4
			$words.each_value {|word| words_match << word if word =~ /\A....#{self}\Z/}
		when added == 5
			$words.each_value {|word| words_match << word if word =~ /\A.....#{self}\Z/}
		when added == 0 
			$words.each_value {|word| words_match << word if word =~ /\A#{self}\Z/}
		end	
return words_match
end
end

class String
def wordsbeginningwith(added)
	words_match = []
	case 
		when added < 0 
			$words.each_key {|word| words_match << word if word =~ /\A#{self}..*\Z/}
		when added == 1 
			$words.each_key {|word| words_match << word if word =~ /\A#{self}.\Z/}		
		when added == 2 
			$words.each_key {|word| words_match << word if word =~ /\A#{self}..\Z/}
		when added == 3 
			$words.each_key {|word| words_match << word if word =~ /\A#{self}...\Z/}
		when added == 4 
			$words.each_key {|word| words_match << word if word =~ /\A#{self}....\Z/}
		when added == 5 
			$words.each_key {|word| words_match << word if word =~ /\A#{self}.....\Z/}
		when added == 0 
			$words.each_key {|word| words_match << word if word =~ /\A#{self}\Z/}
		end
return words_match
end
end

class String
def iswithinwords
#	words_match = []
#	$words.each_key {|word| words_match << word if word =~ /\A..*#{self}..*\Z/}
#	return words_match
	words_match = $words.select{|word, value| word =~ /\A..*#{self}..*\Z/ }.keys
end
end

class String
def iscontainedwords
	words_match = []
	$words.each_key {|word| words_match << word if word =~ /\A.*#{self}.*\Z/}
	return words_match
end
end

class String
def isaword
	$words.has_key?(self)
end
end

class Array
	def powerset
		num = 2**size
		ps = Array.new(num, [])
		self.each_index do |i|
			a = 2**i
			b = 2**(i+1) - 1
			j = 0
			while j < num-1
				for j in j+a..j+b
				ps[j] += [self[i]]
				end
				j += 1
			end
		end
	ps
	end
end

class Array
  def >(other_set)
    (other_set - self).empty?
  end
end

class Array
	def subset?(other)
	    self.each do |x|
	     if !(other.include? x)
	      return false
	     end
	    end
	    true
	end
	def superset?(other)
	    other.subset?(self)
	end
end
