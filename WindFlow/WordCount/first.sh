#!/bin/bash

# Numero di esecuzioni
n_runs=300
current_run=161

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
    if [ $i -le 10 ]; then
        parallelism="1,1,1,1"
        batch=0
    elif [ $i -le 20 ]; then
        parallelism="1,1,1,1"
        batch=2
    elif [ $i -le 30 ]; then
        parallelism="1,1,1,1"
        batch=4
    elif [ $i -le 40 ]; then
        parallelism="1,1,1,1"
        batch=8
    elif [ $i -le 50 ]; then
        parallelism="1,1,1,1"
        batch=16
    elif [ $i -le 60 ]; then
        parallelism="1,1,1,1"
        batch=32
    elif [ $i -le 70 ]; then
        parallelism="2,2,2,2"
        batch=0
    elif [ $i -le 80 ]; then
        parallelism="2,2,2,2"
        batch=2
    elif [ $i -le 90 ]; then
        parallelism="2,2,2,2"
        batch=4
    elif [ $i -le 100 ]; then
        parallelism="2,2,2,2"
        batch=8
    elif [ $i -le 110 ]; then
        parallelism="2,2,2,2"
        batch=16
    elif [ $i -le 120 ]; then
        parallelism="2,2,2,2"
        batch=32
    elif [ $i -le 130 ]; then
        parallelism="4,4,4,4"
        batch=2
    elif [ $i -le 140 ]; then
        parallelism="4,4,4,4"
        batch=0
    elif [ $i -le 150 ]; then
        parallelism="4,4,4,4"
        batch=4
    elif [ $i -le 160 ]; then
        parallelism="4,4,4,4"
        batch=8
    elif [ $i -le 170 ]; then
        parallelism="4,4,4,4"
        batch=16
    elif [ $i -le 180 ]; then
        parallelism="4,4,4,4"
        batch=32
    elif [ $i -le 190 ]; then
        parallelism="8,8,8,8"
        batch=0
    elif [ $i -le 200 ]; then
        parallelism="8,8,8,8"
        batch=2
    elif [ $i -le 210 ]; then
        parallelism="8,8,8,8"
        batch=4
    elif [ $i -le 220 ]; then
        parallelism="8,8,8,8"
        batch=8
    elif [ $i -le 230 ]; then
        parallelism="8,8,8,8"
        batch=16
    elif [ $i -le 240 ]; then
        parallelism="8,8,8,8"
        batch=32
    elif [ $i -le 250 ]; then
        parallelism="16,16,16,16"
        batch=0
    elif [ $i -le 260 ]; then
        parallelism="16,16,16,16"
        batch=2
    elif [ $i -le 270 ]; then
        parallelism="16,16,16,16"
        batch=4
    elif [ $i -le 280 ]; then
        parallelism="16,16,16,16"
        batch=8
    elif [ $i -le 290 ]; then
        parallelism="16,16,16,16"
        batch=16
    elif [ $i -le 300 ]; then
        parallelism="16,16,16,16"
        batch=32

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
        output=$(././bin/wc --rate 0 --sampling 1000 --batch $batch --parallelism $parallelism | grep "Measured throughput")

        echo "$output"

        if [ -z "$output" ]; then
            echo "Error: 'Measured throughput:' not found $i" >> $output_file1
        else
           throughput1=$(echo $output | grep -o '[0-9.]\+ MB/s')
           throughput2=$(echo $output | grep -o '[0-9.]\+' | tail -n 1)

           throughput2=$(echo $throughput2 | sed 's/\./,/g')

           # Aggiunge il throughput se non vuoto
           if [ ! -z "$throughput2" ]; then
              throughput_values+="$throughput2;"
           fi

           echo "Execution $i (--batch $batch --parallelism: $parallelism), Throughput: $throughput1" >> $output_file1
           echo "" >> $output_file1
        fi

        if [ $((i % 10)) -eq 0 ] ; then
              throughput_values=${throughput_values::-1}
              echo "--batch $batch --parallelism: $parallelism;">> $output_file2
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
        echo "Tests has been interrupted."
    fi
done

exit