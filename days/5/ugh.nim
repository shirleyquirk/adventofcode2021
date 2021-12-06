proc gcd(x,y:int):int =
    ## euclidean alg
    ## does this work with negative numbers?
    ## is this the right kind of mod? ugh.
    var big,small:int
    #if (x > y):
    #    big = x
    #    small = y
    #else:
    #    big = y
    #    small = x
    big = x
    small = y
    while small != 0:
        (big,small) = (small,big mod small)
    return big

for x in [-12,-7,-6,-3,-1,0,1,3,6,7,12]:
    for y in [-12,-7,-6,-3,-1,0,1,3,6,7,12]:
        echo "gcd of ",x,",",y," = ",gcd(x,y)
