#!/bin/bash

# Numero di esecuzioni
n_runs=10
current_run=1

# File di log per raccogliere gli output
output_file1="log/throughput_log.txt"
output_file2="log/throughput_compact_log.txt"

throughput_values=""

# Pulisce il file log se già esistente
> $output_file1
> $output_file2

# Funzione per trovare la potenza di 10 più grande minore o uguale a un numero
get_previous_power_of_10() {
    num=$1
    echo $(( (num - 1) / 10 * 10 + 1 ))  # Calcola la potenza di 10 precedente
}


# Funzione per impostare i parametri in base al valore di `i`
set_parameters() {
    local i=$1
    if [ $i -le 10 ]; then
        parallelism="8,8,8"
        batch=0
        cpu_pinning="1,9,3,11,5,13,7,15,17,25,19,27,21,29,23,31,33,57,35,43,37,43,39,47"
    elif [ $i -le 20 ]; then
        parallelism="4,4,4"
        batch=0
        cpu_pinning="3,11,1,9,19,27,17,25,35,43,33,57"
    elif [ $i -le 30 ]; then
        parallelism="4,4,4"
        batch=0
        cpu_pinning="3,51,43,17,19,11,59,33,35,27,1,49"
    elif [ $i -le 40 ]; then
        parallelism="4,4,4"
        batch=32
        cpu_pinning="3,35,11,43,1,17,33,49,19,51,27,59"
    elif [ $i -le 50 ]; then
        parallelism="4,4,4"
        batch=32
        cpu_pinning="3,11,1,9,19,27,17,25,35,43,33,57"
    elif [ $i -le 60 ]; then
        parallelism="4,4,4"
        batch=32
        cpu_pinning="3,51,43,17,19,11,59,33,35,27,1,49"

    elif [ $i -le 70 ]; then
        parallelism="8,8,8"
        batch=0
        cpu_pinning="1,17,33,49,9,25,41,57,3,19,35,51,11,27,43,59,5,21,37,53,13,29,45,61"
    elif [ $i -le 80 ]; then
        parallelism="8,8,8"
        batch=0
        cpu_pinning="1,9,3,11,5,13,7,15,17,25,19,27,21,29,23,31,33,57,35,43,37,45,39,47"
    elif [ $i -le 90 ]; then
        parallelism="8,8,8"
        batch=0
        cpu_pinning="1,49,41,17,11,59,37,29,17,9,57,35,27,5,53,45,33,25,3,51,43,25,13,61"
    elif [ $i -le 100 ]; then
        parallelism="8,8,8"
        batch=32
        cpu_pinning="1,17,33,49,9,25,41,57,3,19,35,51,11,27,43,59,5,21,37,53,13,29,45,61"
    elif [ $i -le 120 ]; then
        parallelism="8,8,8"
        batch=32
        cpu_pinning="1,9,3,11,5,13,7,15,17,25,19,27,21,29,23,31,33,57,35,43,37,45,39,47"
    elif [ $i -le 130 ]; then
        parallelism="8,8,8"
        batch=32
        cpu_pinning="1,49,41,17,11,59,37,29,17,9,57,35,27,5,53,45,33,25,3,51,43,25,13,61"

    fi
}

# Funzione per eseguire i test
run_tests() {

    throughput_values=""
    for ((i=current_run; i<=n_runs; i++))
    do
        echo "Execution $i:"

        utenti_connessi=$(w | wc -l)
        utenti_connessi=$((utenti_connessi - 2))

        # Controlla se il numero di utenti è maggiore di 1
        if [ "$utenti_connessi" -gt 1 ]; then
            echo "There are more than 1 user logged on. Interruption of tests..."
            current_run=$i
            return 1  # Esci dalla funzione in modo che il ciclo esterno riparta
        fi

        # Imposta i parametri corretti in base al valore di i
        set_parameters $i

        # azzera throughput_values
        if [ $((i % 10)) -eq 1 ]; then
            throughput_values=""
        fi

        # Esegue il programma e cattura l'output desiderato
        output=$(././bin/fd --rate 0 --keys 0 --sampling 1000 --batch $batch --parallelism $parallelism --cpu-pinning $cpu_pinning | grep "Measured throughput")

        echo "$output"

        if [ -z "$output" ]; then
            echo "Error: 'Measured throughput:' not found $i" >> $output_file1
        else
           throughput1=$(echo $output | grep -o '[0-9.]\+ tuples/seconds')
           throughput2=$(echo $output | grep -o '[0-9.]\+' | tail -n 1)

           throughput_values+="$throughput2;"
           echo "Execution $i (--batch $batch --parallelism: $parallelism --cpu-pinning $cpu_pinning), Throughput: $throughput1" >> $output_file1
           echo "" >> $output_file1
        fi

        if [ $((i % 10)) -eq 0 ] ; then
              throughput_values=${throughput_values::-1}
              echo "--batch $batch --parallelism: $parallelism --cpu-pinning $cpu_pinning;">> $output_file2
              echo " Throughput: $throughput_values">> $output_file2
              echo "" >> $output_file1
              echo "" >> $output_file1
              echo "" >> $output_file2
        fi
    done
    return 0
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
      echo "There are still $utenti_connessi logged in users. Wait 1 minute..."
      sleep 60  # Attende 1 minuto
      utenti_connessi=$(w | wc -l)
      utenti_connessi=$((utenti_connessi - 2))  # Aggiorna il numero di utenti
    done

    # Prima di riprendere, calcola la potenza di 10 più grande minore o uguale al run corrente
    if [ $current_run -gt 1 ]; then
        current_run=$(get_previous_power_of_10 $current_run)
        echo "Continuing from execution number $current_run"
    fi

    # Esegui i test
    run_tests

    # Se la funzione run_tests ha terminato correttamente, esci dal ciclo
    if [ $? -eq 0 ]; then
        echo "Tests successfully completed"
        break
    else
        echo "Tests has been intrrupted."
    fi
done

