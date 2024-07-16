## Corner charges for plane groups 10, 13, and 16: 

We use a dielectric contrast of `16` in all cases. Additional information:
1. For plane group 10, we use the same lattice, lattice `3797`, for both the bulk and the cladding (with a half a unit cell shift in both x and y directions for the cladding). Mode: TM
2. For plane group 13, we use lattices `3510` and `9000` for the bulk and the cladding, respectively. Mode: TE
3. For plane group 16, we use lattices `8080` and `275` for the bulk and the cladding, respectively. Mode: TE


### Derivation of the c6 Wigner-Seitz cell bounds

Since the lattice vectors of a c6 symmetric lattice are $(1, 0)$, $(-1/2, \sqrt{3}/2)$ in Cartesian coordinates, the Wigner-Seitz cell limits are $-\frac{1}{2} < x < \frac{1}{2}$ (horizontal limits) and two analogous limits obtained by rotating the previous limits by 60 and 120 degrees: $-\frac{1}{2} < \cos(60)*x + \sin(60)*y < \frac{1}{2}$, $-\frac{1}{2} < \cos(120)*x +\sin(120)*y < \frac{1}{2}$. Therefore, in cartesian coordinates, our limits are: 

1. $-\frac{1}{2} < x < \frac{1}{2}$
2. $-\frac{1}{2} < \frac{x}{2}+\frac{\sqrt{3}y}{2} < \frac{1}{2}$
3. $-\frac{1}{2} < -\frac{x}{2}+\frac{\sqrt{3}y}{2} < \frac{1}{2}$

Substituting $(x, y) \rightarrow (x-\frac{y}{2}, \frac{\sqrt{3}y}{2})$ (in order to write everything in terms of lattice coordinates), we obtain: 
1. $-1 < 2x-y < 1$
2. $-1 < x+y < 1$
3. $-1 < 2y-x < 1$

### Derivation of the c3 supercell bounds

The lattice vectors of a c3 symmetric lattice are, just as for the c6 symmetric lattice, $(1, 0)$, $(-1/2, \sqrt{3}/2)$ in Cartesian coordinates. 

Take one of the vertices to be at $(0, c/\sqrt{3})$. Then the two other vertices are located at (by 120 and -120 degree rotations of the first vertex) $(\pm c/2, -c/(2\sqrt{3}))$

Therefore, the bounds are (in Cartesian coordinates) 

1. $y > -c/(2\sqrt{3})$
2. $y < -\sqrt(3)x + c/\sqrt{3}$
3. $y < \sqrt{3}x  + c/\sqrt{3}$

Transforming to lattice coordinates $(x, y) \rightarrow (x-\frac{y}{2}, \frac{\sqrt{3}y}{2})$ , we obtain

1.  $y+c/3 > 0$
2.  $c/3 - x > 0$
3.  $x - y + c/3 > 0$
