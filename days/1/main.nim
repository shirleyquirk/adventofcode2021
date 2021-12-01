import std/[strutils,sequtils,sugar,enumerate]
import zero_functional

proc day1(filename: string): int =
    ## read depths, return the number of times the depth increased
    var prevDepth = int.high
    for line in filename.lines:#why is lines .sideEffect?
        let depth = line.parseInt
        if depth > prevDepth:
            inc result
        prevDepth = depth



proc day1p2(filename:string):int = 
    ## 3-measurement sliding window
    ## number of times sum increases
    const N:int = 3
    var memory = [int.high, int.high, int.high]
    for (i,l) in enumerate(filename.lines --> map(parseInt)):
        ## compare sum(f[i]...f[i-2]) with
        ##         sum(f[i-1]...f[i-3])
        ## a + b + c < b + c + d
        ## i.e. d > a
        if l > memory[i mod N]:
            inc result
        memory[i mod N] = l






when isMainModule:
    echo day1("input")
    echo "---------------"
    echo day1p2("input")
