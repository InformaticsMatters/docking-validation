# Tethered rDock docking of Fragalysis compounds

Initial prototype Nextflow workflow to perform tethered docking of potnetial MURD inhibitors designed
in Fragalysis. Much more work is needed on this.

*Note*: because of issues wth the data this is currently restricted to running only on MOL_3 and 
MOL_3/VECTOR_1 is limited to 10 inputs.

## Run

```
$ nextflow run main.nf -with-docker
N E X T F L O W  ~  version 0.29.0
Launching `main.nf` [voluminous_montalcini] - revision: f8eca1c01b
[warm up] executor > local
[cc/d2f5ec] Submitted process > prepare_protein
[83/2df3ac] Submitted process > prepare_inputs (1)
[83/4efc4b] Submitted process > prepare_inputs (2)
[d9/673fd9] Submitted process > splitter (1)
[f8/44ceb7] Submitted process > docking (1)
[bf/648bdf] Submitted process > splitter (2)
[55/f2908e] Submitted process > docking (2)
[e8/c8a0f9] Submitted process > results (2)
[43/93b418] Submitted process > results (1)
/home/timbo/github/im/docking-validation/targets/murd/expts/tethered_fragalysis_docking/work/43/93b41849bfcb6c8eb71c1f9f17fa42/MOL_3_VECTOR_0.sdf.gz
/home/timbo/github/im/docking-validation/targets/murd/expts/tethered_fragalysis_docking/work/e8/c8a0f9b3c78d24e6a6d9f23463491c/MOL_3_VECTOR_1.sdf.gz
Done
```

Result files will be found in the results dir. A fixed set of results in checked into git in the 
`docking_results` directory.
