# Description of Relevant Files and Folders

**makejlds.jl**: Makes JLD2 files with, in addition to **cumsummariesv** (described in the symeigs folder), **marginsv** and **dispersionsv**. **dispersionsv**
is a vector of dispersions (along high symmetry lines). Thus each element of **dispersionsv** is a band dispersion. **marginsv** is a vector of margins, which
we now define. The margin between two bands, a bottom band, bottom_band, and a top band, top_band, is defined as their minimum frequency difference (not only k-wise) 
divided by their mean. 
