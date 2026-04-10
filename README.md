# FPGA Vending Machine using Verilog in Vivado

## Overview

This project implements a vending machine on FPGA using Verilog HDL. The design follows a modular approach with separate controller and datapath units. The vending machine accepts coins, tracks balance, dispenses products, returns change, and displays information on seven-segment displays.

## Features

* Coin insertion logic
* Product selection
* Balance calculation
* Change return logic
* Stock management
* Error handling for insufficient balance and out-of-stock condition
* Seven-segment display output
* Separate controller and datapath modules
* Complete simulation testbench

## Modules

* `Vending_machine_top.v` : Top-level integration module
* `Vending_controller.v` : FSM-based controller
* `Vending_datapath.v` : Handles balance, stock, and return amount
* `seven_seg_decoder.v` : Converts binary values to seven-segment display outputs
* `vending_machine_tb.v` : Testbench for simulation

## Inputs

* Clock
* Reset
* Coin input
* Product select
* Buy signal

## Outputs

* Product dispensed
* Balance display
* Return amount
* Error indication
* Seven-segment outputs

## Simulation Scenarios

* Successful purchase
* Insufficient balance
* Out of stock
* Multiple coin insertion
* Change return
* Reset operation

## Tools Used

* Verilog HDL
* Vivado
* FPGA Board (Spartan 7)
