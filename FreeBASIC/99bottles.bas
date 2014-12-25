dim bottles as integer
for bottles = 99 to 1 step -1
    print str(bottles);" bottles of beer on the wall,"
    print str(bottles);" bottles of beer!"
    print "Take one down and pass it around,"
    if bottles-1 = 0 then
        print "No bottles of beer on the wall!"
    else
        print str(bottles-1);" bottles of beer on the wall!"
    endif
    print
next
print "No bottles of beer on the wall,"
print "No bottles of beer!"
print "Go to the store and buy 99 more,"
print "99 bottles of beer on the wall!"
sleep
