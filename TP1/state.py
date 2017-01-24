
class State(object):

    def __init__(self, state=None, c=0, d=0, p=None, rhInstance=None):

        """
            Définition de l'état initial
        """
        if state is None:
            self.n = 0
            self.pos = p[:]
            self.prev = 0
            self.rh = rhInstance
        else:
            self.prev = state
            self.pos = state.pos[:]
            self.rh = state.rh

        self.c = c
        self.d = d

        """
            A utiliser dans la deuxième partie, 
            n indique la distance entre l'état
            actuel et l'état initial, f le coût de l'état actuel.
        """
        self.n = 0
        self.f = 0

    def success(self):
        # TODO
        return False

    def estimee1(self):
        # TODO
        return 0

    def estimee2(self):
        # TODO
        return 0

    def __eq__(self, other):
        if len(self.pos) != len(other.pos):
            print("Les états n'ont pas le même nombre de voitures")

        return self.pos == other.pos

    def __hash__(self):
        h = 0
        for value in pos:
            h = 37 * h + value
        return h
