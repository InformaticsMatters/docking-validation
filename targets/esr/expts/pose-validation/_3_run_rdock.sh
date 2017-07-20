#!/bin/bash

echo "Running rDock ..."
rbdock -r 1sj0_rdock.prm -p dock.prm -n 25 -i 1sj0_ligand.sd -o 1sj0_rdock_out > 1sj0_rdock_out.log
echo "Extracting best pose ..."
sdsort -n -f'SCORE' 1sj0_rdock_out.sd | sdfilter -f'$_COUNT <= 10'> 1sj0_rdock_out_sorted.sd
echo "Generating RMSDs ..."
sdrmsd 1sj0_ligand.sd 1sj0_rdock_out_sorted.sd > rdock.rmsd
echo "Done"
