import std/[sequtils,setutils,sugar,strformat,macros,genasts]
when false:
    let digits = ["abcefg","cf","acdeg","acdfg","bcdf","abdfg","abdefg","acf","abcdefg","abcdfg"].mapit(it.toSet)
    #cho digits
    #
    template mapToSegments(x:openArray[int]):untyped = x.mapIt((it,digits[it]))
    let fives = [2,3,5].mapToSegments
    let sixes = [0,6,9].mapToSegments
    let knowns = [1,4,7].mapToSegments # 8 is completely uninteresting in terms of comparisons
    proc intersection(a,b:set[char]):int = card(a*b)
    proc diff(a,b:set[char]):(int,int) = (card(a-b),card(b-a))
    block:
        let s = {'a','b','c'}
        dumpTree:
            template a:untyped =
                if 'a' in s:
                    '_'
                else:
                    ' '
    proc `$`(s:set[char]):string = 
        macro genDigits:untyped =    
            result = nnkStmtList.newNimNode()
            for c in "abcdefg":
                let markChar = if c in {'a','d','g'}: '_' else: '|'
                let body = genast(c_as_char=newLit(c),markChar) do:
                    if c_as_char in s:
                        markChar
                    else:
                        ' '
                result.add newProc(ident($c),params=[ident"untyped"],body=body,procType=nnkTemplateDef)
            echo result.treeRepr
            
        genDigits()
        result = &""" {a} 
    {b}{d}{c}
    {e}{g}{f}"""  


    for f_int,f_set in fives.items:
        for k_int,k_set in knowns.items:
            echo &"{f_int}*{k_int}=\n{f_set*k_set}"
        



#echo typeof x
#template helper(body:untyped):type = array[min(mapCard(body))..max(mapCard(body)),int]
#var x: array[min(mapCard(it*digits[4]))..max(mapCard(it*digits[4])),int]
#echo typeof x
#works
#type XXX = array[cardRange,array[fourRange,array[oneRange,int]]]

#type Z = helper(it*digits[4])
#var y:Z
#echo typeof Z
#type
    #CardRange = array[min(digits.mapIt(card(it*digits[4]))) .. max(digits.mapIt(card(it*digits[4]))),int]
    #BardRange = array[foo(it*digits[4]),int]

#echo foo[int](it.digits[4])
#echo typeof BardRange

