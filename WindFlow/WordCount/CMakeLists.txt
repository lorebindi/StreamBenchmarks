cmake_minimum_required(VERSION 3.10)
project(WordCount)

# Imposta lo standard C++
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


# Aggiungi la directory di inclusione per WindFlow
include_directories(${CMAKE_SOURCE_DIR}/../../../WindFlow/wf)

# Aggiungi l'eseguibile
add_executable(SpikeDetection src/wc.cpp)