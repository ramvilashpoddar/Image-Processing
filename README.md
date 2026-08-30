# UART
An implementation of UART using verilog


This UART consists of four parts:

Reciever.v - The part which recieves the Serial Signal

Transmitter.v - The part which transmits the Serial Signal

Baud_Rate_generator.v - The part that generates the specified Baud Rate of the communication

FIFO.v - A custom FIFO that can be used to Store all the data elements before transmitting or after recieving

UART.v - a small demostration connecting the RX and TX together

test_bench.v - The test bench that I designed to test my UART module


