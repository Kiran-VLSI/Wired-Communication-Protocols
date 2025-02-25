`timescale 1ns / 1ps

module i2c(
    input wire clk,
    input wire reset,
    output reg i2c_sda,
    output reg i2c_scl
);

    localparam STATE_IDLE  = 0;
    localparam STATE_START = 1;
    localparam STATE_ADDR  = 2;
    localparam STATE_RW    = 3;
    localparam STATE_WACK  = 4;
    localparam STATE_DATA  = 5;
    localparam STATE_STOP  = 6;
    localparam STATE_WACK2 = 7;

    reg [7:0] state;
    reg [6:0] addr;
    reg [7:0] count;
    reg [7:0] data;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state    <= STATE_IDLE;
            i2c_sda  <= 1;
            i2c_scl  <= 1;
            addr     <= 7'h50;
            count    <= 8'd0;
            data     <= 8'haa;
        end else begin
            case (state)
                STATE_IDLE: begin
                    i2c_sda <= 1;
                    state   <= STATE_START;
                end
                
                STATE_START: begin
                    i2c_sda <= 0;  // Start condition
                    state   <= STATE_ADDR;
                    count   <= 6;
                end
                
                STATE_ADDR: begin
                    i2c_sda <= addr[count];
                    if (count == 0) 
                        state <= STATE_RW;
                    else 
                        count <= count - 1;
                end

                STATE_RW: begin
                    i2c_sda <= 1;  // Read/Write bit (Write in this case)
                    state   <= STATE_WACK;
                end

                STATE_WACK: begin
                    state  <= STATE_DATA;
                    count  <= 7;
                end

                STATE_DATA: begin
                    i2c_sda <= data[count];
                    if (count == 0) 
                        state <= STATE_WACK2;
                    else 
                        count <= count - 1;
                end

                STATE_WACK2: begin
                    state <= STATE_STOP;
                end

                STATE_STOP: begin
                    i2c_sda <= 1; // Stop condition
                    state   <= STATE_IDLE;
                end

                default: state <= STATE_IDLE;
            endcase
        end
    end
endmodule
