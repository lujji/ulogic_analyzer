`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  initial begin
    $dumpfile("tb.fst");
    $dumpvars(0, tb);
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  tt_lujji_ulogic_analyzer dut (
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif
      .ui_in(ui_in),
      .uo_out(uo_out),
      .uio_in(uio_in),
      .uio_out(uio_out),
      .uio_oe(uio_oe),
      .ena(ena),
      .clk(clk),
      .rst_n(rst_n)
  );

  initial clk = 0;
  always #10 clk = ~clk;

  initial begin
    ena = 1'b1;
    rst_n = 1'b0;
    ui_in = 8'h55;
    uio_in = 8'h00;

    #100;
    rst_n = 1'b1;

    #500000;

    ui_in = 8'hA3;

    #500000;

    ui_in = 8'hF0;

    #500000;

    $finish;
  end

endmodule
