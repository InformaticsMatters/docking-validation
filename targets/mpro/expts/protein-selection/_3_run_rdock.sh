#!/bin/bash
# run rDock for the docking


set -e

basename=$1
num=50
cd $basename
rm -f *_docking.log *.sd *.rmsd rmsd.scores

for m in ../Mpro*.mol
do
	filename=${m:3}    
	molname="${filename%.mol}"
	echo -e "\tDocking $m"
	rbdock -r docking.prm -p dock.prm -n $num -i $m -o ${molname}_docking > ${molname}_docking.log

	echo -e "\tSorting the poses ..."
	sdsort -n -f'SCORE' ${molname}_docking.sd > ${molname}_docking_sorted.sd

	echo -e "\tGenerating RMSDs ..."
	sdrmsd $m ${molname}_docking_sorted.sd > ${molname}.rmsd
done

echo -e "\tExtracting scores ..."
scorefile=rmsd.scores
echo -e "LIGAND\tRANK\tRMSD" > $scorefile
for f in *.rmsd
do
    echo "Processing $f"
	mol="${f%.rmsd}"
	echo -ne "${mol}\t" >> $scorefile
	fgrep $(cut -f 2 $f | sort -n | head -2 | tail -1) $f | head -1 >> $scorefile
done


echo -e "\tDone"
