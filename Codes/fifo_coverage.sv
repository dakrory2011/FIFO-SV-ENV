package FIFO_coverage_pack;
import FIFO_transaction_pkg::* ;
import shared_pkg::*;
class FIFO_coverage;
FIFO_transaction F_cvg_txn;

covergroup CovGroup ;

//FIFO_19
write_en_cp: coverpoint F_cvg_txn.wr_en
{
bins wr_en_on  = {1};
bins wr_en_off = {0};
}

read_en_cp: coverpoint F_cvg_txn.rd_en
{
 bins rd_en_on  = {1};
 bins rd_en_off = {0};    
}

full_cp: coverpoint F_cvg_txn.full
{
 bins full_high     =   {1};
 bins full_low =   {0}; 
}

almostfull_cp: coverpoint F_cvg_txn.almostfull
{
bins almostfull_high  = {1};
bins almostfull_low   = {0};
}

empty_cp:   coverpoint F_cvg_txn.empty
{
bins empty_high = {1};
bins empty_low  = {0};
}

almostempty_cp:   coverpoint F_cvg_txn.almostempty
{
bins almostempty_high  =  {1};
bins almostempty_low =  {0};
}

overflow_cp:    coverpoint F_cvg_txn.overflow
{
bins overflow_high = {1};
bins overflow_low  = {0};
}

underflow_cp:     coverpoint F_cvg_txn.underflow
{
bins underflow_high = {1};
bins underflow_low  = {0};
}

wr_ack_cp:    coverpoint F_cvg_txn.wr_ack
{
bins wr_ack_high = {1};
bins wr_ack_low  = {0};
}

wr_rd_full: cross write_en_cp , read_en_cp , full_cp
{
bins read_write_full = binsof(write_en_cp) && binsof(read_en_cp) && binsof(full_cp) ; 
}

wr_rd_almostfull: cross write_en_cp , read_en_cp , almostfull_cp
{
bins read_write_almostfull = binsof(write_en_cp) && binsof(read_en_cp) && binsof(almostfull_cp) ;
}

wr_rd_empty:  cross write_en_cp , read_en_cp , empty_cp
{
 bins read_write_empty = binsof(write_en_cp) && binsof(read_en_cp) && binsof(empty_cp) ;
}

wr_rd_almostempty: cross write_en_cp , read_en_cp , almostempty_cp
{
bins read_write_almostempty = binsof(write_en_cp) && binsof(read_en_cp) && binsof(almostempty_cp) ;
}

wr_rd_overflow: cross write_en_cp , read_en_cp , overflow_cp
{
 bins read_write_overflow = binsof(write_en_cp) && binsof(read_en_cp) && binsof(overflow_cp) ;
}

wr_rd_underflow : cross write_en_cp , read_en_cp , underflow_cp
{
  bins read_write_underflow  = binsof(write_en_cp) && binsof(read_en_cp) && binsof(underflow_cp) ;   
}

wr_rd_wrack:  cross write_en_cp , read_en_cp , wr_ack_cp
{
     bins read_write_ack  = binsof(write_en_cp) && binsof(read_en_cp) && binsof(wr_ack_cp) ;
}

endgroup

 function new();
    CovGroup = new();
    F_cvg_txn = new();
  endfunction

function void sample_data (FIFO_transaction F_txn);
F_cvg_txn = F_txn;
CovGroup.sample();
endfunction

endclass
endpackage