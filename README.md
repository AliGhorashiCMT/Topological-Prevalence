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
5. **`./Sobol Fourier Lattices.ipynb`**: Methods for creating Fourier lattices sampled from a Sobol space-filling sequence. Used to validate the diversity of
   our main text results.
6. **`./Corner Charge Tables and Sanity Checks.ipynb`**: Sanity checks of our polarization and corner charge formulas.
7. **`./symeigs_from_io.jl`,`./get-freqs-symeigs.jl`:** Functionality for obtaining symmetry eigenvalues and frequencies from MPB log files. The first Julia file
   includes an extension of **`_read_symdata`**, an **`MPBUtils`** method for creating a dictionary of symmetry eigenvalues. The MPBUtils version depends on a particular
   way of storing the data in files appended by **`-dispersion.out`** and **`-symeigs.out`** extensions, so we include an extension of it that can just get the full log
   file output.
8. **`Resolution_Sweep.jl`**: Analysis of the dependence of our statistics on MPB spatial resolution and the internal tolerance parameter in our code, atol. The resolution is sweeped up to
   256x256 and the tolerance parameter is sweeped from 1e-2 to 1e-1. The tables in the notebook are given for worst case scenarios, for plane groups p3 and p6. 


## Relevant CTL/SCM/Bash/SLURM files
TODO.

## Data files (.jld2)
We have included .jld2 files with the necessary input file data for each plane group, sg, in `./symeigs/output/sg$sg/eps1/te/`
(note that for all other dielectric contrasts and the TM mode input files, the only difference is the value of `epsin`).
To load the data, launch Julia and execute the following code:
```jl
using JLD2
data = load(./symeigs/output/sg$sg/eps1/te/sg$sg-epsid1-res64-te-input.jld2)
```
`data` will then contain three fields `Rsv`, `flatv` and `isovalv`, each a 10000 element vector:
- `Rsv` is a vector of lattice vectors. Note that for every plane groups except for p2, p6, and c2mm, each element of `Rsv` will be the same, due to symmetry restrictions.
- `flatv` is a vector of elements of type `ModulatedFourierLattice{2}`. Each `ModulatedFourierLattice` object has fields `orbits` and `orbitcoefs`. `orbits` are the 
reciprocal lattice vectors **G** and `orbitcoefs` the corresponding Fourier basis coefficients.
- `isovalv` is a vector of isovalues (which determine the filling fraction of the Fourier lattice). 
`plotting_utilities.jl` includes tools to plot the Fourier lattices from `Rsv`, `flatv` and `isovalv`.

We host the results for each of these inputs as a series of .jld2 files on [Dropbox](https://www.dropbox.com/sh/ie9ddihefkhlyqp/AACeS1_czQ_Mlje_JRS1lv1Ca?dl=0).
Each .jld2 file contains the results for a specific to plane group, `$sg`, `polarization`, `$mode`, and contrast indexed by `$epsid` has a file name of the format: `sg$sg-epsid$epsid-res64-$mode.jld2` `$epsid` of 1, 2, 3, 4, 5 corresponds to contrasts of 8, 12, 16, 24, and 32, respectively.
After loading the .jld2 file, the relevant quantities are in the fields `summariesv` and `cumsummariesv`. The former has multiplet-by-multiplet data and the latter has cumulative multiplet data. Each are 10000 element vectors (stored in the same order as the lattices in the input .jld2 files). Each element of `summariesv` is an object of type `Vector{BandSummary}`. Each `BandSummary` object is a "summary" of pertinent data corresponding to a particular multiplet. In particular, one can access a field, `bar`, of each `BandSummary` object, `foo`, via `foo.bar`.
Some fields of particular interest are `topology`, `n`- the symmetry vector and `brs`, the table of elementary band representations. From this data, all higher-order topology data may be derived (via the script in `./symeigs/corner-charges.jl`). 







