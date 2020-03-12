# Protein selection for docking

## Introduction

The methodology used here is described in more detail [here](../../nudt7/expts/pretein-selection/README.md).

## Dataset

The data is from fragment screening of the COVID-19 protease performed by the Diamond Light Source's 
[XChem project](https://www.diamond.ac.uk/Instruments/Mx/Fragment-Screening.html).
See [here](https://www.diamond.ac.uk/covid-19/for-scientists/Main-protease-structure-and-XChem.html) for more details.

The ligands for occupy the cysteine protease active site.


## Results

RMSD Scores are as follows

| Target | Ligand | Rank | RMSD
| --- | --- | --- | ---
| Mpro-x0072_0 | Mpro-x0072_0 | 17 | 1.40
| | Mpro-x0104_0 | 22 | 1.47
| | Mpro-x0161_0 | 33 | 1.54
| | Mpro-x0195_0 | 17 | 1.42
| | Mpro-x0305_0 | 45 | 3.40
| | Mpro-x0434_0 | 48 | 0.77
| | Mpro-x0678_0 | 13 | 1.47
| Mpro-x0104_0 | Mpro-x0072_0 | 33 | 0.93
| | Mpro-x0104_0 | 41 | 2.41
| | Mpro-x0161_0 | 49 | 1.21
| | Mpro-x0195_0 | 22 | 1.19
| | Mpro-x0305_0 | 38 | 3.50
| | Mpro-x0434_0 | 32 | 0.81
| | Mpro-x0678_0 | 29 | 1.36
| Mpro-x0161_0 | Mpro-x0072_0 | 39 | 5.05
| | Mpro-x0104_0 | 38 | 2.40
| | Mpro-x0161_0 | 41 | 1.48
| | Mpro-x0195_0 | 44 | 0.63
| | Mpro-x0305_0 | 30 | 4.19
| | Mpro-x0434_0 | 34 | 0.78
| | Mpro-x0678_0 | 2 | 1.22
| Mpro-x0195_0 | Mpro-x0072_0 | 42 | 1.65
| | Mpro-x0104_0 | 49 | 1.22
| | Mpro-x0161_0 | 2  | 1.59
| | Mpro-x0195_0 | 30 | 1.11
| | Mpro-x0305_0 | 16 | 3.57
| | Mpro-x0434_0 | 36 | 0.64
| | Mpro-x0678_0 | 27 | 1.06
| Mpro-x0305_0 | Mpro-x0072_0 | 25 | 0.84
| | Mpro-x0104_0 | 19 | 2.60
| | Mpro-x0161_0 | 17 | 1.55
| | Mpro-x0195_0 | 26 | 1.96
| | Mpro-x0305_0 | 1 | 0.65
| | Mpro-x0434_0 | 36 | 0.76
| | Mpro-x0678_0 | 24 | 1.14
| Mpro-x0434_0 | Mpro-x0072_0 | 35 | 1.36
| | Mpro-x0104_0 | 47 | 1.49
| | Mpro-x0161_0 | 45 | 1.58
| | Mpro-x0195_0 | 38 | 1.55
| | Mpro-x0305_0 | 34 | 3.38
| | Mpro-x0434_0 | 40 | 0.89
| | Mpro-x0678_0 | 48 | 1.46
| Mpro-x0678_0 | Mpro-x0072_0 | 37 | 3.22
| | Mpro-x0104_0 | 24 | 1.68
| | Mpro-x0161_0 | 34 | 1.71
| | Mpro-x0195_0 | 1 | 2.67
| | Mpro-x0305_0 | 24 | 3.82
| | Mpro-x0434_0 | 39 | 0.93
| | Mpro-x0678_0 | 30 | 1.05




The overall picture for the best RMSD scores looks like this (rows are ligands, columns are proteins).


| Best RMSD | Mpro-x0072_0 | Mpro-x0104_0 | Mpro-x0161_0 | Mpro-x0195_0 | Mpro-x0305_0 | Mpro-x0434_0 | Mpro-x0678_0 
| ------------ | ----- | ----- | ----- | ----- | ----- | ----- | -----
| Mpro-x0072_0 |  1.40 |  0.93 |  5.05 |  1.65 |  0.84 |  1.36 |  3.22
| Mpro-x0104_0 |  1.47 |  2.41 |  2.40 |  1.22 |  2.60 |  1.49 |  1.68
| Mpro-x0161_0 |  1.54 |  1.21 |  1.48 |  1.59 |  1.55 |  1.58 |  1.71
| Mpro-x0195_0 |  1.42 |  1.19 |  0.63 |  1.11 |  1.96 |  1.55 |  2.67
| Mpro-x0305_0 |  3.40 |  3.50 |  4.19 |  3.57 |  0.65 |  3.38 |  3.82
| Mpro-x0434_0 |  0.77 |  0.81 |  0.78 |  0.64 |  0.76 |  0.89 |  0.93
| Mpro-x0678_0 |  1.47 |  1.36 |  1.22 |  1.06 |  1.14 |  1.46 |  1.05
| SUM          | 11.46 | 11.41 | 15.75 | 10.84 |  9.50 | 11.71 | 15.08



Clearly the 'best' pose as determined by RMSD to the crystal structure ligand often ranks quite low.
But despite this rDock is able to find the 'correct' pose in all cases, though the RMSD for Mpro-x0104_0
is poor compared to the others.

## Conclusions

Clearly we need to generate a reasonably large number of poses and not rely on the top scoring ones.

Overall the Mpro-x0305_0 protein seems the best target to use as the sum of the RMSD scores is lowest, with the worst
performance being a RMSD of 2.60 for Mpro-x0104_0.

So if you wanted to choose only one target to use you would select Mpro-x0305_0. If you wanted to be sure you had better
coverage then you might also include Mpro-x0195_0 as that also mostly has low scores, including for the Mpro-x0104_0 ligand.



