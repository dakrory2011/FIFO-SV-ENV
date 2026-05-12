package FIFO_transaction_pkg;
    
    class FIFO_transaction;
        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;
        rand bit rst_n, wr_en, rd_en;
        rand bit [FIFO_WIDTH-1:0] data_in;
        bit [FIFO_WIDTH-1:0] data_out;
        bit full, empty, almostfull, almostempty, underflow;
        bit wr_ack, overflow;
        integer RD_EN_ON_DIST;
        integer WR_EN_ON_DIST;
    
        function new(integer RD_EN_ON_DIST = 30, integer WR_EN_ON_DIST = 70);
            this.RD_EN_ON_DIST = RD_EN_ON_DIST;
            this.WR_EN_ON_DIST = WR_EN_ON_DIST;
        endfunction
    // FIFO_14
        constraint reset 
            {
             rst_n  dist {0 := 10, 1 := 90}; 
             }
    //FIFO_15
        constraint write_enable_cons
           { 
            wr_en  dist {1 := WR_EN_ON_DIST, 0 := 100-WR_EN_ON_DIST};
           }
    //FIFO_16       
        constraint read_enable_cons
           {
             wr_en  dist {1 := RD_EN_ON_DIST, 0 := 100-RD_EN_ON_DIST};
           }
    endclass

endpackage