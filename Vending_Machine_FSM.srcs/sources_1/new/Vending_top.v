`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2026 19:15:57
// Design Name: 
// Module Name: Vending_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Vending_machine_top(
    input clk, rst,
    input buy, coin, pq, go,
    input [1:0] s1s2,

    output [3:0] D0_AN,
    output [6:0] balance_display,
    output [3:0] D1_AN,
    output [6:0] return_display,
    output [1:0] selected_product_led,
    output [3:0] selected_quantity_led,
    output done,
    output error,
    output purchase_mode_active,
    output idle_mode_status
);

wire clr, ld_balance, inc_qty, calc, update_stock;
wire enough_balance, stock_ok;
wire [3:0] quantity;
wire [7:0] balance, return_amt;

assign D0_AN = 4'b1110;
assign D1_AN = 4'b1110;

Vending_datapath dp(
    clk, rst,
    coin, pq, s1s2,
    clr, ld_balance, inc_qty, calc, update_stock,
    balance, return_amt, quantity,
    enough_balance, stock_ok
);

Vending_controller ctrl(
    clk, rst,
    buy, go,
    enough_balance, stock_ok,
    clr, ld_balance, inc_qty, calc, update_stock,
    done, error,
    purchase_mode_active,
    idle_mode_status
);

seven_seg_decoder s1(balance[3:0],balance_display);
seven_seg_decoder s2(return_amt[3:0],return_display);

assign selected_product_led = s1s2;
assign selected_quantity_led = quantity;

endmodule