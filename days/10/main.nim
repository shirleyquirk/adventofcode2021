#part 1 
#incomplete line is one where
# opening bra doesn't have a corresponding ket
#corrupted is where
#we get a spurious ket without a matching bra
import std/[strutils,enumutils,sequtils,sugar]
import zero_functional
type charArray[T] = array[char.low..char.high,T]

const charScore = block:
    var res:charArray[int]#array[char.low..char.high,int]
    res['1'] = 0
    #completion scores
    res['('] = 1
    res['[']  = 2
    res['{'] = 3
    res['<'] = 4
    #corruption scores
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

#part 2. discard corrupted lines
let lines = collect(for l in "input".lines:
    if l.first_illegal_char == '1':
        l)

proc score2(line:string):int =
    var openStack:seq[char]
    for c in line:
        case c
        of bras: openStack.add c
        of kets:
            if openStack[^1] == matching_bra[c]:
                discard openStack.pop()
        else:
            assert false
            
    assert openStack.len > 0
    while openStack.len > 0:
        let c = openStack.pop()
        result = 5*result + charScore[c]

var scores = lines.map(score2)
import algorithm
scores.sort
echo scores[scores.len div 2]
