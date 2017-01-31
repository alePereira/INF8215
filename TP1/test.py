from state import State
from rushHour import RushHour

def allTest(solveType=0):
    print("*******Test 1 : ******")
    test1()
    print("\n*******Test 2 : ******")
    test2()
    print("\n*******Test 3 : ******")
    test3()
    print("\n*******Test 4 : ******")
    test4()
    print("\n*******Solve 22 : ******")
    solve22(solveType)
    print("\n*******Solve 1 : ******")
    solve1(solveType)
    print("\n*******Solve 40 : ******")
    solve40(solveType)
    print("\n*******Solve A* : ******")
    solveAstar()

def allTestAnalyze():
    print("\n*******Solve 22 : ******")
    for i in range(4):
        solve22(i, True)
    print("\n*******Solve 1 : ******")
    for i in range(4):
        solve1(i, True)
    print("\n*******Solve 40 : ******")
    for i in range(4):
        solve40(i, True)

def test1():
    positionning = [1, 0, 1, 4, 2, 4, 0, 1]

    s0 = State(p=positionning)
    b = not s0.success()

    print(b)

    s = State(s0, 1, 1)

    print(s.prev == s0)
    b = b and s.prev == s0
    print(str(s0.pos[1]) + " " + str(s.pos[1]))

    s = State(s, 6, 1)
    s = State(s, 1, -1)
    s = State(s, 6, -1)

    print(s==s0)
    b = b and s==s0
    s = State(s0, 1, 1)
    s = State(s, 2, -1)
    s = State(s, 3, -1)
    s = State(s, 4, -1)
    s = State(s, 4, -1)
    s = State(s, 5, -1)
    s = State(s, 5, -1)
    s = State(s, 5, -1)
    s = State(s, 6, 1)
    s = State(s, 6, 1)
    s = State(s, 6, 1)
    s = State(s, 7, 1)
    s = State(s, 7, 1)
    s = State(s, 0, 1)
    s = State(s, 0, 1)
    s = State(s, 0, 1)
    b = b and s.success()
    print(s.success())
    if (not b):
        print("mauvais résultat")


def test2():
    res = [[ False, False, True, True, True, False ], [ False, True, True, False, True, False ],
            [ False, False, False, False, True, False ], [ False, True, True, False, True, True ],
            [ False, True, True, True, False, False ], [ False, True, False, False, False, True ]]
    rh = RushHour()
    rh.nbcars = 8
    rh.horiz = [True, True, False, False, True, True, False, False]
    rh.len = [2, 2, 3, 2, 3, 2, 3, 3 ]
    rh.moveOn = [2, 0, 0, 0, 5, 4, 5, 3 ]
    s = State(p=[1, 0, 1, 4, 2, 4, 0, 1], rhInstance=rh)
    rh.initFree(s)
    b = True
    for i in range(6):
        for j in range(6):
            print(str(rh.free[i][j]) + "\t", end="")
            b == b and (rh.free[i][j] == res[i][j])
        print("")

    if b:
        print("résultat correct")
    else:
        print("mauvais résultat")

def test3():
    rh = RushHour()
    rh.nbcars = 12
    rh.horiz = [ True, False, True, False, False, True, False, True, False, True, False, True ]
    rh.len = [2, 2, 3, 2, 3, 2, 2, 2, 2, 2, 2, 3]
    rh.moveOn = [2, 2, 0, 0, 3, 1, 1, 3, 0, 4, 5, 5]
    s =  State(p=[1, 0, 3, 1, 1, 4, 3, 4, 4, 2, 4, 1 ], rhInstance=rh)
    s2 = State(p=[1, 0, 3, 1, 1, 4, 3, 4, 4, 2, 4, 2 ], rhInstance=rh)
    print(len(rh.moves(s)))
    print(len(rh.moves(s2)))


def test4():
    rh = RushHour()
    rh.nbcars = 12
    rh.color = ["rouge", "vert clair", "jaune", "orange", "violet clair", "bleu ciel", "rose",
            "violet", "vert", "noir", "beige", "bleu" ]
    rh.horiz = [True, False, True, False, False, True, False, True, False, True, False, True ]
    rh.len = [2, 2, 3, 2, 3, 2, 2, 2, 2, 2, 2, 3]
    rh.moveOn = [2, 2, 0, 0, 3, 1, 1, 3, 0, 4, 5, 5 ]
    s =  State(p = [1, 0, 3, 1, 1, 4, 3, 4, 4, 2, 4, 1], rhInstance=rh)
    n = 0
    s = rh.solve(s)
    if s is None:
        return
    while(s.prev != None):
        n+=1
        s = s.prev
    print(n)

def solve22(solveType=0, onlyMovements=False):
    rh = RushHour(solveType=solveType)
    rh.nbcars = 12
    rh.color = ["rouge", "vert clair", "jaune", "orange", "violet clair", "bleu ciel", "rose",
            "violet", "vert", "noir", "beige", "bleu" ]
    rh.horiz = [ True, False, True, False, False, True, False, True, False, True, False, True ]
    rh.len = [ 2, 2, 3, 2, 3, 2, 2, 2, 2, 2, 2, 3 ]
    rh.moveOn = [ 2, 2, 0, 0, 3, 1, 1, 3, 0, 4, 5, 5 ]
    s = State(p=[1, 0, 3, 1, 1, 4, 3, 4, 4, 2, 4, 1 ], rhInstance=rh)

    solving(s, solveType, onlyMovements)


def solve1(solveType=0, onlyMovements=False):
    rh = RushHour(solveType=solveType)
    rh.nbcars = 8
    rh.color = ["rouge", "vert clair", "violet", "orange", "vert", "bleu ciel", "jaune", "bleu" ]
    rh.horiz = [ True, True, False, False, True, True, False, False ]
    rh.len =[ 2, 2, 3, 2, 3, 2, 3, 3 ]
    rh.moveOn = [ 2, 0, 0, 0, 5, 4, 5, 3 ]
    s = State(p=[ 1, 0, 1, 4, 2, 4, 0, 1 ], rhInstance=rh)

    solving(s, solveType, onlyMovements)

def solve40(solveType=0, onlyMovements=False):
    rh = RushHour(solveType=solveType)
    rh.nbcars = 13
    rh.color = [ "rouge", "jaune", "vert clair", "orange", "bleu clair", "rose", "violet clair",
            "bleu", "violet", "vert", "noir", "beige", "jaune clair" ]
    rh.horiz = [ True, False, True, False, False, False, False, True, False, False, True, True,
            True ]
    rh.len =  [ 2, 3, 2, 2, 2, 2, 3, 3, 2, 2, 2, 2, 2 ]
    rh.moveOn =  [ 2, 0, 0, 4, 1, 2, 5, 3, 3, 2, 4, 5, 5 ]
    s = State(p=[ 3, 0, 1, 0, 1, 1, 1, 0, 3, 4, 4, 0, 3 ], rhInstance=rh)

    solving(s, solveType, onlyMovements)

   

def solving(s, solveType=0, onlyMovements=False):
    if solveType == 0:
        print("Recherche en largeur")
        s = s.rh.solve(s)
    else:
        if(solveType == 1):
            print("\nRecherche en profondeur")
        elif(solveType == 2):
            print("\nRecherche heuristique 1")
        else:
            print("\nRecherche heuristique 2")
        s = s.rh.solveAstar(s)

    s.rh.printSolution(s,onlyMovements)

def solveAstar():
    rh = RushHour()
    rh.nbcars = 12
    rh.color = [ "rouge", "vert clair", "jaune", "orange", "violet clair", "bleu ciel", "rose",
            "violet", "vert", "noir", "beige", "bleu" ]
    rh.horiz = [ True, False, True, False, False, True, False, True, False, True, False, True ]
    rh.len = [ 2, 2, 3, 2, 3, 2, 2, 2, 2, 2, 2, 3 ]
    rh.moveOn = [ 2, 2, 0, 0, 3, 1, 1, 3, 0, 4, 5, 5 ]
    s = State(p=[ 1, 0, 3, 1, 1, 4, 3, 4, 4, 2, 4, 1 ], rhInstance=rh)
    s = rh.solveAstar(s)
    rh.printSolution(s)

# Test code
if __name__ == '__main__':

    import sys

    if len(sys.argv) == 1:
        allTest()

    else:
        if sys.argv[1] == '1':
            print("*******Test 1 : ******")
            test1()
        elif sys.argv[1] == '2':
            print("*******Test 2 : ******")
            test2()
        elif sys.argv[1] == '3':
            print("*******Test 3 : ******")
            test3()
        elif sys.argv[1] == '4':
            print("*******Test 4 : ******")
            test4()
        elif sys.argv[1] == '5':
            print("*******Solve 22 : ******")
            solve22()
        elif sys.argv[1] == '6':
            print("*******Solve 1 : ******")
            solve1()
        elif sys.argv[1] == '7':
            print("*******Solve 40 : ******")
            solve40()
        elif sys.argv[1] == '8':
            solveAstar()
            print("*******Solve A* : ******")
        else:
            allTestAnalyze()