# Brief Description of Files in this Folder

**make_input_jlds.jl** : This script puts the real space lattice vectors, **Rs** the fourier lattice parameters, **flat**, and the isovalues, **isoval** for each Fourier lattice in jld files (saved as vectors of lattice vectors, **Rsv**, ModulatedFourierLattice{2}s, **flatv** and isovalues, **isovalv**).

**corner_charges.jl** : This script includes all corner and polarization formulas. 

**analyze_jlds.jl** : This script saves the statistics that we find interesting

**runlattices-array-eps4and5.jl** and **runlattice-eps4and5.sh**: We originally ran calculations only for contrasts of 8, 12, and 16. Later on, we decided to accumulate statistics beyond this range. As such, we calculated symmetry data for contrasts of 24 and 32 as well. However, as we did not want to unnecessarily create additional input files (since the additional input files would have only had different values of $\varepsilon_{in}$, we wrote these two scripts to avoid doing so.
