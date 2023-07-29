# Topological Prevalence

### Directory: Fig1_Lattice_Pdfs
### Contents: 
Pdf files of Fourier lattices with different spacegroup symmetries. The four additional sg 16 and sg 17 examples
(denoted Sg16-example-$i or Sg17-example-$i) are the lattices in figure 1 that serve to demonstrate the size of our dataset.
Note that the sg16 ones are not in the current version of the paper. 
### Directory: Fig2_Statistics_Figs
### Contents: 
Pdf files of the bar graphs used in figure 2
### Directory: Fig3_Statistics_Figs
### Contents: 
Pdf files of the bar graphs used in figure 3
### Directory: Sheets of Lattices
### Contents:
Pdf files of many examples of Fourier lattices- used in the supplementary to evince diversity of our dataset. For each spacegroup, 
sg, you'll find a pdf will file name sg$sg-sheets.pdf with 96 randomly sampled Fourier lattice examples (displayed in a 12x8 grid)
that were used in our data analysis.
### Directory: Sobol_Figs
### Contents:
Pdf files displaying comparisons of statistics aggregated from random Fourier lattice sampling and Sobol Fourier lattice sampling.
### Directory; Fillings_Figs
### Contents:
Pdf files displaying our statistics of photonic topology as a function of filling fraction, defined as $\Omega_{\varepsilon_{in}}/\Omega$, 
where $\Omega$ is the are of the unit cell and $\Omega_{\varepsilon_{in}}$ is the area of the 2D Fourier lattice with
$\varepsilon = \varepsilon_{in}$.
### Directory: Nodal_Point_Figs
### Contents: 
Figures displaying the the locations of nodal points within the Brillouin zone. 
### Directory: Tight Binding Models
### Contents:
Tight binding models for more tractable corner charge simulations (not used in the paper but more for sanity checking). 
### Directory: Time Reversal = False
MPB calculations of gyroelectric Fourier lattices in the presence of a magnetic field

---

### Relevant julia files: 
1. ./symeigs/wyckoffs_dict.jl : Enumerates the wyckoff positions for each space group that maintain C_n rotational symmetry
2. ./plotting_utilities.jl : Methods for plotting Fourier lattices at high resolution. One passes a Fourier lattice "flat" along with
   real space lattice vectors, "Rs" and either an isovalue "isoval" or filling "filling". If the keyword argument "in_polygon" is set to
   true, the lattice is only plotted within the cell "c", which may be a Wigner-Seitz cell, for instance.
3. ./plotting_supercells.jl : Methods for plotting a lattice composed of an interior Fourier lattice and an external cladding. This is relevant for
   our corner charge simulations.
4. ./makelattices.jl : Methods for creating Fourier lattices and input files for subsequent MPB calculations.

---

### Relevant CTL/SCM/Bash/SLURM files



