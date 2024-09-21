#!/bin/bash

# Numero di esecuzioni
n_runs=2

# File di log per raccogliere gli output
output_file="log/throughput_log.txt"

# Pulisce il file log se già esistente
> $output_file


parallelism="2,2,2,2"
cpu_pinning="0,16,32,48,8,24,40,56"

for ((i=1; i<=n_runs; i++))
do
    echo "Execution $i:"
    
    # Esegue il programma e cattura l'output desiderato
    output=$(././bin/sd --rate 0 --keys 0 --sampling 1000 --batch 0 --parallelism $parallelism --cpu-pinning $cpu_pinning | grep "Measured throughput")

    echo "$output"
    
    if [ -z "$output" ]; then
        echo "Errore: 'Measured throughput:' non trovato nell'esecuzione $i" >> $output_file
    else
        echo "Esecuzione $i (--parallelism: $parallelism --cpu-pinning: $cpu_pinning): $output" >> $output_file
    fi
done
