/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_lujji_ulogic_analyzer (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

// All output pins must be assigned. If not used, assign to 0.
assign uo_out[7:2] = 0;
assign uio_out = 0;
assign uio_oe  = 0;

assign uo_out[1] = clk; // clk out

// List all unused inputs to prevent warnings
wire _unused = &{ena, uio_in, 1'b0};
wire reset = ~rst_n;

// UART TX module
wire tx_done;
reg [7:0] txd;

always @(posedge clk)
if (reset) begin
  txd <= 8'b0;
end else begin
  if (tx_done == 1'b1) begin
     txd <= ui_in;
  end
end

uart_tx #(.clk_freq (50000000)) UART_TX_inst(clk, reset, txd, uo_out[0], tx_done);

endmodule
