# Protein selection for docking

## Introduction

The methodology used here is described in more detail [here](../../../nudt7/expts/protein-selection/README.md).

## Dataset

The data is from fragment screening of the COVID-19 protease performed by the Diamond Light Source's 
[XChem project](https://www.diamond.ac.uk/Instruments/Mx/Fragment-Screening.html).
See [here](https://www.diamond.ac.uk/covid-19/for-scientists/Main-protease-structure-and-XChem.html) for more details.

The ligands for occupy the cysteine protease active site.


## Results

3 independent runs were performed and the averages generated in an Excel sheet that can be found [here](rmsds.xlsx).
These are those averages for the 3 runs (rows are ligands, columns are proteins)

|      | Mpro-x0072_0 | Mpro-x0104_0 | Mpro-x0107_0 | Mpro-x0161_0 | Mpro-x0195_0 | Mpro-x0305_0 | Mpro-x0354_0 | Mpro-x0387_0 | Mpro-x0434_0 | Mpro-x0540_0 | Mpro-x0678_0 | Mpro-x0874_0 | Mpro-x0946_0 | Mpro-x0995_0 | Mpro-x1077_0 | Mpro-x1093_0 | Mpro-x1249_0 | AVG
| ---  | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---
| Mpro-x0072_0 | 1.46 | 1.17 | 1.98 | 1.86 | 3.12 | 1.12 | 3.50 | 1.64 | 2.25 | 3.14 | 2.83 | 1.26 | 1.35 | 2.27 | 1.77 | 2.21 | 1.22 | 2.01
| Mpro-x0104_0 | 1.98 | 1.89 | 2.39 | 2.81 | 1.36 | 1.96 | 1.83 | 2.42 | 1.81 | 2.35 | 2.18 | 2.11 | 1.51 | 2.51 | 2.50 | 4.54 | 1.39 | 2.21
| Mpro-x0107_0 | 1.45 | 3.38 | 1.46 | 1.36 | 1.24 | 1.71 | 3.12 | 1.86 | 1.63 | 1.67 | 1.40 | 1.38 | 2.82 | 1.64 | 1.36 | 3.67 | 1.59 | 1.93
| Mpro-x0161_0 | 1.50 | 1.39 | 1.96 | 1.46 | 2.74 | 1.42 | 1.55 | 2.22 | 1.57 | 1.55 | 1.49 | 1.86 | 2.94 | 2.15 | 1.56 | 4.59 | 1.49 | 1.97
| Mpro-x0195_0 | 1.55 | 1.20 | 2.64 | 1.40 | 1.24 | 1.68 | 2.22 | 3.38 | 1.63 | 2.05 | 2.13 | 1.29 | 1.16 | 3.73 | 1.87 | 5.72 | 1.67 | 2.15
| Mpro-x0305_0 | 2.99 | 2.72 | 3.94 | 2.90 | 2.18 | 0.95 | 2.06 | 1.31 | 3.15 | 3.25 | 3.24 | 1.28 | 1.77 | 3.42 | 3.07 | 4.33 | 1.11 | 2.57
| Mpro-x0354_0 | 4.96 | 4.97 | 4.29 | 5.07 | 4.67 | 4.08 | 4.55 | 2.91 | 5.16 | 4.37 | 4.18 | 4.01 | 3.98 | 4.75 | 5.04 | 5.39 | 3.42 | 4.46
| Mpro-x0387_0 | 3.88 | 4.76 | 4.41 | 5.28 | 5.13 | 3.73 | 4.88 | 2.08 | 5.08 | 5.18 | 4.24 | 3.26 | 4.08 | 4.74 | 3.91 | 4.40 | 5.33 | 4.38
| Mpro-x0434_0 | 0.97 | 2.28 | 1.76 | 2.09 | 2.13 | 0.92 | 1.50 | 0.74 | 2.21 | 2.06 | 1.97 | 2.34 | 2.15 | 2.79 | 1.35 | 1.70 | 1.16 | 1.77
| Mpro-x0540_0 | 5.09 | 4.88 | 4.10 | 5.21 | 5.52 | 5.28 | 5.14 | 4.46 | 4.79 | 3.91 | 4.47 | 5.21 | 4.92 | 4.84 | 5.23 | 2.99 | 5.00 | 4.77
| Mpro-x0678_0 | 3.59 | 3.55 | 3.81 | 3.46 | 3.27 | 3.28 | 3.39 | 3.32 | 3.31 | 2.34 | 3.12 | 3.00 | 3.51 | 3.66 | 3.98 | 1.85 | 3.35 | 3.28
| Mpro-x0874_0 | 2.52 | 2.37 | 3.51 | 2.66 | 1.77 | 2.51 | 2.76 | 2.56 | 2.57 | 2.70 | 2.40 | 1.86 | 1.73 | 3.23 | 2.92 | 1.78 | 1.99 | 2.46
| Mpro-x0946_0 | 2.16 | 1.69 | 2.68 | 1.85 | 1.55 | 1.98 | 2.30 | 3.30 | 2.28 | 1.99 | 2.72 | 1.88 | 1.40 | 3.12 | 2.19 | 4.40 | 1.77 | 2.31
| Mpro-x0995_0 | 0.99 | 2.26 | 1.99 | 0.96 | 2.07 | 1.00 | 4.04 | 2.00 | 1.21 | 1.05 | 2.01 | 1.10 | 0.86 | 1.87 | 0.90 | 3.05 | 1.04 | 1.67
| Mpro-x1077_0 | 2.50 | 3.41 | 1.63 | 2.40 | 3.22 | 1.74 | 3.51 | 2.41 | 2.38 | 2.39 | 3.26 | 1.72 | 2.52 | 3.03 | 1.54 | 2.45 | 1.82 | 2.47
| Mpro-x1093_0 | 2.19 | 2.73 | 1.88 | 2.17 | 2.79 | 1.77 | 2.06 | 2.30 | 2.41 | 2.50 | 2.05 | 2.43 | 2.43 | 2.08 | 1.68 | 2.49 | 1.41 | 2.20
| Mpro-x1249_0 | 3.21 | 2.44 | 3.40 | 2.71 | 2.78 | 2.57 | 3.24 | 2.47 | 3.25 | 2.97 | 2.53 | 2.38 | 2.60 | 3.64 | 3.31 | 2.20 | 2.64 | 2.84
| AVG | 2.53 | 2.77 | 2.81 | 2.69 | 2.75 | 2.22 | 3.04 | 2.43 | 2.75 | 2.68 | 2.72 | 2.26 | 2.46 | 3.14 | 2.60 | 3.40 | 2.20 | 
| MIN | 0.97 | 1.17 | 1.46 | 0.96 | 1.24 | 0.92 | 1.50 | 0.74 | 1.21 | 1.05 | 1.40 | 1.10 | 0.86 | 1.64 | 0.90 | 1.70 | 1.04 | 
| MAX | 5.09 | 5.09 | 4.41 | 5.28 | 5.52 | 5.28 | 5.14 | 4.46 | 5.16 | 5.18 | 4.47 | 5.21 | 4.92 | 4.84 | 5.23 | 5.72 | 5.33 | 
| SELF | 1.46 | 1.89 | 1.46 | 1.46 | 1.24 | 0.95 | 4.55 | 2.08 | 2.21 | 3.91 | 3.12 | 1.86 | 1.40 | 1.87 | 1.54 | 2.49 | 2.64 | 


## Conclusions

With so much data it's not easy to make simple conclusions.

Clearly we need to generate a reasonably large number of poses and not rely on the top scoring ones as the pose with lowest RMSD often ranks
quite lowly (data in Excel spreadsheet).

Considering the ligands, Mpro-x0354_0, Mpro-x0387_0 and especially Mpro-x0540_0 are problematical, with many proteins docking
them poorly.

For the receptors which is our main interest here the average RMSDs range from 2.2 to 3.4, so clearly some are better on
average than others. The best is Mpro-x1249_0, but that has a worst score of 5.33 which is towards the top.
A more thorough statistical analysis is needed, but a casual inspection indicates that Mpro-x0387_0 might be a good target
to use as it has an average RMSD score or 2.43, only slightly higher than the lowest, has a 4.46, beaten only by Mpro-x0107_0
and performs reasonably well for those 3 problem ligands. 

Mpro-x0946_0 would also be a reasonable choice.

In contrast Mpro-x0354_0, Mpro-x0995_0 and Mpro-x1093_0 have average RMSDs above 3.0 so should be avoided.

More analysis is needed!

An Excel sheet with the RMSD and rank scores is [here](rmsds.xlsx).



