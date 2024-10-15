
# Funzione per avviare il profiler
start_profiler() {
    # Parametri del profiler
    ccd=$1
    output_file=$2
    duration=$3
    sudo /opt/AMDuProf_4.2-850/bin/AMDuProfPcm -m l3 -c ccd=$ccd -d $duration -o "$HOME/$output_file" &

    # Salvare il PID del profiler
    profiler_pid=$!
    echo "Profiler avviato con PID $profiler_pid"
}

wait_for_no_users() {
    utenti_connessi=$(w | wc -l)
    utenti_connessi=$((utenti_connessi - 2))  # Sottrai 2 per ignorare l'intestazione

    while [ "$utenti_connessi" -gt 1 ]; do
        echo "There are still $utenti_connessi logged in users. Wait 1 minute..."
        sleep 60  # Aspetta 1 minuto
        utenti_connessi=$(w | wc -l)
        utenti_connessi=$((utenti_connessi - 2))  # Sottrai 2 per ignorare l'intestazione
    done
    echo "Start Execution."
}

start_application(){
      batch=$1
      parallelism=$2
      cpu_pinning=$3

      sleep 5

      ./bin/sd --rate 0 --keys 0 --sampling 1000 --batch $batch --parallelism $parallelism --cpu-pinning $cpu_pinning &

      # Salvare il PID dell'applicazione
      app_pid=$!
      echo "Applicazione avviata con PID $app_pid"

      # Aspetta che l'applicazione termini
      wait $app_pid
      echo "Applicazione terminata."
}

# Applicazioni da prorfilare
run_workloads() {
    wait_for_no_users
    start_profiler "4,5" "StreamBenchmarks/WindFlow/SpikeDetection/profiling_files/N5_src-m-fltr-src_N4_src-m-fltr-src_snk-snk-snk-snk.csv" "100"
    start_application 0 "4,4,4,4" "3,51,43,17,19,11,59,33,35,27,1,49,9,25,41,57"
    wait $profiler_pid
    echo "Profiler terminato."

    wait_for_no_users
    start_profiler "4,5" "StreamBenchmarks/WindFlow/SpikeDetection/profiling_files/N5_src-snk_src-snk_N4_m-fltr_m-fltr.csv" "100"
    start_application 32 "4,4,4,4" "3,11,35,43,1,9,33,41,17,25,49,57,19,27,51,59"
    wait $profiler_pid
    echo "Profiler terminato."

    wait_for_no_users
    start_profiler "4,5" "StreamBenchmarks/WindFlow/SpikeDetection/profiling_files/N5_src-fltr_src-fltr_N4_m-snk_m-snk.csv" "100"
    start_application 32 "4,4,4,4" "3,11,35,43,1,9,33,41,19,27,51,59,17,25,49,57"
    wait $profiler_pid
    echo "Profiler terminato."
}

run_workloads