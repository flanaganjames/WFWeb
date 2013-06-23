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
    
    def maxallowedSWs
    newarray =[]
        while self.size > 0
            aSW = self.pop
            if newarray.size < $maxallowed
                newarray << aSW
                newarray = newarray.sort_by {|possible| [(possible.score + possible.supplement)]}
            else
                newarray[0] = aSW if (aSW.score + aSW.supplement) > (newarray[0].score + newarray[0].supplement)
                newarray = newarray.sort_by {|possible| [(possible.score + possible.supplement)]}
            end
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
    def writewordfile
        afile = File.open("wordlist_plus_new.txt", "w")
        $words.each_key {|aword|
            afile.puts(aword)
            wordarr = aword.scan(/./)
            i = 0
            while i < aword.size
                subword = []
                wordarr.each {|achar| subword << achar}
                subword[i] = '*'
                afile.puts(subword.join(''))
                i += 1
            end
            }
        afile.close
    end
end

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
    
    def permutedsetofsize(size)  #returns a set of strings representing every permutation of size "size"
        arr = self.to_chars
        set = arr.permutation(size).to_a
        set.collect {|aset| aset.join('')}
    end
end

class Array
    def actualwords
        set = []
        alpha = 'abcdefghijklmnopqrstuvwxyz'.to_chars #creates array of alphabetic letters
        self.each {|astarword|
                        alpha.each {|aletter|
                                subword = astarword.sub('*',aletter)
                                set << subword if subword.isaword
                                }
                    }
        return set
    end
end

class String
    def permutedset_expandstar #returns a set of strings representing every permutation of every subset of characters; if a * is present, it is replaced with allowed characters
        arr = self.to_chars
        set = []
        expandedset = []
        i = 1
        while i < arr.size + 1
            set = set + arr.permutation(i).to_a
            i += 1
        end
        set.each {|apermutationset|
            expandedset = expandedset + apermutationset.join('').startoallowedcharacters #expands * to every possible allowed character
        }
        return expandedset
    end
end

class String
    def startoallowedcharacters
        set = [ self ] #at minimum retun self
        if self.include?('*')
            alpha = $allowedcharacters.to_chars #creates array of alphabetic letters
            alpha.each {|aletter|
                subword = self.sub('*',aletter)
                set << subword
            }
        end
        return set
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
    
    def isaword_plus  #this looks in the hash of words with every possible possible position substituted with a '*'
        return $words_plus[ self ] #returns an array of words consistent with a string that may have a star in it
    end
end

class String
    def matchingwordsexist  #receives a string with imbedded ., returns true if there is a matching word
        !!$words.keys.detect{ |k| k  =~ /\A#{self}\Z/ }
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
