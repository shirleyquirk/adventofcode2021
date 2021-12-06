import std/[sequtils,strutils,lists]
import zero_functional

type 
    LanternFish = SinglyLinkedRing[int]
    ## LanternFish is a histogram of fish population
    ## grouped into buckets according to how many days are left
    ## in their gestational period
    
proc rotate[T](fish:var SinglyLinkedRing[T]) =
    fish.head = fish.head.next
    fish.tail = fish.tail.next

template sixth(fish:LanternFish):SinglyLinkedNode[int] = fish.head.next.next.next.next.next.next

proc parseInput(filename:string):LanternFish = 
    var pop:array[9,int]
    for gestationTime in filename.open(fmRead).readLine.split(',').map(parseInt):
        inc pop[gestationTime]
    for fish in pop:
        result.add fish

proc tick(fish: var LanternFish) =
    ## the fish population at n days left -> the fish population at n-1 days
    ## fish population at 0 days becomes the new fish (8 days)
    fish.rotate()
    ## those new fish (now at fish.tail) get added to the 6th day
    ## to represent the parents resetting their gestational clock 
    ## and combining with the bucket that came from 7days to 6
    fish.sixth.value += fish.tail.value

func population(fish:LanternFish):int = fish --> fold(0,a + it)

func popAfterNdays(fish:LanternFish,n:int):int =
    var fish = fish
    for _ in 1..n:
        fish.tick()
    return fish.population

proc q1(filename:string):int = filename.parseInput.popAfterNdays(80)

assert q1("test") == 5934
echo q1("input")

proc q2(filename:string):int = filename.parseInput.popAfterNdays(256)

assert q2("test") == 26984457539
echo q2("input")