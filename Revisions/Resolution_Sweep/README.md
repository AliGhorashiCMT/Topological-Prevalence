# Resolution and tolerance sweep

In this folder, we include calculations of the robustness of our statistics with respect to changing resolutions and atol, a tolerance parameter. The data is only for a dielectric contrast
of 16 (the middle dielectric contrast) and for plane groups 2, 10, 13, and 16, corresponding to two, four, three, and six=fold rotational symmetry, respectively. 

## Description of Julia files 

1. **`makejlds-atolsweep.jl`**: Makes .jld2 files corresponding to the different resolutions and tolerance parameters. Since we do not want to needlessly repeat our calculations for
   the resolution of 64x64, this script looks at the existing files in the **`./symeigs`** folder for the 64x64 resolution case. The script first creates a vector of dictionaries of symmetry
   eigenvalues, **`symeigsdv`**, where each element of this vector is the symmetry eigenvalue dictionary corresponding to a photonic crystal sample. The script next loops through this vector, for
   each atol value, and creates a summaries and cumsummaries for each value of the tolerance.
2. **`analyze_jlds.jl`**: Makes .jld2 files for stable/fragile topologies for atol=1e-2.
3. **`analyze_jlds-atolsweep.jl`**: Makes .jld2 files for stable/fragile topologies as a function of atol.
4. **`makejlds.jl`**: Makes .jld2 files for different resolutions at a fixed tolerance parameter, atol, of 1e-2.  
   
