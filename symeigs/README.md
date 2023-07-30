# Brief Description of Files in this Folder

**make_input_jlds.jl** : This script puts the real space lattice vectors, **Rs** the fourier lattice parameters, **flat**, and the isovalues, **isoval** for each Fourier lattice in jld files (saved as vectors of lattice vectors, **Rsv**, ModulatedFourierLattice{2}s, **flatv** and isovalues, **isovalv**).

**corner_charges.jl** : This script includes all corner and polarization formulas. 

**analyze_jlds.jl** : This script saves the statistics that we find interesting

**runlattices-array-eps4and5.jl** and **runlattice-eps4and5.sh**: We originally ran calculations only for contrasts of 8, 12, and 16. Later on, we decided to accumulate statistics beyond this range. As such, we calculated symmetry data for contrasts of 24 and 32 as well. However, as we did not want to unnecessarily create additional input files (since the additional input files would have only had different values of $\varepsilon_{in}$, we wrote these two scripts to avoid doing so.

**analyze_fillings.jl**: This Julia file is for saving statistics as a function of filling fraction, $\Omega_{\varepsilon_{in}}/\Omega$. We define a vector, fillings_vec, of length 10000, with each element being a filling index (defined as the index of 0.2:0.05:0.8 which corresponds to the filling). We then look at the topologies of multiplets associated with Fourier lattices at given filling indices and save this data. 

**analyze_ebrs.jl**: This Julia file saves the EBR decompositions corresponding to nontrivial HOTI multiplets. We first define filtered_summaries, which is a 3 element vector. Each idx of the vector, is composed of cumsummaries for which the idx'th cumsummary is trivial, has nonzero corner charge and zero polarization for at least one wyckoff position. We then save the unique EBR decompositions in the field "unique_ebrs_dict" and we save the frequency that each unique EBR decomposition shows up in ebr_frequency_dict. 
