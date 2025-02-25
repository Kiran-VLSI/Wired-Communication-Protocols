`timescale 1ns / 1ps

module i2c_tb;
    reg clk;
    reg reset;
    wire i2c_sda;
    wire i2c_scl;

    i2c uut (
        .clk(clk),
        .reset(reset),
        .i2c_sda(i2c_sda),
        .i2c_scl(i2c_scl)
    );
    
    initial begin
        clk = 0;
        forever #1 clk = ~clk;  
    end

    initial begin
        $dumpfile("i2c_tb.vcd");   
        $dumpvars(0, i2c_tb);

        reset = 1;
        #10;
        reset = 0;
        
        #100;  
        
        $finish;
    end
endmodule
