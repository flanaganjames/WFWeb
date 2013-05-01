require './resource-unittester'
aTest = Unittester.new
aTest.intialvalues

aTest.scoretest(1, "wordscores1.txt", "wordscores1result.txt")
aTest.scoretest(2, "wordscores2.txt", "wordscores2result.txt")
aTest.scoretest(3, "wordscores3.txt", "wordscores3result.txt")
aTest.scoretest(4, "wordscores4.txt", "wordscores4result.txt")


