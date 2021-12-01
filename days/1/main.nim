import std/[strutils,sequtils,sugar]
proc day1(filename: string): int =
    ## read depths, return the number of times the depth increased
    var prevDepth = int.high
    for line in filename.lines:#why is lines .sideEffect?
        let depth = line.parseInt
        if depth > prevDepth:
            inc result
        prevDepth = depth

when isMainModule:
    echo day1("input")
