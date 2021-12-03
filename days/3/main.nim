## input is a list of binary numbers
from std/strutils import parseBinInt
import std/bitops
## input -> gamma rate, epsilon rate
## gamma rate is most common bit at each position
## we could count how many ones and then if it's less than half it becomes a zero
## 0 0 0 1
## 0 0 1 1
## 0 1 1 1
## -------
## 0 0 1 1
## epsilon rate is the opposite, ~gamma
## i actually dont want to parse as binary straightaway
proc q1[N:static int](filename:string):uint =
    var ones: array[N,int]
    for line in filename.lines:
        for i,c in line.pairs:
            case c
            of '1':
                inc ones[i]
            of '0':
                dec ones[i]
            else:
                raise new ValueError
    var gamma,epsilon: uint
    echo ones
    for i,b in ones:
        if b>0:
            gamma.setBit(N-1-i)
            epsilon.clearBit(N-1-i)
        elif b<0:
            gamma.clearBit(N-1-i)
            epsilon.setBit(N-1-i)
        else:
            raise new ValueError
    return gamma*epsilon

when isMainModule:
    assert q1[5]("test") == 198
    echo q1[12]("input")


