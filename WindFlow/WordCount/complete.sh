#!/bin/bash

# Numero di esecuzioni
n_runs=770
current_run=601

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
        cpu_pinning="2,18,34,50"
    elif [ $i -le 20 ]; then
        parallelism="1,1,1,1"
        batch=32
        cpu_pinning="2,18,34,50"
    elif [ $i -le 30 ]; then
        parallelism="2,2,2,2"
        batch=0
        cpu_pinning="0,16,32,48,8,24,40,56"
    elif [ $i -le 40 ]; then
        parallelism="2,2,2,2"
        batch=0
        cpu_pinning="2,18,34,50,10,26,42,58"
    elif [ $i -le 50 ]; then
        parallelism="2,2,2,2"
        batch=0
        cpu_pinning="0,16,8,24,40,56,32,48"
    elif [ $i -le 60 ]; then
        parallelism="2,2,2,2"
        batch=0
        cpu_pinning="2,18,10,26,42,58,34,50"
    elif [ $i -le 70 ]; then
        parallelism="2,2,2,2"
        batch=0
        cpu_pinning="0,16,8,24,32,48,40,56"
    elif [ $i -le 80 ]; then
        parallelism="2,2,2,2"
        batch=0
        cpu_pinning="2,18,10,26,34,50,42,58"
    elif [ $i -le 90 ]; then
        parallelism="2,2,2,2"
        batch=0
        cpu_pinning="0,8,16,24,32,40,48,56"
    elif [ $i -le 100 ]; then
        parallelism="2,2,2,2"
        batch=0
        cpu_pinning="2,10,18,26,34,42,50,58"
    elif [ $i -le 110 ]; then
        parallelism="2,2,2,2"
        batch=0
        cpu_pinning="1,33,17,49,9,41,25,57"
    elif [ $i -le 120 ]; then
        parallelism="2,2,2,2"
        batch=0
        cpu_pinning="3,35,19,51,11,43,27,59"
    elif [ $i -le 130 ]; then
        parallelism="2,2,2,2"
        batch=0
        cpu_pinning="1,33,9,41,25,57,17,49"
    elif [ $i -le 140 ]; then
        parallelism="2,2,2,2"
        batch=0
        cpu_pinning="3,35,11,43,27,59,19,51"
    elif [ $i -le 150 ]; then
        parallelism="2,2,2,2"
        batch=0
        cpu_pinning="1,33,9,41,17,49,25,57"
    elif [ $i -le 160 ]; then
        parallelism="2,2,2,2"
        batch=0
        cpu_pinning="3,35,11,43,19,51,27,59"
    elif [ $i -le 170 ]; then
        parallelism="2,2,2,2"
        batch=0
        cpu_pinning="1,9,17,25,33,41,49,57"
    elif [ $i -le 180 ]; then
        parallelism="2,2,2,2"
        batch=0
        cpu_pinning="3,11,19,27,35,43,51,59"
    elif [ $i -le 190 ]; then
        parallelism="2,2,2,2"
        batch=0
        cpu_pinning="0,64,18,26,32,96,48,112"
    elif [ $i -le 200 ]; then
        parallelism="2,2,2,2"
        batch=0
        cpu_pinning="0,2,16,18,34,42,48,50"
    elif [ $i -le 210 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="0,16,32,48,8,24,40,56"
    elif [ $i -le 220 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="2,34,18,50,10,42,26,58"
    elif [ $i -le 230 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="0,16,8,24,40,56,32,48"
    elif [ $i -le 240 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="2,34,10,42,26,58,18,50"
    elif [ $i -le 250 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="0,16,8,24,32,48,40,56"
    elif [ $i -le 260 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="2,34,10,42,18,50,26,58"
    elif [ $i -le 270 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="0,8,16,24,32,40,48,56"
    elif [ $i -le 280 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="2,10,18,26,34,42,50,58"
    elif [ $i -le 290 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="1,33,17,49,9,41,25,57"
    elif [ $i -le 300 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="3,35,19,51,11,43,27,59"
    elif [ $i -le 310 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="1,33,9,41,25,57,17,49"
    elif [ $i -le 320 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="3,35,11,43,27,59,19,51"
    elif [ $i -le 330 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="1,33,9,41,17,49,25,57"
    elif [ $i -le 340 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="3,35,11,43,19,51,27,59"
    elif [ $i -le 350 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="1,9,17,25,33,41,49,57"
    elif [ $i -le 360 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="3,11,19,27,35,43,51,59"
    elif [ $i -le 370 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="0,64,18,26,32,96,48,112"
    elif [ $i -le 380 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="0,2,16,18,34,42,48,50"
    elif [ $i -le 390 ]; then
        parallelism="4,4,4,4"
        batch=0
        cpu_pinning="0,16,32,48,2,18,34,50,10,26,42,58,8,24,40,56"
    elif [ $i -le 400 ]; then
        parallelism="4,4,4,4"
        batch=0
        cpu_pinning="0,8,2,10,16,24,18,26,32,40,34,42,48,56,50,58"
    elif [ $i -le 410 ]; then
        parallelism="4,4,4,4"
        batch=0
        cpu_pinning="2,10,3,11,18,26,19,27,34,42,35,43,50,58,51,59"
    elif [ $i -le 420 ]; then
        parallelism="4,4,4,4"
        batch=0
        cpu_pinning="1,9,3,11,17,25,19,27,33,41,35,43,49,57,51,59"
    elif [ $i -le 430 ]; then
        parallelism="4,4,4,4"
        batch=0
        cpu_pinning="2,34,10,42,18,50,26,58,0,32,8,40,16,48,24,56"
    elif [ $i -le 440 ]; then
        parallelism="4,4,4,4"
        batch=0
        cpu_pinning="3,35,11,43,19,51,27,59,1,33,9,41,17,49,25,57"
    elif [ $i -le 450 ]; then
        parallelism="4,4,4,4"
        batch=0
        cpu_pinning="2,50,42,16,18,10,58,32,34,26,0,48,8,24,40,56"
    elif [ $i -le 460 ]; then
        parallelism="4,4,4,4"
        batch=0
        cpu_pinning="3,51,43,17,19,11,59,33,35,27,1,49,9,25,41,57"
    elif [ $i -le 470 ]; then
        parallelism="4,4,4,4"
        batch=0
        cpu_pinning="2,34,10,42,0,32,8,40,16,48,24,56,18,26,50,58"
    elif [ $i -le 480 ]; then
        parallelism="4,4,4,4"
        batch=0
        cpu_pinning="0,32,8,24,2,34,10,42,18,50,26,58,16,48,40,56"
    elif [ $i -le 490 ]; then
        parallelism="4,4,4,4"
        batch=0
        cpu_pinning="0,32,8,40,2,18,34,50,10,26,42,58,16,48,24,56"
    elif [ $i -le 500 ]; then
        parallelism="4,4,4,4"
        batch=0
        cpu_pinning="0,16,32,48,2,18,34,50,10,26,42,58,8,24,40,56"
    elif [ $i -le 510 ]; then
        parallelism="4,4,4,4"
        batch=0
        cpu_pinning="2,34,10,42,0,32,8,40,18,50,26,58,16,48,24,56"
    elif [ $i -le 520 ]; then
        parallelism="4,4,4,4"
        batch=0
        cpu_pinning="3,35,11,43,1,33,9,41,19,51,27,59,17,49,25,57"
    elif [ $i -le 530 ]; then
        parallelism="4,4,4,4"
        batch=32
        cpu_pinning="0,8,2,10,16,24,18,26,32,40,34,42,48,56,50,58"
    elif [ $i -le 540 ]; then
        parallelism="4,4,4,4"
        batch=32
        cpu_pinning="1,9,3,11,17,25,19,27,33,41,35,43,49,57,51,59"
    elif [ $i -le 550 ]; then
        parallelism="4,4,4,4"
        batch=32
        cpu_pinning="2,10,3,11,18,26,19,27,34,42,35,43,50,58,51,59"
    elif [ $i -le 560 ]; then
        parallelism="4,4,4,4"
        batch=32
        cpu_pinning="2,34,10,42,18,50,26,58,0,32,8,40,16,48,24,56"
    elif [ $i -le 570 ]; then
        parallelism="4,4,4,4"
        batch=32
        cpu_pinning="2,34,10,42,0,32,8,40,16,48,24,56,18,26,50,58"
    elif [ $i -le 580 ]; then
        parallelism="4,4,4,4"
        batch=32
        cpu_pinning="3,35,11,43,1,33,9,41,17,49,25,57,19,27,51,59"
    elif [ $i -le 590 ]; then
        parallelism="4,4,4,4"
        batch=32
        cpu_pinning="2,34,10,42,0,32,8,40,18,26,50,58,16,48,24,56"
    elif [ $i -le 600 ]; then
        parallelism="8,8,8,8"
        batch=0
        cpu_pinning="0,16,32,48,8,24,40,56,2,18,34,50,10,26,42,58,4,20,36,52,12,28,44,60,6,22,38,54,14,30,46,62"
    elif [ $i -le 610 ]; then
        parallelism="8,8,8,8"
        batch=0
        cpu_pinning="0,8,2,10,4,12,6,14,16,24,18,26,20,28,22,30,32,40,34,42,36,44,38,46,48,56,50,58,52,60,54,62"
    elif [ $i -le 620 ]; then
        parallelism="8,8,8,8"
        batch=0
        cpu_pinning="1,9,3,11,5,13,7,15,17,25,19,27,21,29,23,31,33,41,35,43,37,45,39,47,49,57,51,59,53,61,55,63"
    elif [ $i -le 630 ]; then
        parallelism="8,8,8,8"
        batch=0
        cpu_pinning="0,8,2,10,1,9,3,11,16,24,18,26,17,25,19,27,32,40,34,42,33,41,35,43,48,56,50,58,49,57,51,59"
    elif [ $i -le 640 ]; then
        parallelism="8,8,8,8"
        batch=0
        cpu_pinning="1,33,9,41,3,35,11,43,17,49,25,57,19,51,27,59,5,37,13,45,7,39,15,47,21,53,29,61,23,55,31,63"
    elif [ $i -le 650 ]; then
        parallelism="8,8,8,8"
        batch=0
        cpu_pinning="1,49,41,19,11,59,37,29,17,9,57,35,27,5,53,45,33,25,3,51,43,21,13,61,7,23,39,55,15,31,47,63"
    elif [ $i -le 660 ]; then
        parallelism="8,8,8,8"
        batch=0
        cpu_pinning="0,32,8,40,4,36,12,44,2,34,10,42,6,38,14,46,18,50,26,58,22,54,30,62,16,48,24,56,20,52,28,60"
    elif [ $i -le 670 ]; then
        parallelism="8,8,8,8"
        batch=0
        cpu_pinning="1,33,9,41,5,37,13,45,3,35,11,43,7,39,15,47,19,51,27,59,23,55,31,63,17,49,25,57,21,53,29,61"
    elif [ $i -le 680 ]; then
        parallelism="8,8,8,8"
        batch=32
        cpu_pinning="0,16,32,48,8,24,40,56,2,18,34,50,10,26,42,58,4,20,36,52,12,28,44,60,6,22,38,54,14,30,46,62"
    elif [ $i -le 690 ]; then
        parallelism="8,8,8,8"
        batch=32
        cpu_pinning="1,17,33,49,9,25,41,57,3,19,35,51,11,27,43,59,5,21,37,53,13,29,45,61,6,22,38,54,14,30,46,62"
    elif [ $i -le 700 ]; then
        parallelism="8,8,8,8"
        batch=32
        cpu_pinning="0,8,2,10,4,12,6,14,16,24,18,26,20,28,22,30,32,40,34,42,36,44,38,46,48,56,50,58,52,60,54,62"
    elif [ $i -le 710 ]; then
        parallelism="8,8,8,8"
        batch=32
        cpu_pinning="1,9,3,11,5,13,7,15,17,25,19,27,21,29,23,31,33,41,35,43,37,45,39,47,49,57,51,59,53,61,55,63"
    elif [ $i -le 720 ]; then
        parallelism="8,8,8,8"
        batch=32
        cpu_pinning="0,8,2,10,1,9,3,11,16,24,18,26,17,25,19,27,32,40,34,42,33,41,35,43,48,56,50,58,49,57,51,59"
    elif [ $i -le 730 ]; then
        parallelism="8,8,8,8"
        batch=32
        cpu_pinning="1,33,9,41,3,35,11,43,17,49,25,57,19,51,27,59,5,37,13,45,7,39,15,47,21,53,29,61,23,55,31,63"
    elif [ $i -le 740 ]; then
        parallelism="8,8,8,8"
        batch=32
        cpu_pinning="1,49,41,19,11,59,37,29,17,9,57,35,27,5,53,45,33,25,3,51,43,21,13,61,7,23,39,55,15,31,47,63"
    elif [ $i -le 750 ]; then
        parallelism="8,8,8,8"
        batch=32
        cpu_pinning="1,33,9,41,5,37,13,45,3,35,11,43,7,39,15,47,17,49,25,57,21,53,29,61,19,51,27,59,23,55,31,63"
    elif [ $i -le 760 ]; then
        parallelism="8,8,8,8"
        batch=32
        cpu_pinning="0,32,8,40,4,36,12,44,2,34,10,42,6,38,14,46,18,50,26,58,22,54,30,62,16,48,24,56,20,52,28,60"
    elif [ $i -le 770 ]; then
        parallelism="8,8,8,8"
        batch=32
        cpu_pinning="1,33,9,41,5,37,13,45,3,35,11,43,7,39,15,47,19,51,27,59,23,55,31,63,17,49,25,57,21,53,29,61"




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
        output=$(././bin/wc --rate 0 --sampling 1000 --batch $batch --parallelism $parallelism --cpu-pinning $cpu_pinning | grep "Measured throughput")

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
        echo "Tests has been interrupted."
    fi
done

exit
