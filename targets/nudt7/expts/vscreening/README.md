# Virtual screening using rDock

This dir shows how to perform virtual screening using rDock for docking.
There a 5 fragment screening hits for NUDT7 and for each one we dock the screening hit back into the target
to determine the docking score, and then dock a set of candidate ligands into the same target, filtering the 
docking scores relative to the score for the original hit for that target. 

By default the normalised scores is used but the raw score can also be specified.

By default the 5 screening hits are docked, but an alternative SDF can be specified, and one is provided that
contains 101 molecules. See below for details.

By default only poses with better (more negative) scores that the reference ligand are included, but this threshold
can be specified. See below for details.

## Running

Copy files:
```
./1_copy_files.sh
```

Create cavity definition using the ligand for the protein:
```
./2_create_cavity.sh
```

Run docking:
```
./3_run_rdock_all.sh 
```

All parameters are passed on to Nextflow.

e.g. to run a different number of dockings:
```
./3_run_rdock_all.sh  --num_dockings 2
```

e.g. to run with a different set of ligands and a different screening threshold:
```
./3_run_rdock_all.sh --ligands ../candidate-ligands.sdf.gz --threshold 5
```
Note: the default `ligands-5.sdf.gz` comprises the ligands from the 5 targets.
The `candidate-ligands.sdf.gz` file contains 101 structures expanded out from
those 5 ligands using [fragnet search](https://fragnet.informaticsmatters.com/).