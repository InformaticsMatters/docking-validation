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
These are those averages for the 3 runs (rows are ligands, columns are proteins). Also present in the sheet is an earlier 
set of runs of the first 17 structures that were available. 
 

|     | Mpro-x0072_0 | Mpro-x0104_0 | Mpro-x0107_0 | Mpro-x0161_0 | Mpro-x0195_0 | Mpro-x0305_0 | Mpro-x0354_0 | Mpro-x0387_0 | Mpro-x0395_0 | Mpro-x0397_0 | Mpro-x0426_0 | Mpro-x0434_0 | Mpro-x0540_0 | Mpro-x0678_0 | Mpro-x0874_0 | Mpro-x0946_0 | Mpro-x0967_0 | Mpro-x0991_0 | Mpro-x0995_0 | Mpro-x1077_0 | Mpro-x1093_0 | Mpro-x1249_0
 ---  | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---          | ---
| Mpro-x0072_0 | 1.56 | 3.50 | 2.18 | 2.48 | 2.35 | 2.06 | 2.59 | 1.77 | 2.46 | 5.00 | 3.31 | 3.90 | 3.77 | 3.17 | 1.27 | 1.98 | 3.42 | 2.14 | 2.04 | 2.14 | 3.07 | 2.42
| Mpro-x0104_0 | 2.38 | 1.11 | 2.60 | 1.83 | 1.39 | 2.69 | 1.87 | 2.99 | 2.59 | 4.54 | 2.73 | 2.49 | 2.48 | 2.37 | 1.19 | 1.38 | 2.25 | 3.16 | 3.02 | 2.74 | 5.08 | 2.42
| Mpro-x0107_0 | 1.29 | 1.29 | 0.92 | 1.30 | 2.41 | 1.33 | 1.44 | 1.36 | 1.26 | 2.07 | 1.14 | 1.20 | 1.26 | 1.93 | 1.33 | 2.43 | 2.48 | 1.29 | 1.17 | 1.32 | 2.57 | 1.34
| Mpro-x0161_0 | 1.38 | 1.48 | 2.53 | 1.40 | 1.44 | 1.65 | 1.53 | 2.83 | 1.62 | 4.81 | 1.87 | 1.86 | 1.65 | 1.64 | 1.49 | 1.43 | 1.38 | 3.52 | 4.32 | 1.97 | 5.55 | 1.71
| Mpro-x0195_0 | 1.60 | 1.18 | 2.83 | 0.92 | 1.09 | 1.73 | 2.66 | 3.47 | 1.24 | 5.58 | 1.85 | 1.48 | 2.24 | 2.18 | 1.30 | 1.05 | 1.05 | 4.72 | 6.07 | 2.41 | 6.56 | 1.92
| Mpro-x0305_0 | 3.73 | 2.77 | 3.75 | 4.13 | 2.62 | 0.62 | 3.79 | 0.81 | 3.35 | 4.59 | 4.13 | 3.98 | 3.72 | 3.56 | 1.21 | 1.96 | 2.76 | 3.94 | 4.15 | 3.39 | 5.60 | 0.98
| Mpro-x0354_0 | 5.21 | 5.80 | 5.02 | 5.60 | 5.71 | 3.36 | 5.72 | 4.67 | 5.75 | 5.99 | 5.47 | 5.40 | 5.82 | 4.85 | 5.51 | 5.79 | 5.43 | 4.96 | 5.27 | 5.97 | 4.90 | 4.68
| Mpro-x0387_0 | 4.94 | 5.13 | 2.51 | 5.03 | 3.25 | 3.13 | 3.18 | 2.57 | 3.85 | 5.05 | 5.12 | 5.17 | 4.74 | 3.63 | 5.24 | 4.92 | 4.37 | 5.41 | 5.47 | 3.00 | 3.83 | 1.79
| Mpro-x0395_0 | 2.07 | 2.17 | 2.77 | 2.35 | 2.11 | 1.82 | 2.82 | 2.39 | 2.95 | 4.92 | 3.27 | 2.87 | 4.16 | 3.43 | 1.97 | 2.20 | 3.37 | 3.12 | 2.39 | 2.06 | 3.76 | 1.97
| Mpro-x0397_0 | 4.01 | 5.20 | 3.08 | 4.39 | 5.05 | 3.65 | 3.28 | 2.33 | 3.68 | 1.93 | 2.85 | 3.30 | 3.82 | 4.43 | 3.12 | 4.35 | 4.84 | 2.92 | 2.22 | 3.01 | 2.57 | 3.94
| Mpro-x0426_0 | 7.01 | 7.76 | 6.14 | 7.68 | 7.57 | 7.41 | 6.80 | 6.29 | 7.32 | 6.58 | 6.73 | 6.86 | 6.28 | 7.28 | 6.46 | 7.73 | 6.81 | 6.49 | 6.02 | 7.24 | 6.14 | 6.79
| Mpro-x0434_0 | 0.85 | 0.82 | 1.51 | 0.80 | 0.74 | 0.75 | 0.80 | 0.70 | 0.89 | 2.11 | 1.14 | 0.76 | 0.86 | 1.10 | 0.88 | 0.77 | 0.72 | 1.92 | 1.53 | 1.49 | 1.08 | 0.87
| Mpro-x0540_0 | 6.88 | 7.67 | 5.11 | 6.96 | 6.29 | 6.38 | 6.98 | 5.83 | 6.37 | 5.54 | 6.96 | 6.29 | 6.24 | 6.88 | 6.94 | 7.64 | 6.42 | 5.90 | 5.37 | 7.37 | 4.47 | 5.74
| Mpro-x0678_0 | 1.38 | 1.42 | 2.09 | 1.17 | 1.11 | 1.31 | 1.07 | 1.47 | 1.73 | 3.69 | 2.15 | 1.58 | 1.48 | 1.04 | 1.36 | 1.30 | 0.90 | 2.52 | 2.19 | 2.20 | 1.29 | 1.35
| Mpro-x0874_0 | 2.96 | 2.65 | 3.97 | 2.85 | 2.03 | 1.99 | 3.19 | 3.27 | 3.37 | 3.77 | 3.37 | 2.97 | 3.34 | 2.63 | 1.92 | 2.65 | 2.51 | 4.03 | 4.10 | 3.22 | 2.50 | 2.17
| Mpro-x0946_0 | 1.73 | 1.37 | 4.14 | 1.46 | 1.26 | 1.77 | 1.92 | 4.59 | 1.38 | 4.10 | 1.80 | 1.97 | 1.52 | 2.32 | 2.02 | 1.02 | 2.48 | 4.32 | 5.09 | 1.75 | 6.48 | 1.91
| Mpro-x0967_0 | 3.09 | 2.59 | 2.75 | 3.03 | 2.46 | 2.95 | 2.67 | 2.36 | 2.93 | 3.01 | 2.39 | 2.62 | 2.63 | 2.03 | 2.40 | 2.56 | 2.57 | 3.08 | 2.76 | 2.87 | 1.78 | 2.28
| Mpro-x0991_0 | 6.46 | 6.16 | 8.16 | 7.10 | 5.96 | 6.64 | 6.41 | 5.99 | 8.18 | 7.24 | 7.86 | 8.22 | 7.67 | 5.54 | 6.53 | 6.75 | 6.37 | 8.40 | 8.39 | 2.64 | 7.20 | 6.50
| Mpro-x0995_0 | 0.64 | 2.34 | 0.91 | 0.67 | 1.90 | 1.21 | 1.99 | 0.67 | 0.67 | 1.28 | 0.72 | 0.73 | 0.76 | 2.48 | 1.36 | 1.20 | 2.42 | 0.62 | 0.65 | 0.69 | 1.59 | 1.29
| Mpro-x1077_0 | 2.37 | 3.32 | 2.01 | 2.99 | 4.02 | 2.41 | 4.21 | 2.49 | 3.49 | 4.73 | 3.26 | 4.42 | 3.92 | 4.82 | 3.13 | 2.47 | 4.52 | 2.72 | 3.66 | 2.44 | 3.21 | 3.56
| Mpro-x1093_0 | 2.04 | 1.00 | 1.91 | 1.70 | 1.49 | 2.09 | 1.80 | 1.79 | 1.92 | 2.94 | 2.04 | 2.11 | 1.74 | 0.95 | 0.87 | 1.57 | 0.72 | 2.21 | 2.17 | 1.71 | 1.66 | 1.58
| Mpro-x1249_0 | 3.93 | 3.62 | 4.10 | 3.86 | 2.42 | 2.89 | 3.46 | 3.08 | 3.40 | 4.35 | 3.64 | 3.57 | 3.50 | 3.15 | 3.13 | 3.64 | 3.34 | 4.16 | 4.47 | 4.14 | 3.03 | 3.32
| AVG | 3.07 | 3.20 | 3.23 | 3.17 | 2.94 | 2.72 | 3.19 | 2.90 | 3.20 | 4.26 | 3.35 | 3.35 | 3.35 | 3.24 | 2.76 | 3.03 | 3.23 | 3.71 | 3.75 | 2.99 | 3.82 | 2.75
| MIN | 0.64 | 0.82 | 0.91 | 0.67 | 0.74 | 0.62 | 0.80 | 0.67 | 0.67 | 1.28 | 0.72 | 0.73 | 0.76 | 0.95 | 0.87 | 0.77 | 0.72 | 0.62 | 0.65 | 0.69 | 1.08 | 0.87
| MAX | 7.01 | 7.76 | 8.16 | 7.68 | 7.57 | 7.41 | 6.98 | 6.29 | 8.18 | 7.24 | 7.86 | 8.22 | 7.67 | 7.28 | 6.94 | 7.73 | 6.81 | 8.40 | 8.39 | 7.37 | 7.20 | 6.79
| SELF | 1.56 | 1.11 | 0.92 | 1.40 | 1.09 | 0.62 | 5.72 | 2.57 | 2.95 | 1.93 | 6.73 | 0.76 | 6.24 | 1.04 | 1.92 | 1.02 | 2.57 | 8.40 | 0.65 | 2.44 | 1.66 | 3.32



## Conclusions

With so much data it's not easy to make simple conclusions.

Clearly we need to generate a reasonably large number of poses and not rely on the top scoring ones as the pose with lowest RMSD often ranks
quite lowly (data in Excel spreadsheet).

Considering the ligands, Mpro-x0354_0, Mpro-x0387_0 and especially Mpro-x0426 and Mpro-x0540_0 are problematical, with many proteins docking
them poorly.

For the receptors which is our main interest here the average RMSDs range from 2.72 to 4.26, so clearly some are better on
average than others. The best is Mpro-x0305_0, but that has a worst score of 7.41 which is relatively poor.
A more thorough statistical analysis is needed, but a casual inspection indicates that Mpro-x1249 and Mpro-x0387_0 might be a good targets
to use as they are towards the best of the average scores (rank 2 and 4) and the best of max scores (rank 2 and 1).
They also perform reasonably well for those 4 problem ligands.

Mpro-x0874_0 would also be a reasonable choice ranking 3 and 4.

In contrast Mpro-x0107_0, Mpro-x0395, Mpro-x0397, Mpro-x0426, Mpro-x0434, Mpro-x0991, Mpro-x0995 have high RMSDs 
and high max scores so should be avoided.

But more analysis is needed!

An Excel sheet with the RMSD and rank scores is [here](rmsds.xlsx).



