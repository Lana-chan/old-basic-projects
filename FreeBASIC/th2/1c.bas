dim as ubyte a(20,20)
dim as integer b, c, d
if command(1) = "" then end
if command(2) = "" then end
open command(1) for input as 1
for b=0 to 19:input #1,a(0,b),a(1,b),a(2,b),a(3,b),a(4,b),a(5,b),a(6,b),a(7,b),a(8,b),a(9,b),a(10,b),a(11,b),a(12,b),a(13,b),a(14,b),a(15,b),a(16,b),a(17,b),a(18,b),a(19,b):next b
close 1
open command(2) for binary as #1
for b = 0 to 19:for c = 0 to 19:d+=1:put #1,d,a(c,b):next c: next b
close #1