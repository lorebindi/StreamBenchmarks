# Author: Gabriele Mencagli
# Date: 13/01/2020

FF_ROOT			= $(HOME)/fastflow
WF_INCLUDES		= $(HOME)/WindFlow/wf
INCLUDE_DIR		= ../includes
GDAL_INCLUDE    = $(HOME)/local/include
GDAL_LIBDIR     = $(HOME)/gdal/lib
OUT_DIR			= ~/StreamBenchmarks/WindFlow/TrafficMonitoring/bin

CXX 			= g++
CXXFLAGS		= -std=c++17
INCLUDES		= -I $(FF_ROOT) -I $(WF_INCLUDES) -I $(INCLUDE_DIR) -I $(GDAL_INCLUDE)
MACRO           = -DFF_BOUNDED_BUFFER -DNDEBUG #-DNO_DEFAULT_MAPPING -DMANUAL_PINNING
OPTFLAGS		= -g -O3 -finline-functions
LDFLAGS         = -pthread -L$(GDAL_LIBDIR) -lgdal


all: tm

metric.o: ../includes/util/metric.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) $(MACRO) $(OPTFLAGS) $< -c

metric_group.o: ../includes/util/metric_group.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) $(MACRO) $(OPTFLAGS) $< -c

sampler.o: ../includes/util/sampler.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) $(MACRO) $(OPTFLAGS) $< -c

tm.o: tm.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) $(MACRO) $(OPTFLAGS) $< -c

tm: metric.o metric_group.o sampler.o tm.o
	$(CXX) metric.o metric_group.o sampler.o tm.o -o $(OUT_DIR)/tm $(LDFLAGS)

clean:
	rm -f $(OUT_DIR)/tm
	rm -f *.o

.DEFAULT_GOAL := all
.PHONY: all clean
