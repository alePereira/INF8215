from priorityQueue import PriorityQueue
from state import State


class RushHour(object):
    
    def __init__(self):
        """
            definition de la grille
        """
        self.nbcars = 0
        self.color = []
        self.horiz = []
        self.len = []
        self.moveOn = []
        self.free = [[True] * 6 for _ in range(6)]

    def initFree(self, state):
        self.free = [[True] * 6 for _ in range(6)]
        for i in range(self.nbcars):
            if self.horiz[i]:
                x = self.moveOn[i]
                y = state.pos[i]
                for j in range(self.len[i]):
                    self.free[x][y+j] = False
            else:
                y = self.moveOn[i]
                x = state.pos[i]
                for j in range(self.len[i]):
                    self.free[x+j][y] = False

    def moves(self, state):
        self.initFree(state)
        l = []
        for i in range(self.nbcars):
            if self.horiz[i]:
                x = self.moveOn[i]
                y = state.pos[i]
                if y > 0 and self.free[x][y-1]:
                    l.append(State(state, i, -1))
                y += self.len[i] - 1
                if y < 5 and self.free[x][y+1]:
                    l.append(State(state, i, 1))
            else:
                y = self.moveOn[i]
                x = state.pos[i]
                if x > 0 and self.free[x-1][y]:
                    l.append(State(state, i, -1))
                x += self.len[i] - 1
                if x < 5 and self.free[x+1][y]:
                    l.append(State(state, i, 1))
        return l

    def solve(self,state):
        visited = set()
        visited.add(state)
        q = self.moves(state)
        while q:
            curr = q.pop(0)
            if curr.success():
                return curr
            nexts = self.moves(curr)
            for state in nexts:
                if not state in visited:
                    q.append(state)
                visited.add(state)
        print("Pas de solution")
        return None
    
    def solveAstar(self,state):
        visited = set()
        visited.add(state)
        q = PriorityQueue()
        # TODO
        print("Pas de solution")
        return None

    def printSolution(self,state):
        res = []
        if state is None:
            return
        while state.prev is not None:
            aux = "Voiture " + self.color[state.c] + " vers "
            if(self.horiz[state.c]):
                if state.d == 1:
                    aux += "la droite"
                else:
                    aux += "la gauche"
            else:
                if state.d == 1:
                    aux += "le bas"
                else:
                    aux += "le haut"
            res.append(aux)
            state = state.prev
        print(str(len(res)) + " mouvements")
        for string in res[::-1]:
            print(string)