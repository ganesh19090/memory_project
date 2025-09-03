# 📝 Memory Project (Verilog)

This project implements an **8-bit wide, 32-depth memory module** in Verilog with a **valid/ready handshake protocol**.  
It supports both **read and write operations**, verified using a **testbench** and **ModelSim simulation**.

## 📂 Files in this Repository
- `memory_project.v` → RTL design of memory  
- `tb.v` → Testbench for verification  
- `run.do` → ModelSim script for automated simulation  
- `output.hex` → Sample memory contents  
- `vsim.wlf` → Simulation waveform file  

## ▶️ How to Run
1. Open ModelSim / QuestaSim.  
2. Compile:
   ```bash
   vlog memory_project.v tb.v
   vsim tb +test_name=1WR_1RD
   run  -all
3. similarly do it for all test cases during compilation
4. simulate the output waveform using modelsim/questasim
