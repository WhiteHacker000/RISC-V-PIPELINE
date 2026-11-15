SHELL := /bin/sh
VERILATOR ?= verilator
YOSYS ?= yosys
GTKWAVE ?= gtkwave
ROOT := $(CURDIR)
PROJ := $(ROOT)/riscv-processor
RTL := $(wildcard $(PROJ)/rtl/components/*.sv) $(wildcard $(PROJ)/rtl/pipeline_registers/*.sv) $(PROJ)/rtl/riscv_top.sv
BUILD := $(PROJ)/build

.PHONY: help build run test lint wave synth clean
help:
	@printf '%s\n' 'build  Compile processor integration simulation' 'run    Run processor simulation' 'test   Compile and execute all testbenches' 'lint   Run Verilator lint on processor' 'wave   Open processor waveform' 'synth  Run Yosys synthesis checks' 'clean  Remove build outputs'

build:
	mkdir -p $(BUILD) $(PROJ)/simulation
	cd $(PROJ) && $(VERILATOR) --binary --timing --trace --top-module processor_tb -Wno-fatal --Mdir $(BUILD)/processor_tb $(RTL) testbench/processor_tb.sv
run: build
	cd $(PROJ) && $(BUILD)/processor_tb/Vprocessor_tb

test:
	@set -eu; mkdir -p $(BUILD) $(PROJ)/simulation; \
	for tb in alu_tb register_file_tb immediate_generator_tb instruction_memory_tb data_memory_tb main_decoder_tb control_unit_tb program_counter_tb if_id_tb id_ex_tb ex_mem_tb mem_wb_tb forwarding_unit_tb hazard_detection_unit_tb processor_tb; do \
	  echo "== $$tb =="; \
	  if ! (cd $(PROJ) && $(VERILATOR) --binary --timing --trace --top-module $$tb -Wno-fatal --Mdir $(BUILD)/$$tb $(RTL) testbench/$$tb.sv); then echo "FAIL $$tb (compile)"; exit 1; fi; \
	  if ! (cd $(PROJ) && $(BUILD)/$$tb/V$$tb); then echo "FAIL $$tb (simulation)"; exit 1; fi; \
	  echo "PASS $$tb"; \
	done

lint:
	cd $(PROJ) && $(VERILATOR) --lint-only --timing --top-module riscv_top -Wall -Wno-fatal $(RTL)
wave:
	cd $(PROJ) && test -s simulation/processor_tb.vcd
	cd $(PROJ) && $(GTKWAVE) simulation/processor_tb.vcd
synth:
	cd $(PROJ) && $(YOSYS) -p 'read_verilog -sv $(RTL); hierarchy -check -top riscv_top; proc; check'
clean:
	rm -rf $(BUILD) $(PROJ)/obj_dir
	rm -f $(PROJ)/simulation/*.vcd
