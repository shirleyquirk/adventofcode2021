import std/[sequtils,strutils,lists]
type
    LanternFish = object
        gestationTime: int
proc parseInput(filename:string):seq[LanternFish] = filename.open(fmRead).readLine.split(',').mapIt(LanternFish(gestationTime: it.parseInt))
#lanternfish produce a new lanternfish every 7 days
proc tick(fish:var seq[LanternFish]) =
    var newfishes=0
    for f in fish.mitems:
        dec f.gestationTime
        if f.gestationTime < 0:
            f.gestationTime = 6
            inc newfishes
    fish.add newSeqWith(newfishes,LanternFish(gestationTime:8))


proc q1(filename:string):int =
    var fish = filename.parseInput
    for i in 0..79:
        fish.tick()
    return fish.len
assert q1("test") == 5934
echo q1("input")#this is surely gonna explode stupidly...nope 393019.

type
    LanternPop = SinglyLinkedRing[uint64]
template sixth(l:LanternPop):SinglyLinkedNode[uint64] = l.head.next.next.next.next.next.next

proc rotate(l:var LanternPop) =
    l.head = l.head.next
    l.tail = l.tail.next
proc tick(fish:var LanternPop) =
    #shuffle them all down one
    #one time a linked list makes sense
    #actually a ring. but backwards
    # so head == 8th, head.next == 7th
    # and tail
    #tail.............head
    #0 1 2 3 4 5 6 7 8 =>
    #8 0 1 2 3 4 5 6 7
    #add 8 to 6
    fish.rotate()
    fish.sixth.value += fish.tail.value

proc initLanternPop(x:seq[LanternFish]):LanternPop =
    var pop: array[9,int]
    
    for s in x:
        inc pop[s.gestationTime]
    for s in pop:
        result.add(s.uint)
    
proc population(x:LanternPop):uint64 =
    for p in x:
        result += p    

proc q2(filename:string):uint64= 
    ## here we go. this is where it splodes
    ## what if it's 256? ok, now we don't want an int for each, we want 7 ints for all the fish at eeach gestation day
    ## doubles every 8 days so 2**(256/8) ish. that's about 2^32 ok so just use a uint.
    var fish = filename.parseInput.initLanternPop
    for _ in 0..255:
        fish.tick()
        #echo fish
    return fish.population
assert q2("test") == 26984457539.uint64
echo q2("input")