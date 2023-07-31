# Code and data repository

This repository is accompaniment to the preprint
> Ali Ghorashi, Sachin Vaidya, Mikael Rechtsman, Wladimir Benalcazar, Marin Soljačić, Thomas Christensen, *"Prevalence of two-dimensional photonic topology,"* [arXiv:2307.15701 (2023)](https://arxiv.org/abs/2307.15701).

## File structure and repository content

A brief description of certain especially relevant directories is included below:
- **`Fig1_Lattice_Pdfs`:** .pdf files of Fourier lattices with different plane group symmetries.
The four additional examples from plane groups 16 and 17 (`Sg16-example-$i` or `Sg17-example-$i`) are the "repeated" lattices in Figure 1 that serve to demonstrate the size of our data set (the plane group 16 examples predate the preprint version of the figure).
- **`Fig2_Statistics_Figs`:** .pdf files of the bar graphs used in Figure 2.
- **`Fig3_Statistics_Figs`:** .pdf files of the bar graphs used in Figure 3.
- **`Sheets_of_Lattices`:** .pdf files of many examples of Fourier lattices- used in the supplementary to illustrate the diversity of our data set.
For each plane group, `sg`, a .pdf file with named `sg$sg-sheets.pdf` is included, illustrating 96 randomly selected Fourier lattice examples from a data set(displayed in a 12x8 grid).
- **`Sobol_Figs`:** .pdf files displaying comparisons of statistics aggregated from random Fourier lattice sampling and Sobol Fourier lattice sampling.
- **`Fillings_Figs`:** .pdf files displaying our statistics of photonic topology as a function of filling fraction, defined as $\Omega_{\text{in}}/\Omega$, where $\Omega$ is the are of the unit cell and $\Omega_{\text{in}}$ is the area of the 2D Fourier lattice with $\varepsilon = \varepsilon_{\text{in}}$.
- **`Nodal_Point_Figs`:** Figures displaying the the locations of nodal points within the Brillouin zone. 
- **`Tight Binding Models`:** Tight binding models for more tractable corner charge simulations (not used in the paper but more for sanity checking).
- **`Time Reversal = False`:** MPB calculations of gyroelectric Fourier lattices in the presence of a magnetic field.

Apart from this, we highlight a selection of other especially relevant Julia files, used mainly for data-processing and illustration:
1. **`./symeigs/wyckoffs_dict.jl`:** Enumerates the Wyckoff positions for each space group that maintain $C_n$ rotational symmetry
2. **`./plotting_utilities.jl`:** Methods for plotting Fourier lattices at high resolution. One passes a Fourier lattice `flat` along with
   real space lattice vectors, `Rs` and either an isovalue `isoval` or filling `filling`. If the keyword argument `in_polygon` is set to
   true, the lattice is only plotted within the cell `c`, which may be a Wigner-Seitz cell, for instance.
3. **`./plotting_supercells.jl`:** Methods for plotting a lattice composed of an interior Fourier lattice and an external cladding. This is relevant for
   our corner charge simulations.
4. **`./makelattices.jl`:** Methods for creating Fourier lattices and input files for subsequent MPB calculations.
5. **./Sobol Fourier Lattices.ipynb**: Methods for creating Fourier lattices sampled from a Sobol space-filling sequence. Used to validate the diversity of
   our main text results.
6. **./Corner Charge Tables and Sanity Checks.ipynb**: Sanity checks of our polarization and corner charge formulas. 


## Relevant CTL/SCM/Bash/SLURM files
TODO.

## Data files (.jld2)
We have included .jld2 files with the necessary input file data for each plane group, sg, in `./symeigs/output/sg$sg/eps1/te/`
(note that for all other dielectric contrasts and the TM mode input files, the only difference is the value of `epsin`). 
To map the data stored in the .jld2 files to a Fourier lattice, simply `load(./symeigs/output/sg$sg/eps1/te/sg$sg-epsid1-res64-te-input.jld2)`. 
This will give an object with three fields: `Rsv`, `flatv` and `isovalv`, each of which is a 10000 element vector. `Rsv` is a vector of 
lattice vectors. Note that for every plane groups except for p2, p6, and c2mm, each element of `Rsv` will be the same, due to symmetry restrictions.
`flatv` is a vector of elements of type `ModulatedFourierLattice{2}`. Each `ModulatedFourierLattice` object has fields `orbits` and `orbitcoefs`. `orbits` are the 
reciprocal lattice vectors **G** and `orbitcoefs` the corresponding Fourier basis coefficients. `isovalv` is a vector of isovalues (which determine the
filling fraction of the Fourier lattice). 
`plotting_utilities.jl` includes tools to plot the Fourier lattices from `Rsv`, `flatv` and `isovalv`.

For .jld2 files with processed data, we include here a publicly accessible Dropbox link (due to Github repo size restrictions): https://www.dropbox.com/sh/ie9ddihefkhlyqp/AACeS1_czQ_Mlje_JRS1lv1Ca?dl=0







