`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2026 13:17:53
// Design Name: 
// Module Name: Vending_tb
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


module Vending_machine_top_tb;
    reg clk;
    reg rst;
    reg buy;
    reg coin;
    reg pq;
    reg go;
    reg [1:0] s1s2;

    wire [6:0] balance_display;
    wire [6:0] return_display;
    wire [1:0] selected_product_led;
    wire [3:0] selected_quantity_led;
    wire done;
    wire error;
    wire purchase_mode_active;
    wire idle_mode_status;

    Vending_machine_top uut (
        .clk(clk),
        .rst(rst),
        .buy(buy),
        .coin(coin),
        .pq(pq),
        .go(go),
        .s1s2(s1s2),
        .balance_display(balance_display),
        .return_display(return_display),
        .selected_product_led(selected_product_led),
        .selected_quantity_led(selected_quantity_led),
        .done(done),
        .error(error),
        .purchase_mode_active(purchase_mode_active),
        .idle_mode_status(idle_mode_status)
    );

    always #5 clk = ~clk;

    task insert_coin;
    begin
        @(posedge clk);
        coin = 1;
        @(posedge clk);
        coin = 0;
    end
    endtask

    task increase_qty;
    begin
        @(posedge clk);
        pq = 1;
        @(posedge clk);
        pq = 0;
    end
    endtask

    task start_purchase;
    begin
        @(posedge clk);
        buy = 1;
        @(posedge clk);
        buy = 0;
    end
    endtask

    task confirm_purchase;
    begin
        @(posedge clk);
        go = 1;
        @(posedge clk);
        go = 0;
    end
    endtask

    initial begin
        $monitor("TIME=%0t | rst=%b buy=%b coin=%b pq=%b go=%b s1s2=%b | balance=%d quantity=%d return=%d | done=%b error=%b | state_idle=%b purchase_mode=%b",
                 $time, rst, buy, coin, pq, go, s1s2,
                 balance_display, selected_quantity_led,
                 return_display, done, error,
                 idle_mode_status, purchase_mode_active);
    end

    initial begin
        $dumpfile("Vending.vcd");
        $dumpvars(0,Vending_machine_top_tb);
    end

    initial begin
        clk = 0;
        rst = 1;
        buy = 0;
        coin = 0;
        pq = 0;
        go = 0;
        s1s2 = 2'b00;

        #20;
        rst = 0;

        // CASE 1: Successful purchase of Product 1
        // Product 1 price = 5
        $display("\nCASE 1: Successful purchase of Product 1");

        start_purchase;
        s1s2 = 2'b01;

        insert_coin;      // Balance = 5
        increase_qty;     // Quantity = 1

        confirm_purchase;

        #30;

        // CASE 2: Successful purchase of Product 2
        // Product 2 price = 10
        $display("\nCASE 2: Successful purchase of Product 2");

        rst = 1;
        #10;
        rst = 0;

        start_purchase;
        s1s2 = 2'b10;

        insert_coin;      // +5
        insert_coin;      // +5 => Balance = 10
        increase_qty;     // Quantity = 1

        confirm_purchase;

        #30;

        // CASE 3: Error due to insufficient balance
        // Product 2 costs 10 but only 5 inserted
        $display("\nCASE 3: Insufficient balance");

        rst = 1;
        #10;
        rst = 0;

        start_purchase;
        s1s2 = 2'b10;

        insert_coin;      // Balance = 5 only
        increase_qty;     // Quantity = 1

        confirm_purchase;

        #30;
        
        // CASE 4: Multiple quantity purchase
        // Product 1 price = 5, Qty = 3, Total = 15
        // =====================================================
        $display("\nCASE 4: Multiple quantity purchase");

        rst = 1;
        #10;
        rst = 0;

        start_purchase;
        s1s2 = 2'b01;

        insert_coin;
        insert_coin;
        insert_coin;      // Balance = 15

        increase_qty;
        increase_qty;
        increase_qty;     // Quantity = 3

        confirm_purchase;

        #40;

        // CASE 5: Error due to zero quantity
        $display("\nCASE 5: Zero quantity selected");

        rst = 1;
        #10;
        rst = 0;

        start_purchase;
        s1s2 = 2'b01;

        insert_coin;

        // No quantity selected
        confirm_purchase;

        #30;

        // CASE 6: Stock depletion for Product 1
        // Repeatedly buy Product 1 until stock becomes low
        $display("\nCASE 6: Stock depletion check");

        repeat(3) begin
            rst = 1;
            #10;
            rst = 0;

            start_purchase;
            s1s2 = 2'b01;

            insert_coin;
            insert_coin;
            insert_coin;
            insert_coin;
            insert_coin;   // Balance = 25

            increase_qty;
            increase_qty;
            increase_qty;
            increase_qty;
            increase_qty;  // Quantity = 5

            confirm_purchase;

            #40;
        end

        // CASE 7: No product selected
        $display("\nCASE 7: No product selected");

        rst = 1;
        #10;
        rst = 0;

        start_purchase;
        s1s2 = 2'b00;

        insert_coin;
        increase_qty;

        confirm_purchase;

        #30;

        // CASE 8: Extra balance and return display check
        // Product 1 price = 5, balance inserted = 15
        // Return should be 10
        $display("\nCASE 8: Return amount check");

        rst = 1;
        #10;
        rst = 0;

        start_purchase;
        s1s2 = 2'b01;

        insert_coin;
        insert_coin;
        insert_coin;      // Balance = 15

        increase_qty;     // Quantity = 1

        confirm_purchase;

        #50;

        $finish;
    end

endmodule