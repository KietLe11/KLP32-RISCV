# KLP32V1 RISC-V RV32I Processor
By Kiet Le & Lawrence Prophete

## About
This project implements a simple RISC-V processor for FPGAs. It supports the RV32I base instruction set and is designed for educational and experimental purposes.
This projects was developed for Intel Quartus and Simulated on the DE10-Lite Board. Although verilog/system verilog files should not have any restrictions to be used on another platform.

## Getting Started

### Prerequisites
- Quartus Prime Lite Edition 20.1 or later
- ModelSim or another simulator

### File Structure
      .
      ├── .github                 # Github Actions
      │   └── workflows
      │   │   └── pr.yml          # Pull Request Quartus Compiling Checker
      ├── quartus
      |   ├── KLP32V1.qpf         # Quartus Project File
      |   └── KLP32V1.qsf         # Quartus Settings File
      ├── rtl                     # SystemVerilog/Verilog Files
      │   ├── alu-modules         # ALU Verilog Modules
      │   ├── general-modules     # Major Verilog modules (i.e., ALU, Register File, etc.)
      │   ├── misc-modules        # Miscellaneous Verilog modules (i.e., Muxes)
      |   ├── KLP32V1.sv          # KLP32V1 processor file
      |   ├── KLP32V1_tb.sv       # KLP32V1 processor testbench file
      |   └── main.sv             # Top level module
      ├── .gitignore
      ├── LICENSE
      └── README.md

## Microarchitecture
![alt text](rv32i_microarchitecture.png)
Image credit: EECS4201: Computer Architecture, Sebastian Magierowski, York University.

### Supported RV32I Instructions
| Tables        | Are           | Cool  |
| ------------- |:-------------:| -----:|
| col 3 is      | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |

## Important Notes
OS Instuctions like ECALL and EBREAK and instructions from the zicsr extensions have not been implemented in this version of the processor core.
