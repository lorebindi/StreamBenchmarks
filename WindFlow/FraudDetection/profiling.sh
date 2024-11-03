
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

      sleep 10

      ./bin/fd --rate 0 --keys 0 --sampling 1000 --batch $batch --parallelism $parallelism --cpu-pinning $cpu_pinning &

      # Salvare il PID dell'applicazione
      app_pid=$!
      echo "Applicazione avviata con PID $app_pid"

      # Aspetta che l'applicazione termini
      wait $app_pid
      echo "Applicazione terminata."
}

# Applicazioni da prorfilare
run_workloads() {

#    wait_for_no_users
#    start_profiler "5" "StreamBenchmarks/WindFlow/FraudDetection/profiling_files/--par=2_--b=0_N5_src-fltr-src-fltr_snk-snk.csv" "90"
#    start_application 0 "2,2,2" "3,35,19,51,11,27"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "5" "StreamBenchmarks/WindFlow/FraudDetection/profiling_files/--par=2_--b=0_N5_src-snk-src-snk_fltr-fltr.csv" "90"
#    start_application 0 "2,2,2" "3,35,11,27,19,51"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "1" "StreamBenchmarks/WindFlow/FraudDetection/profiling_files/--par=2_--b=32_N1_src-src_fltr-snk-fltr-snk.csv" "100"
#    start_application 32 "2,2,2" "2,18,10,26,28,30"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "1" "StreamBenchmarks/WindFlow/FraudDetection/profiling_files/--par=2_--b=32_N1_src-snk-src-snk_fltr-fltr.csv" "100"
#    start_application 32 "2,2,2" "2,34,10,26,18,50"
#    wait $profiler_pid
#    echo "Profiler terminato."

#     wait_for_no_users
#     start_profiler "4,5" "StreamBenchmarks/WindFlow/FraudDetection/profiling_files/--par=4_--b=0_N4_src-src-src-src_N5_fltr-fltr-fltr-fltr_snk-snk-snk-snk.csv" "100"
#     start_application 0 "4,4,4" "1,17,33,49,3,19,35,51,11,27,43,59"
#     wait $profiler_pid
#     echo "Profiler terminato."

#     wait_for_no_users
#     start_profiler "4,5" "StreamBenchmarks/WindFlow/FraudDetection/profiling_files/--par=4_--b=0_N4_snk-snk-snk-snk_N5_src-src-src-src_fltr-fltr-fltr-fltr.csv" "100"
#     start_application 0 "4,4,4" "3,19,35,51,11,27,43,59,1,17,33,49"
#     wait $profiler_pid
#     echo "Profiler terminato."

#     wait_for_no_users
#     start_profiler "4,5" "StreamBenchmarks/WindFlow/FraudDetection/profiling_files/--par=4_--b=32_N4_snk-snk-snk-snk_N5_src-fltr-src-fltr_src-fltr-src-fltr.csv" "100"
#     start_application 32 "4,4,4" "1,17,33,49,3,19,35,51,11,27,43,59"
#     wait $profiler_pid
#     echo "Profiler terminato."

#     wait_for_no_users
#     start_profiler "4,5" "StreamBenchmarks/WindFlow/FraudDetection/profiling_files/--par=4_--b=32_N4_src-src-src-src_N5_fltr-fltr-fltr-fltr_snk-snk-snk-snk.csv" "100"
#     start_application 32 "4,4,4" "3,35,11,43,19,51,27,59,1,17,33,49"
#     wait $profiler_pid
#     echo "Profiler terminato."

#     wait_for_no_users
#    start_profiler "4,5,6" "StreamBenchmarks/WindFlow/FraudDetection/profiling_files/--par=8_--b=0_N4_semi-pipeline_N5_semi-pipeline_N6_snk-snk-snk-snk.csv" "100"
#     start_application 0 "8,8,8" "1,49,41,19,11,59,37,29,17,9,57,35,27,5,53,45,33,25,3,51,43,21,13,61"
#     wait $profiler_pid
#     echo "Profiler terminato."

#     wait_for_no_users
#     start_profiler "4,5,6" "StreamBenchmarks/WindFlow/FraudDetection/profiling_files/--par=8_--b=0_N4_src-src_N5_fltr-fltr_N6_snk-snk.csv" "100"
#     start_application 0 "8,8,8" "1,17,33,49,9,25,41,57,3,19,35,51,11,27,43,59,5,21,37,53,13,29,45,61"
#     wait $profiler_pid
#     echo "Profiler terminato."



#     wait_for_no_users
#     start_profiler "4,5,6" "StreamBenchmarks/WindFlow/FraudDetection/profiling_files/--par=8_--b=32_N4_src-fltr-src-fltr_N5_src-fltr-src-fltr_N6_snk-snk-snk-snk.csv" "160"
#     start_application 32 "8,8,8" "1,33,9,41,3,35,11,43,17,49,25,57,19,51,27,59,5,21,37,53,13,29,45,61"
#     wait $profiler_pid
#     echo "Profiler terminato."

#     wait_for_no_users
#     start_profiler "4,5,6,7" "StreamBenchmarks/WindFlow/FraudDetection/profiling_files/--par=8_--b=32_N4_src-fltr-snk_src-fltr-snk_N5_src-fltr-snk_src-fltr-snk_N6_src-fltr-snk_src-fltr-snk_N7__src-fltr-snk_src-fltr-snk_.csv" "160"
#     start_application 32 "8,8,8" "1,9,3,11,5,13,7,15,17,25,19,27,21,29,23,31,33,57,35,43,37,43,39,47"
#     wait $profiler_pid
#     echo "Profiler terminato."

#     wait_for_no_users
#     start_profiler "1" "StreamBenchmarks/WindFlow/FraudDetection/profiling_files/ff=16_--par=2_--b=0_N1_src-snk-src_snk_fltr-fltr.csv" "100"
#     start_application 0 "2,2,2" "2,34,10,26,18,50"
#     wait $profiler_pid
#     echo "Profiler terminato."

#     start_profiler "1" "StreamBenchmarks/WindFlow/FraudDetection/profiling_files/ff=16_--par=2_--b=0_N1_src-fltr-snk_src-fltr-snk.csv" "100"
#     start_application 0 "2,2,2" "2,10,18,26,34,42"
#     wait $profiler_pid
#     echo "Profiler terminato."

#     wait_for_no_users
#     start_profiler "4,5" "StreamBenchmarks/WindFlow/FraudDetection/profiling_files/ff=16--par=4_--b=32_N4_snk-snk-snk-snk_N5_src-src-src-src_fltr-fltr-fltr-fltr.csv" "100"
#     start_application 32 "4,4,4" "3,19,35,51,11,27,43,59,1,17,33,49"
#     wait $profiler_pid
#     echo "Profiler terminato."

#     wait_for_no_users
#     start_profiler "4,5" "StreamBenchmarks/WindFlow/FraudDetection/profiling_files/ff=16--par=4_--b=32_N4_src-src-src-src_N5_fltr-fltr-fltr-fltr_snk-snk-snk-snk.csv" "100"
#     start_application 32 "4,4,4" "1,17,33,49,3,19,35,51,11,27,43,59"
#     wait $profiler_pid
#     echo "Profiler terminato."

#     wait_for_no_users
#     start_profiler "4,5,6" "StreamBenchmarks/WindFlow/FraudDetection/profiling_files/ff=16--par=8_--b=0_N4_src-fltr-src-fltr_N5_src-fltr-src-fltr_N6_snk-snk-snk-snk.csv" "100"
#     start_application 0 "8,8,8" "1,33,9,41,3,35,11,43,17,49,25,57,19,51,27,59,5,21,37,53,13,29,45,61"
#     wait $profiler_pid
#     echo "Profiler terminato."

     wait_for_no_users
     start_profiler "4,5,6" "StreamBenchmarks/WindFlow/FraudDetection/profiling_files/ff=16--par=8_--b=0_N4_pipeline_N5_pipeline_N6_pipeline_.csv" "100"
     start_application 0 "8,8,8" "1,49,41,19,11,59,37,29,17,9,57,35,27,5,53,45,33,25,3,51,43,21,13,61"
     wait $profiler_pid
     echo "Profiler terminato."


}

run_workloads