#!/bin/bash

# Numero di esecuzioni
n_runs=10

# File di log per raccogliere gli output
output_file1="log/throughput_log.txt"
output_file2="log/throughput_compact_log.txt"

throughput_values=""

# Pulisce il file log se già esistente
> $output_file1
> $output_file2


parallelism="8,8,8,8"
cpu_pinning="0,32,8,40,2,34,10,28,4,36,12,44,6,38,14,46,20,52,28,60,22,54,30,62,16,48,24,56,18,50,26,30"

for ((i=1; i<=n_runs; i++))
do
    echo "Execution $i:"
    
    # Esegue il programma e cattura l'output desiderato
    output=$(././bin/sd --rate 0 --keys 0 --sampling 1000 --batch 0 --parallelism $parallelism --cpu-pinning $cpu_pinning | grep "Measured throughput")

    echo "$output"
    
    if [ -z "$output" ]; then
        echo "Errore: 'Measured throughput:' non trovato nell'esecuzione $i" >> $output_file
    else
       throughput1=$(echo $output | grep -o '[0-9]\+ tuples/second')
       throughput2=$(echo $output | grep -o '[0-9]\+')
       throughput_values+="$throughput2; "
       echo "Esecuzione $i (--parallelism: $parallelism --cpu-pinning: $cpu_pinning), Throughput: $throughput1" >> $output_file1
       echo "" >> $output_file1
    fi
done

throughput_values=${throughput_values::-2}

echo "--parallelism: $parallelism; --cpu-pinning: $cpu_pinning;">> $output_file2
echo " Throughput: $throughput_values">> $output_file2

