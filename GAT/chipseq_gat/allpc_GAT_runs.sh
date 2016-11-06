#!/bin/bash
# This script tests for enrichment in enhancer-bound and non-enhancer bound protein-coding genes and lincRNAs in TAD-bins.
# This is done by a series of GAT calls using different values for segment and annotation arguments in the whole genome.
# Cyril Matthey-Doret
# 29.10.2016


g=$(find ../data/GAT/genes/*pc*)
b="../data/chip_seq/merged_binding_sites.bed"
W="../data/GAT/all_pc_genes.bed" 
A=$b
for S in $g
do
    sS=${S##*/}
    desc="W_allpc_S_"${sS%.*}"_A_short5bins"
    gat-run.py  --verbose=5 \
                --log='log_'$desc'.log' \
                --segment-file=$S \
                --annotation-file=$A \
                --workspace=$W \
                --ignore-segment-tracks \
                --num-samples=1000 \
                --qvalue-method=BH \
                --isochore-file="../data/GAT/hg19.fa.corr_term_ISOisochore.bed" \
                >'gat_'$desc'.tsv'
    
    desc="W_allpc_S_short5bins_A_""${sS%\.*}"
    gat-run.py  --verbose=5 \
                --log='log_'$desc'.log' \
                --num-samples=1000 \
                --qvalue-method=BH \
                --segment-file=$A \
                --annotation-file=$S \
                --workspace=$W \
                --isochore-file="../data/GAT/hg19.fa.corr_term_ISOisochore.bed" \
                >'gat_'$desc'.tsv'        
done

