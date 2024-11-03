
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

#    wait_for_no_users
#    start_profiler "1" "StreamBenchmarks/WindFlow/SpikeDetection/profiling_files/--par=2_--b=0_N1_src-snk-src-snk_map-fltr-map-fltr.csv" "100"
#    start_application 0 "2,2,2,2" "2,18,10,26,42,58,34,50"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "1" "StreamBenchmarks/WindFlow/SpikeDetection/profiling_files/--par=2_--b=0_N1_src-fltr-src-fltr_map-snk-map-snk.csv" "100"
#    start_application 0 "2,2,2,2" "2,18,10,26,34,50,42,58"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "1" "StreamBenchmarks/WindFlow/SpikeDetection/profiling_files/--par=2_--b=32_N1_src-m-src-m_fltr-snk-fltr-snk.csv" "100"
#    start_application 32 "2,2,2,2" "2,18,34,50,10,26,42,58"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "1" "StreamBenchmarks/WindFlow/SpikeDetection/profiling_files/--par=2_--b=32_N1_pipeline.csv" "100"
#    start_application 32 "2,2,2,2" "2,10,18,26,34,42,50,58"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "5,4" "StreamBenchmarks/WindFlow/SpikeDetection/profiling_files/--par=4_--b=0_N4_fltr_snk_N5_src_m.csv" "100"
#    start_application 0 "4,4,4,4" "3,19,35,51,11,27,43,59,1,17,33,49,9,25,41,57"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "5,4" "StreamBenchmarks/WindFlow/SpikeDetection/profiling_files/--par=4_--b=0_N4_pipeline_N5_pipeline.csv" "100"
#    start_application 0 "4,4,4,4" "1,9,3,11,17,25,19,27,33,41,35,43,49,57,51,59"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "5,4" "StreamBenchmarks/WindFlow/SpikeDetection/profiling_files/--par=4_--b=32_N4_m-fltr_N5_src_snk.csv" "100"
#    start_application 32 "4,4,4,4" "3,11,35,43,1,9,33,41,17,25,49,57,19,27,51,59"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "5,4" "StreamBenchmarks/WindFlow/SpikeDetection/profiling_files/--par=4_--b=32_N4_m-snk_N5_src_fltr.csv" "100"
#    start_application 32 "4,4,4,4" "3,11,35,43,1,9,33,41,19,27,51,59,17,25,49,57"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "4,5,6,7" "StreamBenchmarks/WindFlow/SpikeDetection/profiling_files/--par=8_--b=0_N4_src_N5_m_N6_fltr_N7_snk.csv" "100"
#    start_application 0 "8,8,8,8" "1,17,33,49,9,25,41,57,3,19,35,51,11,27,43,59,5,21,37,53,13,29,45,61,7,23,39,55,15,31,47,63"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "4,5,6,7" "StreamBenchmarks/WindFlow/SpikeDetection/profiling_files/--par=8_--b=0_N4_pipeline_N5_pipeline_N6_pipeline_N7_pipeline.csv" "100"
#    start_application 0 "8,8,8,8" "1,9,3,11,5,13,7,15,17,25,19,27,21,29,23,31,33,41,35,43,37,45,39,47,49,57,51,59,53,61,55,63"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "4,5,6,7" "StreamBenchmarks/WindFlow/SpikeDetection/profiling_files/--par=8_--b=32_N4_src-snk_N5_src-snk_N6_m-fltr_N7_m-fltr.csv" "100"
#    start_application 32 "8,8,8,8" "1,33,9,41,3,35,11,43,5,37,13,45,7,39,15,47,21,53,29,61,23,55,31,63,17,49,25,57,19,51,27,59"
#    wait $profiler_pid
#    echo "Profiler terminato."

    wait_for_no_users
    start_profiler "4,5,6,7" "StreamBenchmarks/WindFlow/SpikeDetection/profiling_files/--par=8_--b=32_N4_src_N5_m_N6_fltr_N7_snk.csv" "100"
    start_application 32 "8,8,8,8" "1,17,33,49,9,25,41,57,3,19,35,51,11,27,43,59,5,21,37,53,13,29,45,61,7,21,39,55,15,31,47,61"
    wait $profiler_pid
    echo "Profiler terminato."

#-----------------------------------------------------------------------------------------------------------------------------------------------------
# [IMPORTANTE] ff queue length = 16

#    wait_for_no_users
#    start_profiler "1" "StreamBenchmarks/WindFlow/SpikeDetection/profiling_files/ff=16--par=2_--b=0_N1_src-m-src-m_snk-fltr-snk-fltr.csv" "100"
#    start_application 0 "2,2,2,2" "2,18,34,50,10,26,42,58"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "1" "StreamBenchmarks/WindFlow/SpikeDetection/profiling_files/ff=16--par=2_--b=0_N1_src-fltr-src-fltr_m-snk-m-snk.csv" "100"
#    start_application 0 "2,2,2,2" "2,18,10,26,34,50,42,58"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "4,5,6,7" "StreamBenchmarks/WindFlow/SpikeDetection/profiling_files/ff=16--par=8_--b=0_N4_src_N5_m_N6_fltr_N7_snk.csv" "100"
#    start_application 0 "8,8,8,8" "1,17,33,49,9,25,41,57,3,19,35,51,11,27,43,59,5,21,37,53,13,29,45,61,7,23,39,55,15,31,47,63"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "4,5,6,7" "StreamBenchmarks/WindFlow/SpikeDetection/profiling_files/ff=16--par=8_--b=0_N4_pipeline_N5_pipeline_N6_pipeline_N7_pipeline.csv" "100"
#    start_application 0 "8,8,8,8" "1,9,3,11,5,13,7,15,17,25,19,27,21,29,23,31,33,41,35,43,37,45,39,47,49,57,51,59,53,61,55,63"
#    wait $profiler_pid
#    echo "Profiler terminato."

}

run_workloads