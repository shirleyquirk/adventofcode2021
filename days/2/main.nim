## example input
const testinput=""""""""

import std/[strutils] #parseEnum,parseInt
import zero_functional

type Dir = enum
  up, down, forward

proc q1(filename:string):int =
    var x,y:int
    proc pars(x:seq[string]):auto = (x[0].parseEnum[:Dir],x[1].parseInt)
    for (dir,val) in (filename.lines --> map(split(it,' ')) --> map(it.pars)):
        case dir
        of forward:
            x += val
        of up:
            y -= val
        of down:
            y += val        
    return x * y

proc q2(filename:string):int =
    var x,y,aim:int
    proc pars(x:seq[string]):auto = (x[0].parseEnum[:Dir],x[1].parseInt)
    for (dir,val) in (filename.lines --> map(split(it,' ')) --> map(it.pars)):
        case dir
        of forward:
            x += val
            y += aim * val
        of up:
            aim -= val
        of down:
            aim += val       
    return x * y



when isMainModule:
    echo q1("input")
    assert q2("test") == 900 
    echo q2("input")