module FIFO(fifo_interface.DUT fifo_if);

	localparam max_fifo_addr = $clog2(fifo_if.FIFO_DEPTH);

	reg [fifo_if.FIFO_WIDTH-1:0] mem [fifo_if.FIFO_DEPTH-1:0];

	reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
	reg [max_fifo_addr:0] count;

	always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
		if (!fifo_if.rst_n) begin
			wr_ptr <= 0;
			fifo_if.wr_ack <= 0; // bug fixed
			fifo_if.overflow <= 0; // bug fixed
		end
		else if (fifo_if.wr_en && count < fifo_if.FIFO_DEPTH) begin
			mem[wr_ptr] <= fifo_if.data_in;
			fifo_if.wr_ack <= 1;
			wr_ptr <= wr_ptr + 1;
		end
		else begin 
			fifo_if.wr_ack <= 0; 
			if (fifo_if.full & fifo_if.wr_en)
				fifo_if.overflow <= 1;
			else
				fifo_if.overflow <= 0;
		end
	end

	always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
		if (!fifo_if.rst_n) begin
			rd_ptr <= 0;
			fifo_if.underflow <= 0; // bug fixed
			fifo_if.data_out <= 0; // bug fixed
		end
		else if (fifo_if.rd_en && count != 0) begin
			fifo_if.data_out <= mem[rd_ptr];
			rd_ptr <= rd_ptr + 1;
		end
		// bug fixed
		else begin
			if (fifo_if.empty && fifo_if.rd_en) 
				fifo_if.underflow <= 1;
			else
				fifo_if.underflow <= 0;
		end
	end

	always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
		if (!fifo_if.rst_n) begin
			count <= 0;
		end
		else begin
			if	( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b10) && !fifo_if.full) 
					count <= count + 1;
			else if ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b01) && !fifo_if.empty)
				count <= count - 1;
			// bug fixed
			else if ({fifo_if.wr_en, fifo_if.rd_en} == 2'b11) begin
				if (fifo_if.empty)
					count <= count + 1;
				if (fifo_if.full)
					count <= count - 1;
			end
		end
	end

	assign fifo_if.full = (count == fifo_if.FIFO_DEPTH)? 1 : 0;
	assign fifo_if.empty = (count == 0)? 1 : 0;
	assign fifo_if.almostfull = (count == fifo_if.FIFO_DEPTH-1)? 1 : 0; // bug fixed
	assign fifo_if.almostempty = (count == 1)? 1 : 0;

`ifdef SIM
// FIFO_1
	 property reset_prop;
        @(posedge fifo_if.clk)
        (!fifo_if.rst_n) |-> ##1 (wr_ptr == 0) && (rd_ptr == 0) && (count == 0);
    endproperty

//FIFO_2
    property wr_ack_prop;
        @(posedge fifo_if.clk) disable iff(!fifo_if.rst_n)
        (fifo_if.wr_en && !fifo_if.full) |-> ##1 fifo_if.wr_ack;
    endproperty

//FIFO_3
    property overflow_prop;
        @(posedge fifo_if.clk) disable iff(!fifo_if.rst_n)
        (fifo_if.wr_en && fifo_if.full) |-> ##1 fifo_if.overflow;
    endproperty

//FIFO_4
    property underflow_prop;
        @(posedge fifo_if.clk) disable iff(!fifo_if.rst_n)
        (fifo_if.rd_en && fifo_if.empty) |-> ##1 fifo_if.underflow;
    endproperty

//FIFO_5
    property empty_flag_prop;
        @(posedge fifo_if.clk) disable iff(!fifo_if.rst_n)
        (count == 0) |-> fifo_if.empty;
    endproperty

//FIFO_6
    property full_flag_prop;
        @(posedge fifo_if.clk) disable iff(!fifo_if.rst_n)
        (count == fifo_if.FIFO_DEPTH) |-> fifo_if.full;
    endproperty

//FIFO_7
    property almostfull_prop;
        @(posedge fifo_if.clk) disable iff(!fifo_if.rst_n)
        (count == fifo_if.FIFO_DEPTH - 1) |-> fifo_if.almostfull;
    endproperty

//FIFO_8
    property almostempty_prop;
        @(posedge fifo_if.clk) disable iff(!fifo_if.rst_n)
        (count == 1) |-> fifo_if.almostempty;
    endproperty

//FIFO_9
    property wr_ptr_wraparound_prop;
        @(posedge fifo_if.clk) disable iff(!fifo_if.rst_n)
        (wr_ptr == fifo_if.FIFO_DEPTH - 1) && fifo_if.wr_en && (count < fifo_if.FIFO_DEPTH)
        |-> ##1 (wr_ptr == 0);
    endproperty
//FIFO_10
    property rd_ptr_wraparound_prop;
        @(posedge fifo_if.clk) disable iff(!fifo_if.rst_n)
        (rd_ptr == fifo_if.FIFO_DEPTH - 1) && fifo_if.rd_en && (count != 0)
        |=> (rd_ptr == 0);
    endproperty
//FIFO_11
    property wr_ptr_threshold_prop;
        @(posedge fifo_if.clk) disable iff(!fifo_if.rst_n)
        wr_ptr < fifo_if.FIFO_DEPTH;
    endproperty
//FIFO_12
    property rd_ptr_threshold_prop;
        @(posedge fifo_if.clk) disable iff(!fifo_if.rst_n)
        rd_ptr < fifo_if.FIFO_DEPTH;
    endproperty
//FIFO_13
    property count_threshold_prop;
        @(posedge fifo_if.clk) disable iff(!fifo_if.rst_n)
        count <= fifo_if.FIFO_DEPTH;
    endproperty

    //===========================
    // Assertions and Covers
    //===========================

    assert property(reset_prop);
    cover property(reset_prop);

    assert property(wr_ack_prop);
    cover property(wr_ack_prop);

    assert property(overflow_prop);
    cover property(overflow_prop);

    assert property(underflow_prop);
    cover property(underflow_prop);

    assert property(empty_flag_prop);
    cover property(empty_flag_prop);

    assert property(full_flag_prop);
    cover property(full_flag_prop);

    assert property(almostfull_prop);
    cover property(almostfull_prop);

    assert property(almostempty_prop);
    cover property(almostempty_prop);

    assert property(wr_ptr_wraparound_prop);
    cover property(wr_ptr_wraparound_prop);

    assert property(rd_ptr_wraparound_prop)
        else $error("Read pointer wraparound failed");
    cover property(rd_ptr_wraparound_prop);

    assert property(wr_ptr_threshold_prop)
        else $error("Write pointer exceeded threshold");
    cover property(wr_ptr_threshold_prop);

    assert property(rd_ptr_threshold_prop)
        else $error("Read pointer exceeded threshold");
    cover property(rd_ptr_threshold_prop);

    assert property(count_threshold_prop)
        else $error("Count exceeded FIFO depth");
    cover property(count_threshold_prop);

`endif

endmodule