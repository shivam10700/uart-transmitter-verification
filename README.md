# UART Transmitter Design & Verification (SystemVerilog)

##  Overview
This project implements a **UART (Universal Asynchronous Receiver Transmitter) Transmitter** using SystemVerilog and verifies its functionality through simulation and waveform analysis.

The design follows a **Finite State Machine (FSM)** approach and supports standard UART communication format.

---

##  Features
- 8-bit data transmission (LSB first)
- Start and Stop bit implementation
- Parameterized baud rate
- FSM-based architecture
- Clean and modular RTL design

---

##  UART Frame Format

| Field       | Bits | Description              |
|------------|------|--------------------------|
| Idle       | 1    | Line remains HIGH        |
| Start Bit  | 1    | Logic LOW (0)            |
| Data Bits  | 8    | LSB first transmission   |
| Stop Bit   | 1    | Logic HIGH (1)           |

---

## Design Architecture

The transmitter is implemented using a 4-state FSM:

```text
IDLE → START → DATA → STOP → IDLE
