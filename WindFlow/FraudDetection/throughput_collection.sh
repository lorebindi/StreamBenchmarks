#!/bin/bash

# Numero di esecuzioni
n_runs=80

# File di log per raccogliere gli output
output_file1="log/throughput_log.txt"
output_file2="log/throughput_compact_log.txt"

throughput_values=""

# Pulisce il file log se già esistente
> $output_file1
> $output_file2

parallelism="2,2,2"
batch=32
cpu_pinning="1,33,17,49,9,25"

for ((i=1; i<=n_runs; i++))
do
    echo "Execution $i:"

    utenti_connessi=$(w | wc -l)
    utenti_connessi=$((utenti_connessi - 2))

    # Finché ci sono più di 1 utente connesso, aspetta e controlla ogni minuto
    while [ "$utenti_connessi" -gt 1 ]
    do
      echo "Ci sono ancora $utenti_connessi utenti connessi. Attendo 1 minuto..."
      sleep 60  # Attende 1 minuto
      utenti_connessi=$(w | wc -l)
      utenti_connessi=$((utenti_connessi - 2))  # Aggiorna il numero di utenti
    done

    # Esegue il programma e cattura l'output desiderato
    output=$(././bin/fd --rate 0 --keys 0 --sampling 1000 --batch $batch --parallelism $parallelism --cpu-pinning $cpu_pinning | grep "Measured throughput")

    echo "$output"

    if [ -z "$output" ]; then
        echo "Errore: 'Measured throughput:' non trovato nell'esecuzione $i" >> $output_file1
    else
       throughput1=$(echo $output | grep -o '[0-9.]\+ tuples/second')
       throughput2=$(echo $output | grep -o '[0-9.]\+' | tail -n 1)

       throughput_values+="$throughput2; "
       echo "Esecuzione $i (--batch $batch --parallelism: $parallelism --cpu-pinning: $cpu_pinning), Throughput: $throughput1" >> $output_file1
       echo "" >> $output_file1
    fi

    if [ $((i % 10)) -eq 0 ]; then
      throughput_values=${throughput_values::-2}
      echo "--batch $batch --parallelism: $parallelism; --cpu-pinning: $cpu_pinning;">> $output_file2
      echo " Throughput: $throughput_values">> $output_file2
      echo "" >> $output_file1
      echo "" >> $output_file1
      echo "" >> $output_file2

      if [ $i -eq 10 ]; then
        throughput_values=""
        parallelism="2,2,2"
        batch=32
        cpu_pinning="3,35,19,51,11,27"


      elif [ $i -eq 20 ]; then
        throughput_values=""
        parallelism="2,2,2"
        batch=32
        cpu_pinning="1,33,9,25,17,49"

      elif [ $i -eq 30 ]; then
        throughput_values=""
        parallelism="2,2,2"
        batch=32
        cpu_pinning="3,35,11,27,19,51"

      elif [ $i -eq 40 ]; then
        throughput_values=""
        parallelism="2,2,2"
        batch=32
        cpu_pinning="1,17,9,41,25,57"

      elif [ $i -eq 50 ]; then
        throughput_values=""
        parallelism="2,2,2"
        batch=32
        cpu_pinning="3,19,11,43,27,59"

         #------------------------------------------- DA FARE

      elif [ $i -eq 60 ]; then
        throughput_values=""
        parallelism="2,2,2"
        batch=32
        cpu_pinning="1,9,17,25,33,41"

      elif [ $i -eq 70 ]; then
        throughput_values=""
        parallelism="2,2,2"
        batch=32
        cpu_pinning="3,11,19,27,35,43"

        #--------------------------------------

      elif [ $i -eq 80 ]; then
        throughput_values=""
        parallelism="4,4,4"
        batch=0
        cpu_pinning="2,18,34,50,10,26,42,58,0,16,32,48"

      elif [ $i -eq 90 ]; then
        throughput_values=""
        parallelism="4,4,4"
        batch=0
        cpu_pinning="2,34,10,42,18,50,26,58,0,16,32,48"


      elif [ $i -eq 100 ]; then
        throughput_values=""
        parallelism="4,4,4"
        batch=0
        cpu_pinning="2,10,0,8,18,26,16,24,34,42,32,56"


      elif [ $i -eq 110 ]; then
        throughput_values=""
        parallelism="1,1,1"
        batch=0
        cpu_pinning="2,18,34"


      elif [ $i -eq 120 ]; then
        throughput_values=""
        parallelism="1,1,1"
        batch=32
        cpu_pinning="2,18,34"


      #elif [ $i -eq 130 ]; then
      #  throughput_values=""


      fi
    fi
done


