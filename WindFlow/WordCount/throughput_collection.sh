#!/bin/bash

# Numero di esecuzioni
n_runs=30
current_run=1

# File di log per raccogliere gli output
output_file1="log/throughput_log.txt"
output_file2="log/throughput_compact_log.txt"

throughput_values=""

# Pulisce il file log se già esistente
> $output_file1
> $output_file2


# Funzione per eseguire i test
run_tests() {

    parallelism="2,2,2,2"
    batch=32
    cpu_pinning="1,33,17,49,9,41,25,57"

    throughput_values=""
    for ((i=current_run; i<=n_runs; i++))
    do
        echo "Execution $i:"

        utenti_connessi=$(w | wc -l)
        utenti_connessi=$((utenti_connessi - 2))

        # Controlla se il numero di utenti è maggiore di 1
        if [ "$utenti_connessi" -gt 1 ]; then
            echo "Ci sono più di 1 utente connesso. Fermando i test..."
            current_run=$i
            return 1  # Esci dalla funzione in modo che il ciclo esterno riparta
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
                parallelism="2,2,2,2"
                batch=32
                cpu_pinning="1,9,17,25,33,41,49,57"

              elif [ $i -eq 20 ]; then
                throughput_values=""
                parallelism="2,2,2,2"
                batch=32
                cpu_pinning="3,11,19,27,35,43,51,59"

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


              elif [ $i -eq 170 ]; then
                throughput_values=""


              elif [ $i -eq 180 ]; then
                throughput_values=""


              fi
            fi
    done
    return 0
}

# Funzione per trovare la potenza di 10 più grande minore o uguale a un numero
get_previous_power_of_10() {
    num=$1
    echo $(( (num - 1) / 10 * 10 + 1 ))  # Calcola la potenza di 10 precedente
}

# Ciclo esterno che continua a rieseguire i test finché ci sono utenti collegati
while true
do
    # Controlla se ci sono utenti connessi
    utenti_connessi=$(w | wc -l)
    utenti_connessi=$((utenti_connessi - 2))

    # Se ci sono utenti connessi, attende
    while [ "$utenti_connessi" -gt 1 ]
    do
      echo "Ci sono ancora $utenti_connessi utenti connessi. Attendo 1 minuto..."
      sleep 60  # Attende 1 minuto
      utenti_connessi=$(w | wc -l)
      utenti_connessi=$((utenti_connessi - 2))  # Aggiorna il numero di utenti
    done

    # Prima di riprendere, calcola la potenza di 10 più grande minore o uguale al run corrente
    if [ $current_run -gt 1 ]; then
        current_run=$(get_previous_power_of_10 $current_run)
        echo "Riprendendo dall'esecuzione numero $current_run"
    fi

    # Esegui i test
    run_tests

    # Se la funzione run_tests ha terminato correttamente, esci dal ciclo
    if [ $? -eq 0 ]; then
        echo "Test completati con successo."
        break
    else
        echo "I test sono stati interrotti."
    fi
done
