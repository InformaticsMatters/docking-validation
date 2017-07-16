The SD files are UNIX plain text, despite this being contained in a Windows ZIP file 
(sorry to UNIX fans, but only ZIP is supported by JCICS).  The structure in the SD file 
should supersede that in the PDF tables if there is a disagreement.

All the structural optimisations described below were not necessary for the classification 
work described in the manuscript "Spline-Fitting with a Genetic Algorithm: a Method for 
Developing Classification Structure-Activity Relationships."  If 2D models are 
preferable, these are available from the authors.  Note however that Cerius2 and Sybyl do 
not parse the stereochemical information when converting 2D SD structures to 3D 
structures: you may not want 2D structures if you plan on converting them to 3D 
structures later.

The 3D structures were obtained from 2D ChemDraw sketches by using the "Clean up 
structure" function of Chem3D Ultra version 6.0.  The 3D structures were further
refined using energy minimisation of MMFF94s + GBSA implicit solvent in Macromodel (default 
parameters).  For some series, compounds have been suitably aligned for use in 3D 
QSAR:

COX2: A Monte Carlo conformation search was carried out for 8-celecoxib using 
MMFF94s + GBSA and the MCMM routine in Macromodel (500 trial moves, other 
parameters defaults). 8-celecoxib was superimposed on the inhibitor SC558 in the PDB 
structure 1CX2.  Note however that the inhibitors were not docked into the protein, but 
merely aligned in the active site to allow comparison of 3D QSAR results with the 
protein structure.  In particular, the phenyl-SO2-X torsion determined by conformational 
searching is not the same as that in the crystal structure 1CX2.  The other inhibitors were 
superimposed on 8-celecoxib using three atoms on each of the three rings.  Substituents 
were placed in a consistent fashion.  For example, substituents R2 on the second vicinal 
ring (referring to the family A.1 in the PDF tables of structures) were always placed away 
from the first vicinal ring.  The energy difference is very small between that orientation, 
and another in which the phenyl ring has been rotated by 180 deg. about its torsion.  As 
such, if one were to have no protein structure to aid in the alignment, it is best to be 
consistent as opposed to always choosing the global energy minimum.  In cases where 
substituents are large and contain many rotatable bonds, no effort was made to place all 
torsions in a consistent way.  These would probably not be included in 3D QSAR work 
using these sets.

BZR: All ligands from the A.x family, except A.9-A.11 have been aligned onto 
Diazepam, which was subjected to the same MCMM optimisation described for 8-
celecoxib.  As discussed in Adv. Drug Res. 1985, 14, 165-322, there are two low-energy 
ring conformations for Diazepam.  Ring conformation "a" in figure 10 of the above 
reference was used, as it is the bioactive conformation.  As for the COX-2 inhibitors, 
substituents were placed in a consistent fashion.  Substituents on the rotatable phenyl ring 
of Diazepam were placed on the edge nearest the fused ring structure (i.e. the "left" edge 
when depicted in the orientation given for A.1 in the PDF tables), as that orientation has a 
lower energy compared to the alternate orientation having the phenyl ring rotated by 180 
deg. about its torsion.  As discussed in J. Med. Chem. 1998, 41, 4130-4142 and J. Med. 
Chem. 2000, 43, 71-95, the carbonyl / ester group in families A.24-A.27 were placed in 
the anti conformation, and all planar substituents at ring position 7 of Diazepam were 
placed in the syn conformation.  Non planar substituents at ring position 7 were placed in 
the alpha position (i.e. behind the ring structure).  

ER-lit: lit-2 (estradiol) was superimposed onto the estradiol ligand in PDB structure 
1GWR (again, not docked but just aligned to allow comparison of 3D QSAR model 
features with the protein active site).  All steroids (A.1 and A.2 families) were aligned 
onto lit-2, and substituents placed in a consistent fashion.  Compound lit-361 of family 
C.2 was superimposed (flexibly) onto lit-2 using the two OH groups and ring positions 5, 
6, 7 and 3', 4', 5' of lit-361 and the corresponding OH groups, with ring positions 
15,16,17 and 2,3,4 of lit-2.  The other C.x compounds were fit onto lit-361.  A similar 
alignment was used to superimpose lit-282 of family B.2 onto lit-2, with other B.x 
ligands fit onto lit-282.  

ER-tox.  A few steroids were aligned onto lit-2:  estradiols 61, 156, 158, 285, 286, 290, 
379, 380, 381, 384, 385, 417, 423, 443, 447, 448, 461, 462, non-estradiols 5, 24, 25, 29, 
30, 31, 32, 134, 165, 218, 267, 268, 269, 281, 282, 495, 554, 556, 580


