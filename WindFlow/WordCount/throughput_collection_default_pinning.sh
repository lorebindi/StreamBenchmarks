#!/bin/bash

# Numero di esecuzioni
n_runs=40

# File di log per raccogliere gli output
output_file1="log/throughput_log.txt"
output_file2="log/throughput_compact_log.txt"

throughput_values=""

# Pulisce il file log se già esistente
> $output_file1
> $output_file2

parallelism="1,1,1,1"
cpu_pinning=""
batch="32"

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

    # Esegue il programma e cattura l'output desiderato
    output=$(././bin/wc --rate 0 --sampling 1000 --batch $batch --parallelism $parallelism | grep "Measured throughput")

    echo "$output"

    if [ -z "$output" ]; then
        echo "Errore: 'Measured throughput:' non trovato nell'esecuzione $i" >> $output_file1
    else
       throughput1=$(echo $output | grep -o '[0-9.]\+ MB/s')
       throughput2=$(echo $output | grep -o '[0-9.]\+' | tail -n 1)

       throughput2=$(echo $throughput2 | sed 's/\./,/g')

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
        parallelism="2,2,2,2"
        #cpu_pinning="0,64,16,80,32,96,48,112"

      elif [ $i -eq 20 ]; then
        throughput_values=""
        parallelism="4,4,4,4"
        #cpu_pinning="0,2,16,18,32,34,48,50"

      elif [ $i -eq 30 ]; then
        throughput_values=""
        parallelism="8,8,8,8"
        #cpu_pinning="2,10,18,26,34,42,50,58"

      #elif [ $i -eq 40 ]; then
        #throughput_values=""
        #parallelism="4,4,4,4"
        #cpu_pinning="0,8,2,10,16,24,18,26,32,40,34,42,48,56,50,58"

      #elif [ $i -eq 50 ]; then
      #  throughput_values=""
      #  parallelism="4,4,4,4"
        #cpu_pinning="2,10,3,11,18,26,19,27,34,42,35,43,50,58,51,59"

      #elif [ $i -eq 60 ]; then
      #  throughput_values=""
      #  parallelism="4,4,4,4"
      #  #cpu_pinning="2,34,10,42,18,50,26,58,0,32,8,40,16,48,24,56"

      #elif [ $i -eq 70 ]; then
      #  throughput_values=""
      #  parallelism="4,4,4,4"
      #  #cpu_pinning="2,10,34,42,0,8,32,40,16,24,48,56,18,26,50,58"

      #elif [ $i -eq 80 ]; then
      #  throughput_values=""
      #  parallelism="4,4,4,4"
        #cpu_pinning="2,10,34,42,0,8,32,40,18,26,50,58,16,24,48,56"

      #elif [ $i -eq 90 ]; then
      #  throughput_values=""
      #  parallelism="8,8,8,8"
        #cpu_pinning="0,8,2,10,4,12,6,14,16,24,18,26,20,28,22,30,32,40,34,42,36,44,38,46,48,56,50,58,52,60,54,62"

      #elif [ $i -eq 100 ]; then
      #  throughput_values=""
      #  parallelism="8,8,8,8"
        #cpu_pinning="0,8,2,10,4,12,6,14,16,24,18,26,20,28,22,30,32,40,34,42,36,44,38,46,48,56,50,58,52,60,54,62"

      #elif [ $i -eq 110 ]; then
      #  throughput_values=""
      #  parallelism="8,8,8,8"
        #cpu_pinning="0,8,2,10,1,9,3,11,16,24,18,26,17,25,19,27,32,40,34,42,33,41,35,43,48,56,50,58,49,57,51,59"

      #elif [ $i -eq 120 ]; then
      #  throughput_values=""
      #  parallelism="8,8,8,8"
        #cpu_pinning="0,32,8,40,2,34,10,28,4,36,12,44,6,38,14,46,20,52,28,60,22,54,30,62,16,48,24,56,18,50,26,30"

      fi
    fi
done

