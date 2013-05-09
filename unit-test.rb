require './resource-unittester'
aTest = Unittester.new
aTest.intialvalues

#aTest.scoretest(1, "wordscores1.txt")
#aTest.scoretest(2, "wordscores2.txt")
#aTest.scoretest(3, "wordscores3.txt")
#aTest.scoretest(4, "wordscores4.txt")
#aTest.scoretest(5, "wordscores5.txt")
#aTest.scoretest(6, "wordscores6.txt")
#aTest.scoretest(7, "wordscores7.txt")

aTest.wordfindtest(1, "wordscores1.txt")
aTest.wordfindtest(2, "wordscores2.txt")
aTest.wordfindtest(3, "wordscores3.txt")
aTest.wordfindtest(4, "wordscores4.txt")
aTest.wordfindtest(5, "wordscores5.txt")
aTest.wordfindtest(6, "wordscores6.txt")
aTest.wordfindtest(7, "wordscores7.txt")