# Protein selection for docking

## Introduction

Often you might have multiple crystal structures for a protein, each with different ligands present.
This introduces an extra complexity when docking because you need to work out which one(s) are going
to give you the best results. This is common on fragment screening where you might have multiple fragments
crystalised into the same target protein. Those fragments may explore the extent of the cavity well, but
if you are wanting to use docking to screen potential derivatives of those fragments then you need to 
determine what protein structure(s) you are going to use.

If you are lucky one protein may be good for docking a wide range of ligands. If you are unlucky no single
protein may be good for all and you may need to use multiple proteins.

## Approach

The approach taken here is to try to re-dock all of the ligands into all of the proteins and see how well
each protein docks each ligand, based on RMSD values of the docked ligand and the coordinates of that
ligand in its own crystal structure. Hopefully the protein which contained the ligand is a good receptor
for that ligand, but is it also a good receptor for the other ligands.

RDock is used for the docking.

## Dataset

The data is a small subset of data from fragments screening of NUDT7A performed by the SGC at the Diamond Light
Source. The 5 structures were selected and prepared by Anthony Bradley. The ligands were removed to generate
apo structures. All waters wee alos removed. Proteins are in PDB format, ligands in MOLFILE format. 
The proteins are already aligned and there is only small variation on the protein backbone between the different structures.

The ligands for NUDT7A-x0129, NUDT7A-x0254, NUDT7A-x0384 and NUDT7A-x0389.mol occupy a very similar region in the cavity
whilst NUDT7A-x0151 occupies a different region with very little overlap.

![ligands in cavity](ligands.png)
The ligand for NUDT7A-x0151 is to the top left, separate from the 4 other ligands.

## Processing

### 1. copy files

Files are copied from the datasets section.

```
$ ./1_copy_files.sh 
Copying files ...
Files copied. Files are:
NUDT7A-x0129_apo.pdb  NUDT7A-x0151_apo.pdb  NUDT7A-x0254_apo.pdb  NUDT7A-x0384_apo.pdb	NUDT7A-x0389_apo.pdb
NUDT7A-x0129.mol      NUDT7A-x0151.mol	    NUDT7A-x0254.mol	  NUDT7A-x0384.mol	NUDT7A-x0389.mol
Creating SDF with all ligands ...
ligands.sdf created
Done
```

### 2. create cavity

How to define the cavity for each protein is a good question. As fragments are small each one only explores a relatively 
small part of the potential cavity. Any chemistry follow up is going to want to extend the fragment into this larger space.
Hence restricting the cavity to the area around the ligand for that protein may be too restrictive.

RDock provides two ways of defining the cavity. The easier one is to use an existing ligand to define the region of the cavity.
But doing this has the problems described above.

The second is to use the '2 sphere' approach to map out the cavity. That might be a good approach but here we're wanting to 
exploit the ligand information. 

So which ligand to use? Why not use them all as that will nicely map out the region.
The rDock rbcavity program only accepts a single ligand so we make this possible by creating a 'Frankenstein' ligand by
combining the atoms of all ligands into a single molecule. This is done with a [Perl script](select_points_SDF.pl) provided by
Xavier Barril who has previously used this technique. The Frankenstein molecule has only atoms, and no bonds, and 'internal'
atoms that do not contribute to the external surface are excluded. With this ligand we can create a cavity, and as the 
combined ligands should explore the cavity reasonably efficiently we can use a relatively small radius of 3A around those
atoms. See the [parameter file]()template.prm for details.

The cavity definition is generated for each protein with the [](2_create_cavity.sh) script which does these actions:

1. Creates the actual parameters file for each protein from a template
2. Prepares the protein in MOL2 format using OpenBabel. Note that this is quite a simplistic approach and we plan to come back to this later.
3. Creates the cavity definition using rbcavity and the Frankenstein molecule.

Each protein is handled in its own directory.


```
$ ./2_create_cavity.sh 
Creating Frankenstein ligand ...
V2000
V2000
V2000
V2000
V2000
Processing NUDT7A-x0129_apo.pdb ...
Creating NUDT7A-x0129.mol2
1 molecule converted
Creating cavity for NUDT7A-x0129
Processing NUDT7A-x0151_apo.pdb ...
Creating NUDT7A-x0151.mol2
1 molecule converted
Creating cavity for NUDT7A-x0151
Processing NUDT7A-x0254_apo.pdb ...
Creating NUDT7A-x0254.mol2
1 molecule converted
Creating cavity for NUDT7A-x0254
Processing NUDT7A-x0384_apo.pdb ...
Creating NUDT7A-x0384.mol2
1 molecule converted
Creating cavity for NUDT7A-x0384
Processing NUDT7A-x0389_apo.pdb ...
Creating NUDT7A-x0389.mol2
1 molecule converted
Creating cavity for NUDT7A-x0389
```

### 3. Docking

Docking is done using rDock. As the datasets are small we are not at this stage parallelising this.
Each of the 5 ligands is docked into each of the 5 proteins.
For each ligand-protein combination 50 dockings are performed generating a file named `<molecule-name>_docking.sd`
and the results sorted by the docking score to create the file `<molecule-name>_docking_sorted.sd`.
Then RMSD values are calculated against the pose of the same ligand in its own crystal structure.
Then the lowset RMSD for each molecule in that target and its rank in the scoring is extracted in the file `rmsd.scores`.

Run this with the command:

```
./3_run_rdock.sh
```


## Results

RMSD Scores are as follows

| Target | Ligand | Rank | RMSD
| --- | --- | --- | ---
| NUDT7A-x0129 | NUDT7A-x0129 | 35 | 1.36
| | NUDT7A-x0151 | 18 | 4.35
| | NUDT7A-x0254 | 9 | 1.20
| | NUDT7A-x0384 | 49 | 4.37
| | NUDT7A-x0389 | 47 | 2.15
| NUDT7A-x0151 | NUDT7A-x0129 | 30 | 6.92
| | NUDT7A-x0151 | 49 | 1.00
| | NUDT7A-x0254 | 50 | 7.56
| | NUDT7A-x0384 | 45 | 6.28
| | NUDT7A-x0389 | 3 | 7.06
| NUDT7A-x0254 | NUDT7A-x0129 | 47 | 1.79
| | NUDT7A-x0151 | 31 | 6.02
| | NUDT7A-x0254 | 41 | 1.91
| | NUDT7A-x0384 | 47 | 3.46
| | NUDT7A-x0389 | 35 | 2.00
| NUDT7A-x0384 | NUDT7A-x0129 | 15 | 5.69
| | NUDT7A-x0151 | 46 | 4.46
| | NUDT7A-x0254 | 46 | 4.51
| | NUDT7A-x0384 | 20 | 1.18
| | NUDT7A-x0389 | 21 | 6.34
| NUDT7A-x0389 | NUDT7A-x0129 | 39 | 1.51
| | NUDT7A-x0151 | 26 | 5.08
| | NUDT7A-x0254 | 39 | 4.30
| | NUDT7A-x0384 | 48 | 4.20
| | NUDT7A-x0389 | 41 | 1.28


A number of interesting conclusions can be made.

Firstly rDock seems to be good at generating the correct pose, but very often that pose is not the best score.
Very often the best RMSD is ranked quite lowly. We do need those 50 dockings to be sure of getting the possibility 
of a good pose.
 
This is seen for NUDT7A-x0389 where the ligand is consistently docked into the same space but two ways round, with the
wrong way scoring significantly better than the right way. In the figure below the ball and stick representation is the 
ligand in the crustal structure and the two licorice representation are the best scoring docking pose and the pose with 
the best RMSD. The one with the best RMSD ranks 41st in the scoring list! The best scoring pose overlays very well but
is the wrong way round. 

![ligands in cavity](alignment.png)

The overall picture for the best RMSD scores looks like this (rows are ligands, columns are proteins).

| Best RMSD | NUDT7A-x0129 | NUDT7A-x0151 | NUDT7A-x0254 | NUDT7A-x0384 | NUDT7A-x0389
| --- | --- | --- | --- | --- | ---
| NUDT7A-x0129 | 1.36 | 6.92 | 1.79 | 5.69 | 1.51
| NUDT7A-x0151 | 4.35 | 1.00 | 6.02 | 4.46 | 5.08
| NUDT7A-x0254 | 1.20 | 7.56 | 1.91 | 4.51 | 4.30
| NUDT7A-x0384 | 4.37 | 6.28 | 3.46 | 1.18 | 4.20
| NUDT7A-x0389 | 2.15 | 7.06 | 2.00 | 6.34 | 1.28
| SUM | 13.43 | 28.82 | 15.18 | 22.18 | 16.37

The ranks look like this:

| RMSD Rank | NUDT7A-x0129 | NUDT7A-x0151 | NUDT7A-x0254 | NUDT7A-x0384 | NUDT7A-x0389
| --- | --- | --- | --- | --- | ---
| NUDT7A-x0129 | 35 | 30 | 47 | 15 | 39
| NUDT7A-x0151 | 18 | 49 | 31 | 46 | 26
| NUDT7A-x0254 | 9 | 50 | 41 | 46 | 39
| NUDT7A-x0384 | 49 | 45 | 47 | 20 | 48
| NUDT7A-x0389 | 47 | 3 | 35 | 21 | 41

Clearly the 'best' pose as determined by RMSD to the crystal structure ligand often ranks quite low.
But despite this rDock is able to find the 'correct' pose in all cases.

## Conclusions

Clearly we should not trust the docking scores and need to look at alternative ways to score the docked posed.

Clearly we need to generate a reasonably large number of poses and not rely on the best scoring ones.

Overall the NUDT7A-x0129 protein seems the best target to use as the sum of the RMSD scores is lowest, but it does not
handle 2 of the ligands, NUDT7A-x0151 and NUDT7A-x0384, well. The proteins for those two ligands do handle their own
ligand well, but do not handle any of the other ligands well.

So if you wanted to choose only one taget to use you would select NUDT7A-x0129. If you wanted to be sure you had better
coverage then you would also need to include NUDT7A-x0151 and NUDT7A-x0384.

## Future work

Investigate better ways to prepare the protein.

Investigate the two spheres approach for cavity generation.

Investigate other docking algorithms.

Examine these docking poses with respect to the known hydrogen bonding and other interactions.

Investigate whether keeping specific water molecules in the protein structure can improve results.

Extend to other datasets.


