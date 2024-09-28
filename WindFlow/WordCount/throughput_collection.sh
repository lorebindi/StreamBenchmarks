#!/bin/bash

# Numero di esecuzioni
n_runs=20

# File di log per raccogliere gli output
output_file1="log/throughput_log.txt"
output_file2="log/throughput_compact_log.txt"

throughput_values=""

# Pulisce il file log se già esistente
> $output_file1
> $output_file2

parallelism="4,4,4,4"
cpu_pinning="2,34,10,42,0,32,8,40,16,48,24,56,18,26,50,58"
batch=32

# Controlla se ci sono utenti connessi
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


for ((i=1; i<=n_runs; i++))
do
    echo "Execution $i:"

    utenti_connessi=$(w | wc -l)
    utenti_connessi=$((utenti_connessi - 2))

    # Controlla se il numero di utenti è maggiore di 1
    if [ "$utenti_connessi" -gt 1 ]; then
        echo $utenti_connessi
        echo "Ci sono più di 1 utente connesso."
        exit 1
    fi

    # Esegue il programma e cattura l'output desiderato
    output=$(././bin/wc --rate 0 --sampling 1000 --batch $batch --parallelism $parallelism --cpu-pinning $cpu_pinning | grep "Measured throughput")

    echo "$output"

    if [ -z "$output" ]; then
        echo "Errore: 'Measured throughput:' non trovato nell'esecuzione $i" >> $output_file1
    else
       throughput1=$(echo $output | grep -o '[0-9.]\+ MB/s')
       throughput2=$(echo $output | grep -o '[0-9.]\+' | tail -n 1)

       throughput2=$(echo $throughput2 | sed 's/\./,/g')

       throughput_values+="$throughput2; "
       echo "Esecuzione $i (--batch $batch --parallelism: $parallelism --cpu-pinning: $cpu_pinning), Throughput: $throughput1" >> $output_file1
       echo "" >> $output_file1
    fi

    if [ $((i % 10)) -eq 0 ] ; then
      throughput_values=${throughput_values::-2}
      echo "--batch $batch --parallelism: $parallelism; --cpu-pinning: $cpu_pinning;">> $output_file2
      echo " Throughput: $throughput_values">> $output_file2
      echo "" >> $output_file1
      echo "" >> $output_file1
      echo "" >> $output_file2

      if [ $i -eq 10 ]; then
        throughput_values=""
        parallelism="4,4,4,4"
        cpu_pinning="2,34,10,42,0,32,8,40,18,26,50,58,16,48,24,56"

      elif [ $i -eq 20 ]; then
        throughput_values=""

      elif [ $i -eq 30 ]; then
        throughput_values=""


      elif [ $i -eq 40 ]; then
        throughput_values=""


      elif [ $i -eq 50 ]; then
        throughput_values=""


      elif [ $i -eq 60 ]; then
        throughput_values=""


      elif [ $i -eq 70 ]; then
        throughput_values=""


      elif [ $i -eq 80 ]; then
        throughput_values=""


      elif [ $i -eq 90 ]; then
        throughput_values=""


      elif [ $i -eq 100 ]; then
        throughput_values=""


      elif [ $i -eq 110 ]; then
        throughput_values=""



      elif [ $i -eq 120 ]; then
        throughput_values=""


      elif [ $i -eq 130 ]; then
        throughput_values=""



      elif [ $i -eq 140 ]; then
        throughput_values=""



      elif [ $i -eq 150 ]; then
        throughput_values=""


      elif [ $i -eq 160 ]; then
        throughput_values=""



      fi
    fi
done

