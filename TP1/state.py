class State(object):

    def __init__(self, state=None, c=0, d=0, p=None, rhInstance=None):

        """
            Définition de l'état initial
        """
        if state is None:
            self.n = 0
            self.pos = p[:]
            self.prev = None
            self.rh = rhInstance
        else:
            self.prev = state
            self.pos = state.pos[:]
            self.rh = state.rh

        self.c = c
        self.d = d
        self.pos[c] += d

        """
            A utiliser dans la deuxième partie, 
            n indique la distance entre l'état
            actuel et l'état initial, f le coût de l'état actuel.
        """
        self.n = 0
        self.f = 0

    def success(self):
        return self.pos[0] == 4

    def estimee1(self):
        # TODO
        return 0

    def estimee2(self):
        # TODO
        return 0

    def __eq__(self, other):
        if other is None:
            return False
        if len(self.pos) != len(other.pos):
            print("Les états n'ont pas le même nombre de voitures")

        return self.pos == other.pos

    def __hash__(self):
        h = 0
        for value in self.pos:
            h = 37 * h + value
        return h

    def __repr__(self):
        res = [['.' for i in range(6)] for j in range(6)]
        for i in range(self.rh.nbcars):
            if self.rh.horiz[i]:
                x = self.rh.moveOn[i]
                y = self.pos[i]
                for j in range(self.rh.len[i]):
                    res[x][y+j] = str(i)
            else:
                y = self.rh.moveOn[i]
                x = self.pos[i]
                for j in range(self.rh.len[i]):
                    res[x+j][y] = str(i)

        return ''.join([''.join(res[i]+["\n"]) for i in range(6)])


# Test code
if __name__ == '__main__':

    class RushHour(object):
        def __init__(self):
            self.nbcars = 8
            self.horiz = [True, True, False, False, True, True, False, False]
            self.len = [2, 2, 3, 2, 3, 2, 3, 3 ]
            self.moveOn = [2, 0, 0, 0, 5, 4, 5, 3 ]
            

    
    s = State(p=[1, 0, 1, 4, 2, 4, 0, 1], rhInstance=RushHour())
    print(s)