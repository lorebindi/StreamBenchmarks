
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

      ./bin/wc --rate 0 --sampling 1000 --batch $batch --parallelism $parallelism --cpu-pinning $cpu_pinning &

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
#    start_profiler "1" "StreamBenchmarks/WindFlow/WordCount/profiling_files/--p=2_--b=0_N1_src-src-snk-snk_fltm-fltm-r-r.csv" "100"
#    start_application 0 "2,2,2,2" "2,18,10,26,42,58,34,50"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "1" "StreamBenchmarks/WindFlow/WordCount/profiling_files/--p=2_--b=0_N1_src-src-rdc-rdc_fltm-fltm-snk-snk.csv" "100"
#    start_application 0 "2,2,2,2" "2,18,10,26,34,50,42,58"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "1" "StreamBenchmarks/WindFlow/WordCount/profiling_files/ff=16--p=2_--b=0_N1_src-src-fltm-fltm_rdc-rdc-snk-snk.csv" "100"
#    start_application 0 "2,2,2,2" "2,18,34,50,10,26,42,58"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "1" "StreamBenchmarks/WindFlow/WordCount/profiling_files/ff=16--p=2_--b=0_N1_src-src-rdc-rdc_fltm-fltm-snk-snk.csv" "100"
#    start_application 0 "2,2,2,2" "2,18,10,26,34,50,42,58"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "5" "StreamBenchmarks/WindFlow/WordCount/profiling_files/--p=2_--b=32_N5_src-src-snk-snk_fltm-fltm-r-r.csv" "100"
#    start_application 32 "2,2,2,2" "3,35,11,43,27,59,19,51"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "5" "StreamBenchmarks/WindFlow/WordCount/profiling_files/--p=2_--b=32_N5_pipeline.csv" "100"
#    start_application 32 "2,2,2,2" "3,11,19,27,35,43,51,59"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "1" "StreamBenchmarks/WindFlow/WordCount/profiling_files/ff=16--p=2_--b=32_N1_src-fltm-src-fltm_rdc-snk-rdc-snk.csv" "100"
#    start_application 32 "2,2,2,2" "2,34,18,50,10,42,26,58"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "1" "StreamBenchmarks/WindFlow/WordCount/profiling_files/ff=16--p=2_--b=32_N1_src-rdc-src-rdc_fltm-snk-fltm-snk.csv" "100"
#    start_application 32 "2,2,2,2" "2,34,10,42,18,50,26,58"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "4,5" "StreamBenchmarks/WindFlow/WordCount/profiling_files/p=4_--b=0_N4_rdc-snk-rdc-snk_N5_src-fltm-src-fltm.csv" "100"
#    start_application 0 "4,4,4,4" "3,35,11,43,19,51,27,59,1,33,9,41,17,49,25,57"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "4,5" "StreamBenchmarks/WindFlow/WordCount/profiling_files/--p=4_--b=0_N4_semipipeline_snk-snk-snk-snk_N5_semipipeline.csv" "100"
#    start_application 0 "4,4,4,4" "3,51,43,17,19,11,59,33,35,27,1,49,9,25,41,57"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "4,5" "StreamBenchmarks/WindFlow/WordCount/profiling_files/ff=16--p=4_--b=0_N4_pipeline_N5_pipeline.csv" "100"
#    start_application 0 "4,4,4,4" "1,9,3,11,17,25,19,27,33,41,35,43,49,57,51,59"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "4,5" "StreamBenchmarks/WindFlow/WordCount/profiling_files/ff=16--p=4_--b=0_N4_src-fltm_N5_rdc-snk.csv" "100"
#    start_application 0 "4,4,4,4" "3,35,11,43,19,51,27,59,1,33,9,41,17,49,25,57"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "4,5,6,7" "StreamBenchmarks/WindFlow/WordCount/profiling_files/--p=8_--b=0_N4_pipeline_N5_pipeline_N6_pipeline_N7_pipeline.csv" "100"
#    start_application 0 "8,8,8,8" "1,9,3,11,5,13,7,15,17,25,19,27,21,29,23,31,33,41,35,43,37,45,39,47,49,57,51,59,53,61,55,63"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "4,5,6,7" "StreamBenchmarks/WindFlow/WordCount/profiling_files/--p=8_--b=0_N4_semipipeline_N5_semipipeline_N6_semipipeline_N7_snk.csv" "100"
#    start_application 0 "8,8,8,8" "1,49,41,19,11,59,37,29,17,9,57,35,27,5,53,45,33,25,3,51,43,21,13,61,7,23,39,55,15,31,47,63"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "4,5,6,7" "StreamBenchmarks/WindFlow/WordCount/profiling_files/--p=8_--b=32_N4_pipeline_N5_pipeline_N6_pipeline_N7_pipeline.csv" "100"
#    start_application 32 "8,8,8,8" "1,9,3,11,5,13,7,15,17,25,19,27,21,29,23,31,33,41,35,43,37,45,39,47,49,57,51,59,53,61,55,63"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "4,5,6,7" "StreamBenchmarks/WindFlow/WordCount/profiling_files/--p=8_--b=32_N4_src-rdc_N5_fltm-snk_N6_src-rdc_N7_fltm-snk.csv" "100"
#    start_application 32 "8,8,8,8" "1,33,9,41,5,37,13,45,3,35,11,43,7,39,15,47,17,49,25,57,21,53,29,61,19,51,27,59,23,55,31,63"
#    wait $profiler_pid
#    echo "Profiler terminato."

#    wait_for_no_users
#    start_profiler "4,5,6,7" "StreamBenchmarks/WindFlow/WordCount/profiling_files/--p=8_--b=32_N4_src-fltm_N5_src-fltm_N6_rdc-snk_N7_rdc-snk.csv" "100"
#    start_application 32 "8,8,8,8" "1,33,9,41,3,35,11,43,17,49,25,57,19,51,27,59,5,37,13,45,7,39,15,47,21,53,29,61,23,55,31,63"
#    wait $profiler_pid
#    echo "Profiler terminato."

    wait_for_no_users
    start_profiler "4,5,6,7" "StreamBenchmarks/WindFlow/WordCount/profiling_files/--p=8_--b=32_N4_src-snk_N5_src-snk_N6_fltm-rdc_N7_fltm-rdc.csv" "100"
    start_application 32 "8,8,8,8" "1,33,9,41,5,37,13,45,3,35,11,43,7,39,15,47,19,51,27,59,23,55,31,63,17,49,25,57,21,53,29,61"
    wait $profiler_pid
    echo "Profiler terminato."

}

run_workloads