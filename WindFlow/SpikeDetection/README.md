# Compile and run SpikeDetection

## Compile
make all

## Run
Example: ./bin/sd --rate 0 --keys 0 --sampling 1000 --batch 0 --parallelism 1,1,1,1 --cpu-pinning 0,16,32,48 [--chaining]

In the example above, we start the program with parallelism 1 for each operator (Source, Moving-Average, Spike-Detector, and Sink separated by commas in the --parallelism attribute). Latency values are gathered every 100 received tuples by the Sink (--sampling parameter), while the generation is performed at full speed (value 0 of the --rate parameter). The --batch parameter can be used to apply an output batching from each operator: 0 means no batching, values greater than 0 switch WindFlow in batch mode. The attribute --keys indicates the number of keys to use: zero means to use the default number of keys in the dataset, otherwise a specific number of keys (uniformely distributed) can be used. 
The attribute --cpu-pinning indicates on which core pinning the replicas of the operator. The order to respect it's: [cores' source replicas, cores' map replicas, cores' filter replicas, cores' sink replicas].
Example: "--parallelism 2,2,2,2 --cpu-pinning 0,16,32,48,8,24,40,56"; first source replica it's pinned on core 0 and the second on core 16, the first map replica it's pinned on core 32 and the second on core 45, ...
