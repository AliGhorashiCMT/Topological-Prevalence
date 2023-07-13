# Derivation of the c6 Wigner-Seitz cell bounds

Since the lattice vectors of a c6 symmetric lattice are $(1, 0)$, $(-1/2, \sqrt{3}/2)$ in Cartesian coordinates, the Wigner-Seitz cell limits are $-\frac{1}{2} < x < \frac{1}{2}$ (horizontal limits) and two analogous limits obtained by rotating the previous limits by 60 and 120 degrees: $-\frac{1}{2} < \cos(60)*x + \sin(60)*y < \frac{1}{2}$, $-\frac{1}{2} < \cos(120)*x +\sin(120)*y < \frac{1}{2}$. Therefore, in cartesian coordinates, our limits are: 

1. $-\frac{1}{2} < x < \frac{1}{2}$
2. $-\frac{1}{2} < \frac{x}{2}+\frac{\sqrt{3}y}{2} < \frac{1}{2}$
3. $-\frac{1}{2} < -\frac{x}{2}+\frac{\sqrt{3}y}{2} < \frac{1}{2}$

Substituting $(x, y) \rightarrow (x-\frac{y}{2}, \frac{\sqrt{3}y}{2})$ (in order to write everything in terms of lattice coordinates), we obtain: 
1. $-1 < 2x-y < 1$
2. $-1 < x+y < 1$
3. $-1 < 2y-x < 1$

# Derivation of the c3 supercell bounds

The lattice vectors of a c3 symmetric lattice are, just as for the c6 symmetric lattice, $(1, 0)$, $(-1/2, \sqrt{3}/2)$ in Cartesian coordinates. 

Take one of the vertices to be at $(0, \sqrt{3}c)$. Then the two other vertices are located at (by 120 and -120 degree rotations of the first vertex) $(\pm 3/2, -\sqrt{3}/2)$
