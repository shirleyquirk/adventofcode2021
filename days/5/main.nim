import std/[parseutils,sequtils,sugar,tables]

type 
    VentLine = object
      x1,y1,x2,y2:int
    Point = object
        x,y:int
    Slope = object
        dx,dy:int
proc parseLine(line:string):VentLine =
    var idx = 0
    idx += line.parseInt(result.x1,idx)
    idx += line.skipWhile({','},idx)
    idx += line.parseInt(result.y1,idx)
    idx += line.skipWhile({' ','-','>'},idx)
    idx += line.parseInt(result.x2,idx)
    idx += line.skipWhile({','},idx)
    idx += line.parseInt(result.y2,idx)

proc parseInput(filename:string):seq[VentLine] =
    for line in filename.lines:
        result.add line.parseLine
proc gcd(x,y:int):int =
    if x==0 and y==0: return 1
    var (a,b) = (abs(x),abs(y))#if x > y: (x,y) else: (y,x)
    while b != 0:
        (a,b) = (b,a mod b)
    return a
proc `-`(p,q:Point):Slope =
    let dx = p.x - q.x
    let dy = p.y - q.y
    let gcd = gcd(dx,dy)
    result.dx = dx div gcd
    result.dy = dy div gcd
proc `+=`(p:var Point,dp:Slope) = 
    p.x += dp.dx
    p.y += dp.dy
proc `==`(p,q:Point):bool =
    p.x == q.x and p.y == q.y

iterator points(l:VentLine):Point =
    var p = Point(x: l.x1, y: l.y1)
    let dst = Point(x: l.x2, y: l.y2)
    let slp = dst - p
    yield p
    while p != dst:
        p += slp
        yield p
    
proc q1(filename:string):int =
    let straightlines = filename.parseInput.filterIt(it.x1==it.x2 or it.y1==it.y2)
    ## find the number of points where two lines overlap
    var points:CountTable[Point]
    for line in straightlines:
        for pt in line.points:
            points.inc pt
    for p in points.values:
        if p > 1:
            inc result

assert q1("test") == 5
echo q1("input")

proc q2(filename:string):int =
    let straightlines = filename.parseInput#.filterIt(it.x1==it.x2 or it.y1==it.y2)
    ## find the number of points where two lines overlap
    var points:CountTable[Point]
    for line in straightlines:
        for pt in line.points:
            points.inc pt
    for p in points.values:
        if p > 1:
            inc result

assert q2("test") == 12
echo q2("input")