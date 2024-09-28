cmake_minimum_required(VERSION 3.10)
project(FraudDetection)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(FF_ROOT "/home/bindi/fastflow")
set(WIND_FLOW_PATH "/home/bindi/WindFlow/wf")
set(INCLUDE_DIR "${CMAKE_SOURCE_DIR}/../includes")

include_directories(${FF_ROOT})
include_directories(${WIND_FLOW_PATH})
include_directories(${INCLUDE_DIR})

add_executable(FraudDetection src/fd.cpp ../includes/util/metric.cpp ../includes/util/metric_group.cpp ../includes/util/sampler.cpp)

target_link_libraries(FraudDetection PRIVATE pthread)

target_include_directories(FraudDetection PRIVATE ${CMAKE_SOURCE_DIR})