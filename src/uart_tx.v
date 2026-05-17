module uart_tx (
    input wire clk,
    input wire trigger,
    input wire [7:0] tx_byte,

    output wire o_tx,
    output wire o_tx_done
    );

    parameter clk_freq = 50000000; // input clock in Hz
    parameter baudrate = 1000000;
    parameter [15:0] timebase = clk_freq / baudrate;

    reg [15:0] ctr; // timebase counter
    reg [3:0] bit_ctr;  // current RX bit counter

    reg tx_done;
    reg tx;

    always @ (posedge clk)
    begin
        if (trigger == 1'b1) begin
            if (ctr == timebase) begin
                if (bit_ctr == 4'd10) begin
                    /* done - prepare for next byte */
                    tx_done <= 1'b1;
                    ctr <= timebase - 1; // allow one cycle to sync
                    bit_ctr <= 4'd0;
                end else begin
                    tx_done <= 1'b0;
                    ctr <= 16'd0;
                    if (bit_ctr == 4'd0) begin
                        /* start bit_ctr */
                        tx <= 1'b0;
                        bit_ctr <= 4'd1;
                    end else if (bit_ctr == 4'd9) begin
                        /* stop bit_ctr */
                        tx <= 1'b1;
                        bit_ctr <= 4'd10;
                    end else begin
                        /* data bit_ctr */
                        tx <= tx_byte[bit_ctr - 4'd1];
                        bit_ctr <= bit_ctr + 4'd1;
                    end
                end
            end else begin
                tx_done <= 1'b0;
                ctr <= ctr + 16'd1;
            end
        end else begin
            ctr <= timebase;
            bit_ctr <= 4'd0;
            tx_done <= 1'b0;
            tx <= 1'b1;
        end
    end

    assign o_tx = tx;
    assign o_tx_done = tx_done;
endmodule
