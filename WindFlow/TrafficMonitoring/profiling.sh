
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

start_application_pinning_ff(){
      batch=$1
      parallelism=$2
      cpu_pinning=$3

      sleep 10

      ./bin/tm --rate 0 --sampling 1000 --batch $batch --parallelism $parallelism &

      # Salvare il PID dell'applicazione
      app_pid=$!
      echo "Applicazione avviata con PID $app_pid"

      # Aspetta che l'applicazione termini
      wait $app_pid
      echo "Applicazione terminata."
}

start_application(){
      batch=$1
      parallelism=$2
      cpu_pinning=$3

      sleep 10

      ./bin/tm --rate 0 --sampling 1000 --batch $batch --parallelism $parallelism --cpu-pinning $cpu_pinning &

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
#    start_profiler "5" "StreamBenchmarks/WindFlow/TrafficMonitoring/profiling_files/--par=2_--b=32_N5_src-fltm-src-fltm_m-snk-m-snk.csv" "210"
#    start_application 32 "2,2,2,2" "3,35,19,51,11,43,27,59"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "5" "StreamBenchmarks/WindFlow/TrafficMonitoring/profiling_files/--par=2_--b=32_N5_src-fltm-m-snk_src-fltm-m-snk.csv" "210"
#    start_application 32 "2,2,2,2" "3,11,19,27,35,43,51,59"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "4,5" "StreamBenchmarks/WindFlow/TrafficMonitoring/profiling_files/--par=4_--b=0_N4_src-src-src-src_snk-snk-snk-snk_N5_fltm-fltm-fltm-fltm_m_m_m_m.csv" "90"
#    start_application 0 "4,4,4,4" "1,17,33,49,3,19,35,51,11,27,43,59,9,25,41,57"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "4,5" "StreamBenchmarks/WindFlow/TrafficMonitoring/profiling_files/--par=4_--b=0_N4_pipeline_N5_pipeline.csv" "90"
#    start_application 0 "4,4,4,4" "1,9,3,11,17,25,19,27,33,41,35,43,49,57,51,59"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "4,5" "StreamBenchmarks/WindFlow/TrafficMonitoring/profiling_files/--par=4_--b=32_N4_semi-pipeline_semi-pipeline_N5_semi-pipeline_snk-snk-snk-snk.csv" "210"
#    start_application 32 "4,4,4,4" "3,51,43,17,19,11,59,31,35,27,1,49,9,25,41,57"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "4,5" "StreamBenchmarks/WindFlow/TrafficMonitoring/profiling_files/--par=4_--b=32_N4_src-m-src-m_src-m-src-m_N5_fltm-snk-fltm-snk_fltm-snk-fltm-snk.csv" "210"
#    start_application 32 "4,4,4,4" "3,35,11,43,1,33,9,41,19,27,51,59,17,49,25,57"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "4,5,6,7" "StreamBenchmarks/WindFlow/TrafficMonitoring/profiling_files/--par=8_--b=0_N4_semi-pipeline_N5_semi-pipeline_N6_semipipeline_N7_snk_snk_snk_snk.csv" "100"
#    start_application 0 "8,8,8,8" "1,49,41,19,11,59,37,29,17,9,57,35,27,5,53,45,33,25,3,51,43,21,13,61,7,23,39,55,15,31,47,63"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "4,5,6,7" "StreamBenchmarks/WindFlow/TrafficMonitoring/profiling_files/--par=8_--b=32_N4_pipeline_N5_pipeline_N6_pipeline_N7_pipeline.csv" "450"
#    start_application 32 "8,8,8,8" "1,9,3,11,5,13,7,15,17,25,19,27,21,29,23,31,33,41,35,43,37,45,39,47,49,57,51,59,53,61,55,63"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "0,1,2,3,4,5,6,7" "StreamBenchmarks/WindFlow/TrafficMonitoring/profiling_files/--par=16_--b=0_pinning_FF.csv" "100"
#    start_application_pinning_ff 0 "16,16,16,16"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "0,1,2,3,4,5,6,7" "StreamBenchmarks/WindFlow/TrafficMonitoring/profiling_files/--par=16_--b=0_N0-N3_src-fltm-src-fltm_N4-N7_map-snk-map-snk.csv" "100"
#    start_application 0 "16,16,16,16" "0,32,8,40,2,34,10,42,4,36,12,44,6,38,14,46,16,48,24,56,18,50,26,58,20,52,28,60,22,54,30,62,1,33,9,41,3,35,11,43,5,37,13,45,7,39,15,47,17,49,25,57,19,51,27,59,21,53,29,61,23,55,31,63"
#    wait $profiler_pid
#    echo "Profiler terminato."


#-------------------------------------------------------------------------------------------------------------------- prove finali

    wait_for_no_users
    start_profiler "4,5,6,7" "StreamBenchmarks/WindFlow/TrafficMonitoring/profiling_files/prove_finali--par=8_--b=0_N4_src_N5_fltm_N6_map_N7_snk.csv" "100"
    start_application 0 "8,8,8,8" "1,17,33,49,9,25,41,57,3,19,35,51,11,27,43,59,5,21,37,53,13,29,45,61,7,23,39,55,15,31,47,63"
    wait $profiler_pid
    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "4,5,6,7" "StreamBenchmarks/WindFlow/TrafficMonitoring/profiling_files/prove_finali--par=8_--b=0_N4_semipipeline_N5_semipipeline_N6_semipipeline_N7_snk.csv" "100"
#    start_application 0 "8,8,8,8" "1,49,41,19,11,59,37,29,17,9,57,35,27,5,53,45,33,25,3,51,43,21,13,61,7,23,39,55,15,31,47,63"
#    wait $profiler_pid
#    echo "Profiler terminato."


}

run_workloads