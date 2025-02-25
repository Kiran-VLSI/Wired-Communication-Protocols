# I2C Verilog Implementation

This repository contains a Verilog implementation of an I2C communication protocol, including a testbench for simulation.

## Overview
The I2C module in this repository implements a basic master transmitter that sends data over the I2C bus. The design includes states for:
- IDLE
- START condition
- ADDRESS transmission
- READ/WRITE bit
- ACKNOWLEDGEMENT
- DATA transmission
- STOP condition

## File Structure
- `i2c.v` - Verilog code for I2C protocol implementation
- `i2c_tb.v` - Testbench to verify functionality
- `README.md` - Documentation for the project

## Simulation
To simulate the module, use any Verilog simulator such as ModelSim, Xilinx Vivado, or Cadence.

### Steps to Run Simulation:
1. Compile `i2c.v` and `i2c_tb.v` using your preferred simulator.
2. Run the testbench.
3. Observe the waveform for `i2c_sda`, `i2c_scl`, and state transitions.

## Contact
For any queries, reach out via GitHub issues.

