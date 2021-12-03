## input is a list of binary numbers
from std/strutils import parseBinInt
import std/bitops
import zero_functional
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

##ok seriouser now

template diagnosis[bitlen:static int](input:seq[uint],criterion:untyped):uint =
    var input = input
    for i{.inject.} in 0..<bitlen:
        input = input --> filter(criterion)
        if input.len == 1:
            return input
proc oxygenGenerator[bitlen:static int](input:seq[uint]):uint =
    var input = input
    for i in countdown(bitlen-1,0):
        var zeros,ones:seq[uint]
        for x in input:
            if ((x shr i) and 1)==1:
                ones.add x
            else:
                zeros.add x
        #var mostcommon,leastcommon:seq[int]
        if ones.len >= zeros.len:
            #mostcommon = move(ones)
            input = move(ones)
            #leastcommon = move(zeros)
        else:
            input = move(zeros)
            #mostcommon = move(zeros)
            #leastcommon = move(ones)
        if input.len == 1:        
            return input[0]
    raise new ValueError
proc c02Scrubber[bitlen:static int](input:seq[uint]):uint =
    var input = input
    for i in countdown(bitlen-1,0):
        if len(input)==1:
            return input[0]
        var zeros,ones:seq[uint]
        for x in input:
            if ((x shr i) and 1) == 1:
                ones.add x
            else:
                zeros.add x
        #var mostcommon,leastcommon:seq[int]
        if ones.len >= zeros.len:
            #mostcommon = move(ones)
            input = move(zeros)
            #leastcommon = move(zeros)
        else:
            input = move(ones)
            #mostcommon = move(zeros)
            #leastcommon = move(ones)
    raise new ValueError

        
proc q2[N:static int](filename:string):uint =
    ## life support rating
    ## oxygen generator rating * c02 scrubber rating
    ## only first bit
    ## keep bits that match bit criteria
    ## if there's one number, stop, this is number
    ## else consider next bit to the right
    ## oxygen gen: filter on numbers with most common value
    ## if 01 equally common-> 1
    let input:seq[uint] = (filename.lines --> map(it.parseBinInt.uint))
    return input.c02Scrubber[:N] * input.oxygenGenerator[:N]


     
when isMainModule:
    assert q1[5]("test") == 198
    echo q1[12]("input")
    assert q2[5]("test") == 230
    echo q2[12]("input")


