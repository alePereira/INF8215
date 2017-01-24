
public class State {
	/*
	 * pos donne la position de la voiture i dans sa ligne ou colonne (premi�re
	 * case occup�e par la voiture)
	 */
	public int[] pos;

	/*
	 * c,d et prev premettent de retracer l'�tat pr�c�dent et le dernier
	 * mouvement effectu�
	 */
	public int c;
	static private RushHour rh;
	public int d;
	public State prev;
	/*
	 * � utiliser dans la deuxi�me partie, 
	 * n indique la distance entre l'�tat
	 * actuel et l'�tat initial, f le co�t de l'�tat actuel.
	 */
	public int n;
	public int f = 0;

	/*
	 * Contructeur d'un �tat initial (& recebem qualquer valor = lixo)
	 /
	public State(int[] p, RushHour rh) {
		n = 0;
		int tam = p.length;
		pos = new int[tam];
		for (int i = 0; i < tam; i++)
			pos[i] = p[i];
		prev = null;
		State.rh = rh;
	}

	/*
	 * constructeur d'un �tat � partir d'un �tat s et d'un mouvement (c,d)
	 */
	public State(State s, int c, int d) {
		// TODO
	}


	// this est il final?
	public boolean success() {
		// TODO
		return false;
	}

	/*
	 * Estimation du nombre de coup restants
	 */
	public int estimee1() {
		// TODO
		return 0;
	}

	public int estimee2() {
		// TODO
		return 0;
	}

	@Override
	public boolean equals(Object o) {
		State s = (State) o;
		if (s.pos.length != pos.length) {
			System.out.println("les �tats n'ont pas le m�me nombre de voitures");
		}
		int tamanho = pos.length;

		for (int i = 0; i < tamanho; i++)
			if (pos[i] != s.pos[i])
				return false;
		return true;
	}

	@Override
	public int hashCode() {
		int h = 0;
		for (int i = 0; i < pos.length; i++)
			h = 37 * h + pos[i];
		return h;
	}

	
}
