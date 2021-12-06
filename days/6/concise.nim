import std/[strutils,algorithm,math,sugar]
import zero_functional

type LanternFish = array[9,int]
    
proc parseInput(filename:string):LanternFish = 
    filename.open.readLine.split(',') --> map(parseInt) --> foreach(inc result[it])

proc afterNdays(fish:var LanternFish,n:int) =
    for _ in 1..n:
        fish.rotateLeft(1)
        fish[6] += fish[8]

let fish = "input".parseInput()
echo fish.dup(afterNdays(80)).sum
echo fish.dup(afterNdays(256)).sum