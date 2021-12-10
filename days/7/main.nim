#median
import std/[math,algorithm,strutils,sequtils]
var input = "input".open.readLine.split(',').map(parseInt)
input.sort()
echo "median is between",input[499]# 499 less, 500 greater, " and ", input[500]#
echo "and ", input[500] #500 less, 499 greater 
echo input.len
let median = 333

##how much petrol
proc distance(s:seq[int],n:int):int = 
    for i in s:
        result.inc abs(i-n)#sum(collect(for i in s:


echo distance(input,333)

#proc fuel(distance:int):int = 
    #1->1
    #2->1+2
    #3->1+2+3 triangular numbers = n*(n+1)/2
    #we minimize sum(abs( (x-u)*(x-u+1)/2))

proc distance2(s:seq[int],n:int):int = 
    for i in s:
        result.inc (abs(i-n)*(abs(i-n)+1) div 2)
#x*(x+1) = x^2 + x
#(i-n)^2 + abs(i-n) div 2
#minimize sum of that.
var max = int.low
var min = int.high
for i in input:
    if i>max:
        max = i
    if i<min:
        min = i
echo "min:",min,"max:",max

var mindist = int.high
var min_n = -1
for n in 0..1935:
    let d = distance2(input,n)
    if d < mindist:
        mindist = d
        min_n = n
        echo "mindist:",d,"min_n",n
echo sum(input)
#because if you increase them all by one
#