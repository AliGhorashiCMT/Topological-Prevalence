# Analysis of Dirac points isolated in frequency 

Here, we investigate the prevalence of nodal points that are frequency isolated.

## Description of relevant files:

1. **`Lightline.ipynb`**: Here we check how often isolated Dirac points lie below the lightline.
2. **`run_vacuum_sanity_check.jl`**: Explicit MPB calculations of the vacuum to make sure our lightline is correct. We simply supply the k index corresponding to the Dirac point,
   the lattice parameters (important for plane group 2 which has variable lattice vectors) and change the variable epsin to 1.
3. **`Zoom_in.ipynb`**: Zoomed in dispersions around Dirac points (calculated with the functionality shown in fourier-lattice-zoom-in.ctl) 
