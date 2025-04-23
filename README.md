# KLP32V2 RISC-V RV32I Processor
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
      ├── .github/                # Github Actions
      │   └── workflows
      │   │   └── pr.yml          # Pull Request Quartus Compiling Checker
      ├── quartus/
      |   ├── KLP32V1.qpf         # Quartus Project File
      |   └── KLP32V1.qsf         # Quartus Settings File
      ├── resources/              # Images for README.md
      ├── rtl                     # SystemVerilog/Verilog Files
      │   ├── alu-modules/        # ALU Verilog Modules
      │   ├── general-modules/    # Major Verilog modules (i.e., ALU, Register File, etc.)
      │   ├── misc-modules/       # Miscellaneous Verilog modules (i.e., Muxes)
      |   ├── KLP32V1.sv          # KLP32V1 processor file
      |   ├── KLP32V1_tb.sv       # KLP32V1 processor testbench file
      |   └── main.sv             # Top level module
      ├── .gitignore
      ├── LICENSE
      └── README.md

## Microarchitecture
![alt text](resources/rv32i_microarchitecture.png)
Image credit: EECS4201: Computer Architecture, Sebastian Magierowski, York University.

## Validation
- Validation of instructions has been done in rtl/KLP32V1_tb.sv with test cases for each supported instruction.
- The test instructions are located in: rtl/general-modules/test_instructions.hex
- To test instructions, add instruction to rtl/general-modules/test_instructions.hex and add test case to rtl/KLP32V1_tb.sv

## Supported RV32I Instructions
| Data Processing | Branching | Load/Store | Jumping | U-Immediate |
| --------------- | --------- | -----------| ------- | ----------- |
| ADDI            | BEQ       | LB         | JAL     | LUI         |
| SLTI            | BNE       | LW         | JALR    | AUIPC       |
| SLTIU           | BLT       | LBU        |         |             |
| XORI            | BGE       | LHU        |         |             |
| ORI             | BLTU      | SB         |         |             |
| ANDI            | BGEU      | SW         |         |             |
| SLLI            |           |            |         |             |
| SRLI            |           |            |         |             |
| SRAI            |           |            |         |             |
| ADD             |           |            |         |             |
| SUB             |           |            |         |             |
| SLL             |           |            |         |             |
| SLT             |           |            |         |             |
| SLTU            |           |            |         |             |
| XOR             |           |            |         |             |
| SRL             |           |            |         |             |
| SRA             |           |            |         |             |
| OR              |           |            |         |             |
| AND             |           |            |         |             |

***

### Data Processing Instruction Formats
#### Register Type Instruction Format:
![R-Type Instruction Format](resources/R-Type-Instructions.png)

#### Immediate Type Instruction Formats:
![I-Type Instruction Format](resources/I-Type-Instruction.png)

#### Shift Immediate Instruction Format:
![Shift Immediate Instruction Format](resources/Shift-I-Type-Instructions.png)

***

### Branch Instruction Formats
#### B-Type Type Instruction Format:
![B-Type Type Instruction Format](resources/B-Type-Instructions.png)

***

### Load/Store Type Instruction Formats
![Load/Store Type Instruction Format](resources/LoadStoreInstructions.png)

***

### Jump and Link Instruction Formats
#### JAL Instruction Format:
![JAL Instruction Format](resources/JAL.png)
#### JALR Instruction Format:
![JALR Instruction Format](resources/JALR.png)

***

## Unsupported Base RV32I Instructions:
- ECALL
- EBREAK
