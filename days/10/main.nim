#part 1 
#incomplete line is one where
# opening bra doesn't have a corresponding ket
#corrupted is where
#we get a spurious ket without a matching bra
import std/[strutils,enumutils]
type charArray[T] = array[char.low..char.high,T]

const charScore = block:
    var res:charArray[int]#array[char.low..char.high,int]
    res['1'] = 0
    res[')'] = 3
    res[']'] = 57
    res['}'] = 1197
    res['>'] = 25137
    res
const bras = {'(','[','{','<'}
const kets = {')',']','}','>'}
const matching_bra = block:
    var res:charArray[char]#array[256,char]
    res[')'] = '('
    res['}'] = '{'
    res[']'] = '['
    res['>'] = '<'
    res
const matching_ket = block:
    var res:charArray[char]#array[256,char]
    res['('] = ')'
    res['['] = ']'
    res['{'] = '}'
    res['<'] = '>'
    res

proc first_illegal_char(line:string):char =
    var openStack:seq[char]
    for c in line:
        case c
        of bras: openStack.add c
        of kets:
            if openStack[^1] == matching_bra[c]:
                discard openStack.pop()
            else:
                return c
        else:
            return '0'
    return '1'
proc score(line:string):int =
    charScore[first_illegal_char(line)]

proc q1(filename:string):int = 
    for line in filename.lines:
        result.inc line.score
echo "input".q1