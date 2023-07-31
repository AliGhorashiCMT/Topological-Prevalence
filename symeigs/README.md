# Brief Description of Files in this Folder

**make_input_jlds.jl** : This script puts the real space lattice vectors, **Rs** the fourier lattice parameters, **flat**, and the isovalues, **isoval** for each Fourier lattice in jld files (saved as vectors of lattice vectors, **Rsv**, ModulatedFourierLattice{2}s, **flatv** and isovalues, **isovalv**).

**corner_charges.jl** : This script includes all corner and polarization formulas. 

**analyze_jlds.jl** : This script reproduces all statistics related to stable and fragile topology reported in the main text and the supplement. As input, the script takes the space group number, $sg, and reads in .jld2 files with the relevant band summaries (these are the same .jld2 files for which we have provided a Dropbox link in the main directory). Then, a single .jld2 file, with filename sg$sg-data.jld2, is written for each plane group with the following attendant fields: 

1. **trivial_count** : A vector for which each the element corresponding to an index, $n, is the number of samples with a trivial n'th multiplet 
3. **fragile_count** : Same as (1) but for fragile bands
4. **stable_count** : Same as (1) but for stably topological bands
5. **cum_trivial_count** : Same as (1) but replace n'th multiplet with n'th cumulative multiplet
6. **cum_fragile_count** : Same as (2) but replace n'th multiplet with n'th cumulative multiplet
7. **cum_stable_count** : Same as (3) but replace n'th multiplet with n'th cumulative multiplet

**analyze_corners.jl** : This script reproduces all statistics related to corner charge data as reported in the main text and supplement. For each plane group, $sg, the resulting data is saved in a .jld2 file with file name: sg$sg-corner-data.jld2. As input, this script takes the plane group number, $sg, and reads in the relevant band summaries from the .jld2 files linked in the main directory. It then saves three dictionaries in sg$sg-corner-data.jld2, **cum_corner_charges**, **cum_corner_charge_vals**, and **cum_corner_charge_num_bands**. The keys to each of these dictionaries is of the type **(sg, id_eps, mode, wp)**, where **id_eps** indexes the contrast and **wp** is a Wyckoff position. Thus, for instance, **cum_corner_charges** is a dictionary that reports, for a given centering choice at Wyckoff position, **wp**, how many samples we have with nonzero corner charge and no polarization. 

**runlattices-array-eps4and5.jl** and **runlattice-eps4and5.sh**: We originally ran calculations only for contrasts of 8, 12, and 16. Later on, we decided to accumulate statistics beyond this range. As such, we calculated symmetry data for contrasts of 24 and 32 as well. However, as we did not want to unnecessarily create additional input files (since the additional input files would have only had different values of $\varepsilon_{in}$, we wrote these two scripts to avoid doing so. 

**analyze_fillings.jl**: This Julia file is for saving statistics as a function of filling fraction, $\Omega_{\varepsilon_{in}}/\Omega$. We define a vector, fillings_vec, of length 10000, with each element being a filling index (defined as the index of 0.2:0.05:0.8 which corresponds to the filling). We then look at the topologies of multiplets associated with Fourier lattices at given filling indices and save this data. 

**analyze_ebrs.jl**: This Julia file saves the EBR decompositions corresponding to nontrivial HOTI multiplets. We first define filtered_summaries, which is a 3 element vector. Each idx of the vector, is composed of cumsummaries for which the idx'th cumsummary is trivial, has nonzero corner charge and zero polarization for at least one wyckoff position. We then save the unique EBR decompositions in the field "unique_ebrs_dict" and we save the frequency that each unique EBR decomposition shows up in ebr_frequency_dict. 
