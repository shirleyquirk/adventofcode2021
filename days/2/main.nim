## example input
const testinput="""forward 5
down 5
forward 8
up 3
down 8
forward 2"""

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

when isMainModule:
    echo q1("input")