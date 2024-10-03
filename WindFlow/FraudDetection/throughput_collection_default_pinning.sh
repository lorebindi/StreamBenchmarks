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

parallelism="8,8,8"
batch=32

for ((i=1; i<=n_runs; i++))
do
    echo "Execution $i:"

    # Esegue il programma e cattura l'output desiderato
    output=$(././bin/fd --rate 0 --keys 0 --sampling 1000 --batch $batch --parallelism $parallelism | grep "Measured throughput")

    echo "$output"

    if [ -z "$output" ]; then
        echo "Errore: 'Measured throughput:' non trovato nell'esecuzione $i" >> $output_file1
    else
       throughput1=$(echo $output | grep -o '[0-9.]\+ tuples/second')
       throughput2=$(echo $output | grep -o '[0-9.]\+' | tail -n 1)

       throughput_values+="$throughput2; "
       echo "Esecuzione $i (--batch $batch --parallelism: $parallelism ), Throughput: $throughput1" >> $output_file1
       echo "" >> $output_file1
    fi

    if [ $((i % 10)) -eq 0 ]; then
      throughput_values=${throughput_values::-2}
      echo "--batch $batch --parallelism: $parallelism; ">> $output_file2
      echo " Throughput: $throughput_values">> $output_file2
      echo "" >> $output_file1
      echo "" >> $output_file1
      echo "" >> $output_file2

      if [ $i -eq 10 ]; then
        throughput_values=""
        parallelism="4,4,4"
        batch=0

      elif [ $i -eq 20 ]; then
        throughput_values=""
        parallelism="4,4,4"
        batch=32

      elif [ $i -eq 30 ]; then
        throughput_values=""
        parallelism="8,8,8"
        batch=0

      elif [ $i -eq 40 ]; then
        throughput_values=""
        parallelism="8,8,8"
        batch=0

      elif [ $i -eq 50 ]; then
        throughput_values=""
        parallelism="4,4,4"
        batch=32

      elif [ $i -eq 60 ]; then
        throughput_values=""
        parallelism="8,8,8"

      elif [ $i -eq 70 ]; then
        throughput_values=""
        parallelism="8,8,8"
        batch=32

      #elif [ $i -eq 80 ]; then
      #  throughput_values=""
      #  parallelism="4,4,4,4"

      #elif [ $i -eq 90 ]; then
      #  throughput_values=""
      #  parallelism="8,8,8,8"

      #elif [ $i -eq 100 ]; then
      #  throughput_values=""
      #  parallelism="8,8,8,8"

      #elif [ $i -eq 110 ]; then
      #  throughput_values=""
      #  parallelism="8,8,8,8"

      #elif [ $i -eq 120 ]; then
      #  throughput_values=""
      #  parallelism="8,8,8,8"

      fi
    fi
done

