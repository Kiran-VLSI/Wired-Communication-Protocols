`timescale 1ns / 1ps

module i2c_slave (
    input wire clk,
    input wire reset,
    input wire i2c_sda,  
    input wire i2c_scl,  
    output reg [7:0] data_out,  
    output reg ack  
);

    localparam STATE_IDLE  = 0;
    localparam STATE_ADDR  = 1;
    localparam STATE_RW    = 2;
    localparam STATE_ACK   = 3;
    localparam STATE_DATA  = 4;
    localparam STATE_STOP  = 5;

    reg [7:0] state;
    reg [6:0] slave_addr = 7'h50;  // Slave address (same as master for communication)
    reg [7:0] shift_reg;
    reg [2:0] bit_count;
    reg rw;  // Read/Write flag

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= STATE_IDLE;
            data_out <= 8'd0;
            ack <= 0;
            shift_reg <= 8'd0;
            bit_count <= 3'd0;
        end else begin
            case (state)
                STATE_IDLE: begin
                    if (i2c_sda == 0) // Start condition 
                        state <= STATE_ADDR;
                    bit_count <= 6;
                end
                
                STATE_ADDR: begin
                    shift_reg[bit_count] <= i2c_sda;  // Receive address bit by bit
                    if (bit_count == 0) 
                        state <= STATE_RW;
                    else 
                        bit_count <= bit_count - 1;
                end
                
                STATE_RW: begin
                    rw <= i2c_sda;  // Last bit is Read/Write
                    if (shift_reg[6:0] == slave_addr)  
                        state <= STATE_ACK;
                    else 
                        state <= STATE_IDLE;
                end
                
                STATE_ACK: begin
                    ack <= 1;  // Acknowledge address 
                    state <= STATE_DATA;
                    bit_count <= 7;
                end
                
                STATE_DATA: begin
                    shift_reg[bit_count] <= i2c_sda;  // Receive data bit by bit
                    if (bit_count == 0) begin
                        data_out <= shift_reg;
                        state <= STATE_STOP;
                    end else 
                        bit_count <= bit_count - 1;
                end
                
                STATE_STOP: begin
                    if (i2c_sda == 1) // Stop condition 
                        state <= STATE_IDLE;
                end

                default: state <= STATE_IDLE;
            endcase
        end
    end
endmodule
