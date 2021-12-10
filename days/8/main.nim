import std/[strutils,sequtils,sugar,setutils,math]
import zero_functional

proc parseInput(filename:string):seq[(seq[set[char]],seq[set[char]])] =
    for line in filename.lines:
        let tmp = line.split('|')
        let patterns = tmp[0].strip.split(' ')
        let outputs = tmp[1].strip.split(' ')
        result.add (patterns.mapIt it.toSet,outputs.mapIt it.toSet)

proc q1(outputs:seq[seq[set[char]]]):int =
    ## how many times do 1,4,7,8 appear in outputs?
    for l in outputs:
        for x in l:
            if x.len in {2,4,3,7}:
                inc result

echo q1(("input".parseInput --> split())[1])


const digits = @["abcefg","cf","acdeg","acdfg","bcdf","abdfg","abdefg","acf","abcdefg","abcdfg"].map((x:string)=>x.toSet)
    
proc mapCard(body:set[char]->set[char]):seq[int] = digits.mapIt(card(body(it)))
template minMax(body:set[char]->set[char]):type = range[min(mapCard(body))..max(mapCard(body))]
proc four_intx(it,four:set[char]):set[char] = it*four
proc one_intx(it,one:set[char]):set[char] = it*one
type 
    fourRange = minMax(it=>four_intx(it,digits[4]))
    oneRange = minMax(it=>one_intx(it,digits[1]))
    cardRange = minMax(it=>it)
    Dispatcher = array[fourRange,array[oneRange,array[cardRange,int]]]

template `[]`(x:Dispatcher,d,four,one:set[char]):untyped = x[d.four_intx(four).card][d.one_intx(one).card][d.card]
template `[]=`(x:Dispatcher,d,four,one:set[char],val:int):untyped = x[d.four_intx(four).card][d.one_intx(one).card][d.card] = val

const dispatcher = block:
    var res:Dispatcher
    for i,d in digits:
        res[d,digits[4],digits[1]] = i
    res

proc wireMapping(input:openArray[set[char]]):auto =
    var one,four:set[char]
    template card(x:int):int = digits[x].card    
    for d in input:
        case d.card
        of 1.card:
            one = d
        of 4.card:
            four = d
        else:
            discard
    result = (x:set[char]) => dispatcher[x,four,one]

iterator reversed[T](x:openArray[T]):T =
    for i in countdown(x.len-1,0):
        yield x[i]

proc output(input:(seq[set[char]],seq[set[char]])):int = 
    let fun = input[0].wireMapping
    var mul = 1
    for s in input[1].reversed:
        result += mul*fun(s)
        mul *= 10
    
echo ("input".parseInput --> map(output)).sum

            