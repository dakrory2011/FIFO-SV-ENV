
import shared_pkg::*;
import FIFO_transaction_pkg::*;
import FIFO_coverage_pack::*;
import FIFO_scoreboard_pkg::*;
module fifo_monitor (fifo_interface.MON fifo_if);

    FIFO_transaction trans;
    FIFO_coverage    cov;
    FIFO_scoreboard  sb;
    
    initial begin
        trans  = new;
        cov  = new;
        sb = new;
        forever begin
            wait(check_event.triggered);
            @(negedge fifo_if.clk);


            trans.data_in = fifo_if.data_in;
            trans.rst_n = fifo_if.rst_n;
            trans.wr_en = fifo_if.wr_en;
            trans.rd_en = fifo_if.rd_en;
            trans.data_out = fifo_if.data_out;
            trans.full = fifo_if.full;
            trans.empty = fifo_if.empty;
            trans.almostfull = fifo_if.almostfull;
            trans.almostempty = fifo_if.almostempty;
            trans.wr_ack = fifo_if.wr_ack;
            trans.overflow = fifo_if.overflow;
            trans.underflow = fifo_if.underflow;

            fork
                begin
                    cov.sample_data(trans);
                end
                begin
                    sb.check_data(trans);
                end
            join

            if (test_finished) begin
                $display("Simulation done at time %t" , $time);
                $display("Correct Count: %0d , Error Count: %0d", correct_count, error_count);
                $stop;
            end
        end
    end

endmodule
