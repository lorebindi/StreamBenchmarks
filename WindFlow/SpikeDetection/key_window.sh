#!/bin/bash

# Numero di esecuzioni
n_runs=20
current_run=11

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

update_variables() {
    # Path del file constants.hpp
    local file="includes/util/constants.hpp"
    # Parametri: nuovo max_key e nuovo window_size
    local new_max_keys=$1
    local new_window_size=$2
    # Aggiornamento nel file costants.hpp
    sed -i "s/^\(size_t _moving_avg_win_size *= *\).*/\1${new_max_keys};/" "$file"
    sed -i "s/^\(inline int _max_keys *= *\).*/\1${new_window_size};/" "$file"
    # Stampa il risultato
    echo "Aggiornati: max_keys = $new_max_keys, window_size = $new_window_size"
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
        cpu_pinning="2,18,34,50,10,26,42,58"
    elif [ $i -le 40 ]; then
        parallelism="2,2,2,2"
        batch=0
        cpu_pinning="2,18,10,26,42,58,34,50"
    elif [ $i -le 50 ]; then
        parallelism="2,2,2,2"
        batch=0
        cpu_pinning="2,18,10,26,34,50,42,58"
    elif [ $i -le 60 ]; then
        parallelism="2,2,2,2"
        batch=0
        cpu_pinning="2,10,18,26,34,42,50,58"
    elif [ $i -le 70 ]; then
        parallelism="2,2,2,2"
        batch=0
        cpu_pinning="2,66,18,82,34,98,50,114"
    elif [ $i -le 80 ]; then
        parallelism="2,2,2,2"
        batch=0
        cpu_pinning="0,2,16,18,32,34,48,50"
    elif [ $i -le 90 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="2,18,34,50,10,26,42,58"
    elif [ $i -le 100 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="2,18,10,26,42,58,34,50"
    elif [ $i -le 110 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="2,18,10,26,34,50,42,58"
    elif [ $i -le 120 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="2,10,18,26,34,42,50,58"
    elif [ $i -le 130 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="2,66,18,82,34,98,50,114"
    elif [ $i -le 140 ]; then
        parallelism="2,2,2,2"
        batch=32
        cpu_pinning="0,2,16,18,32,34,48,50"
    elif [ $i -le 150 ]; then
        parallelism="4,4,4,4"
        batch=0
        cpu_pinning="3,19,35,51,11,27,43,59,1,17,33,49,9,25,41,57"
    elif [ $i -le 160 ]; then
        parallelism="4,4,4,4"
        batch=0
        cpu_pinning="1,9,3,11,17,25,19,27,33,41,35,43,49,57,51,59"
    elif [ $i -le 170 ]; then
        parallelism="4,4,4,4"
        batch=0
        cpu_pinning="2,10,3,11,18,26,19,27,34,42,35,43,50,58,51,59"
    elif [ $i -le 180 ]; then
        parallelism="4,4,4,4"
        batch=0
        cpu_pinning="3,35,11,43,19,51,27,59,1,33,9,41,17,49,25,57"
    elif [ $i -le 190 ]; then
        parallelism="4,4,4,4"
        batch=0
        cpu_pinning="3,51,43,17,19,11,59,33,35,27,1,49,9,25,41,57"
    elif [ $i -le 200 ]; then
        parallelism="4,4,4,4"
        batch=0
        cpu_pinning="3,35,11,43,1,33,9,41,17,49,25,57,19,51,27,59"
    elif [ $i -le 210 ]; then
        parallelism="4,4,4,4"
        batch=0
        cpu_pinning="3,35,11,43,1,33,9,41,19,51,27,59,17,49,25,57"
    elif [ $i -le 220 ]; then
        parallelism="4,4,4,4"
        batch=32
        cpu_pinning="3,19,35,51,11,27,43,59,1,17,33,49,9,25,41,57"
    elif [ $i -le 230 ]; then
        parallelism="4,4,4,4"
        batch=32
        cpu_pinning="1,9,3,11,17,25,19,27,33,41,35,43,49,57,51,59"
    elif [ $i -le 240 ]; then
        parallelism="4,4,4,4"
        batch=32
        cpu_pinning="2,10,3,11,18,26,19,27,34,42,35,43,50,58,51,59"
    elif [ $i -le 250 ]; then
        parallelism="4,4,4,4"
        batch=32
        cpu_pinning="3,35,11,43,19,51,27,59,1,33,9,41,17,49,25,57"
    elif [ $i -le 260 ]; then
        parallelism="4,4,4,4"
        batch=32
        cpu_pinning="3,51,43,17,19,11,59,33,35,27,1,49,9,25,41,57"
    elif [ $i -le 270 ]; then
        parallelism="4,4,4,4"
        batch=32
        cpu_pinning="3,35,11,43,1,33,9,41,17,49,25,57,19,51,27,59"
    elif [ $i -le 280 ]; then
        parallelism="4,4,4,4"
        batch=32
        cpu_pinning="3,35,11,43,1,33,9,41,19,51,27,59,17,49,25,57"
    elif [ $i -le 290 ]; then
        parallelism="8,8,8,8"
        batch=0
        cpu_pinning="1,17,33,49,9,25,41,57,3,19,35,51,11,27,43,59,5,21,37,53,13,29,45,61,7,23,39,55,15,31,47,63"
    elif [ $i -le 300 ]; then
        parallelism="8,8,8,8"
        batch=0
        cpu_pinning="1,9,3,11,5,13,7,15,17,25,19,27,21,29,23,31,33,41,35,43,37,45,39,47,49,57,51,59,53,61,55,63"
    elif [ $i -le 310 ]; then
        parallelism="8,8,8,8"
        batch=0
        cpu_pinning="0,8,2,10,1,9,3,11,16,24,18,26,17,25,19,27,32,40,34,42,33,41,35,43,48,56,50,58,49,57,51,59"
    elif [ $i -le 320 ]; then
        parallelism="8,8,8,8"
        batch=0
        cpu_pinning="1,33,9,41,3,35,11,43,5,37,13,45,7,39,15,47,21,53,29,61,23,55,31,63,17,49,25,57,19,51,27,59"
    elif [ $i -le 330 ]; then
        parallelism="8,8,8,8"
        batch=32
        cpu_pinning="1,17,33,49,9,25,41,57,3,19,35,51,11,27,43,59,5,21,37,53,13,29,45,61,7,23,39,55,15,31,47,63"
    elif [ $i -le 340 ]; then
        parallelism="8,8,8,8"
        batch=32
        cpu_pinning="1,9,3,11,5,13,7,15,17,25,19,27,21,29,23,31,33,41,35,43,37,45,39,47,49,57,51,59,53,61,55,63"
    elif [ $i -le 350 ]; then
        parallelism="8,8,8,8"
        batch=32
        cpu_pinning="0,8,2,10,1,9,3,11,16,24,18,26,17,25,19,27,32,40,34,42,33,41,35,43,48,56,50,58,49,57,51,59"
    elif [ $i -le 360 ]; then
        parallelism="8,8,8,8"
        batch=32
        cpu_pinning="1,33,9,41,3,35,11,43,5,37,13,45,7,39,15,47,21,53,29,61,23,55,31,63,17,49,25,57,19,51,27,59"
    fi
}

last() {
  if [ $i -le 10 ]; then
    parallelism="8,8,8,8"
    batch=0
    cpu_pinning="1,33,9,41,3,35,11,43,17,49,25,57,19,51,27,59,5,37,13,45,7,39,15,47,21,53,29,61,23,55,31,63"
  elif [ $i -le 20 ]; then
    parallelism="8,8,8,8"
    batch=32
    cpu_pinning="1,33,9,41,3,35,11,43,17,49,25,57,19,51,27,59,5,37,13,45,7,39,15,47,21,53,29,61,23,55,31,63"
  fi
}

# Funzione per eseguire i test
run_tests() {
    local k=0 #indice max_key_values
    local w=2 #indice window_size_values

    # Valori possibili per max_keys e window_size
    local max_keys_values=(10000 50000 100000)      #10.000, 50.000, 100.000
    local window_size_values=(10000 100000 500000)  #10.000, 100.000, 500.000


    throughput_values=""
    while true
    do

      update_variables "${max_keys_values[k]}" "${window_size_values[w]}"


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
          #set_parameters $i
          last $i

          local current_max_key=${max_keys_values[k]}
          local current_window_size=${window_size_values[w]}

          # azzera throughput_values
          if [ $((i % 10)) -eq 1 ]; then
              throughput_values=""
          fi

          # Esegue il programma e cattura l'output desiderato
          output=$(././bin/sd --rate 0 --keys 0 --sampling 1000 --batch "$batch" --parallelism "$parallelism" --cpu-pinning "$cpu_pinning"  | grep "Measured throughput")

          echo "$output"

          if [ -z "$output" ]; then
              echo "Error: 'Measured throughput:' not found $i" >> $output_file1
          else
             throughput1=$(echo $output | grep -o '[0-9.]\+ tuples/second')
             throughput2=$(echo $output | grep -o '[0-9.]\+' | tail -n 1)

             # Aggiunge il throughput se non vuoto
             if [ ! -z "$throughput2" ]; then
                throughput_values+="$throughput2;"
             fi



             echo "Execution $i (--batch $batch --parallelism: $parallelism --cpu-pinning $cpu_pinning --window_size $current_window_size --max_key $current_max_key), Throughput: $throughput1" >> $output_file1
             echo "" >> $output_file1
          fi

          if [ $((i % 10)) -eq 0 ] ; then
                throughput_values=${throughput_values::-1}
                echo "--batch $batch --parallelism: $parallelism --cpu-pinning $cpu_pinning --window_size $current_window_size --max_key $current_max_key">> $output_file2
                echo " Throughput: $throughput_values">> $output_file2
                echo "" >> $output_file1
                echo "" >> $output_file1
                echo "" >> $output_file2
          fi
      done

      # aggiornamento k e w per cambiare max_key e window_size
      ((k++))
      current_run=1
      if [ $k -gt 2 ]; then
        k=0
        ((w++))
      fi

      if [ $k -gt 2 ] && [ $w -gt 2 ]; then
                break
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
