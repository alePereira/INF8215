import priorityQueue

class RushHour(object):
    
    def __init__(self):
        """
            definition de la grille
        """

        self.nbcars = 0
        self.color = []
        self.horiz = []
        self.len = []
        self.moveon = []
        self.free = [[False] * 6 for _ in range(6)]

    def initFree(self, state):
        # TODO


    def moves(self, state):
        initFree(state)
        l = []
        # TODO
        return l

    def solve(self,state):
        visited = [state]
        q = []
        # TODO
        print("pas de solution")
        return None
    
    def solveAstar(self,state):
        visited = [state]
        q = priorityQueue.PriorityQueue()
        # TODO
        print("pas de solution")
        return None


    def printSolution(self,state):
        # TODO

        

