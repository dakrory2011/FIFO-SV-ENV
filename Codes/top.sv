module top();

    bit clk;
   
    initial begin
        clk = 0;
        forever 
            #1 clk = ~clk;
    end
    fifo_interface fifo_if(clk);
    FIFO dut(fifo_if);
    fifo_tb tb(fifo_if);
    fifo_monitor mon(fifo_if);

  //FIFO_20
    always_comb begin
        if (!fifo_if.rst_n) begin

            async_reset_prop: assert final (
                (fifo_if.data_out     == '0) &&
                (fifo_if.full         == 1'b0) &&
                (fifo_if.empty        == 1'b1) &&
                (fifo_if.almostfull   == 1'b0) &&
                (fifo_if.almostempty  == 1'b0) &&
                (fifo_if.wr_ack       == 1'b0) &&
                (fifo_if.overflow     == 1'b0) &&
                (fifo_if.underflow    == 1'b0)
            ) ;
            async_reset_cover: cover final (
                (fifo_if.data_out     == '0) &&
                (fifo_if.full         == 1'b0) &&
                (fifo_if.empty        == 1'b1) &&
                (fifo_if.almostfull   == 1'b0) &&
                (fifo_if.almostempty  == 1'b0) &&
                (fifo_if.wr_ack       == 1'b0) &&
                (fifo_if.overflow     == 1'b0) &&
                (fifo_if.underflow    == 1'b0)
            );

        end
    end
endmodule
