from priorityQueue import PriorityQueue
from state import State
import time


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

    def numberOfCarsBlocking(self, state):
        free = [[True] * 6 for _ in range(6)]
        for i in range(self.nbcars):
            if self.horiz[i]:
                x = self.moveOn[i]
                y = state.pos[i]
                for j in range(self.len[i]):
                    free[x][y+j] = False
            else:
                y = self.moveOn[i]
                x = state.pos[i]
                for j in range(self.len[i]):
                    free[x+j][y] = False
        return len([x for x in free[1][state.pos[0]+self.len[0]-1:] if not x])

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
        start = time.time()
        visited = set()
        visited.add(state)
        q = self.moves(state)
        while q:
            curr = q.pop(0)
            if curr.success():
                print("Nombre d'états visités : " + str(len(visited)))
                print("Temps écoulé : " + '%.3f' % (time.time() - start) + 's')
                return curr
            nexts = self.moves(curr)
            for s in nexts:
                if not s in visited:
                    q.append(s)
                visited.add(s)
        print("Pas de solution")
        return None
    
    def solveAstar(self,state):
        start = time.time()
        visited = set()
        visited.add(state)
        q = PriorityQueue()
        initialMoves = self.moves(state)
        for s in initialMoves:
            q.enqueue(s, s.f)
        while q:
            curr = q.dequeue()
            if curr.success():
                print("Nombre d'états visités : " + str(len(visited)))
                print("Temps écoulé : " + '%.3f' % (time.time() - start) + 's')
                return curr
            nexts = self.moves(curr)
            for s in nexts:
                if not s in visited:
                    q.enqueue(s, s.f)
                visited.add(s)
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

    def printAnimatedAsciiSolution(self, state):
        import sys 
        res = []
        if state is None:
            return
        while state.prev is not None:
            res.append(state)
            state = state.prev
        for s in res[:0:-1]:
            print(s)
            for i in range(7):
                sys.stdout.write("\033[F") # Cursor up one line
            time.sleep(0.33)
        print(res[0])