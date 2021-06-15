module cevero_ft_core
#(
	parameter N_EXT_PERF_COUNTERS = 0,
	parameter RV32E               = 0,
	parameter RV32M               = 0
)(
	// Clock and Reset
	input  logic        clk_i,
	input  logic        rst_ni,

	output logic [31:0] instr_addr_o_0,

	input  logic        clock_en_i,    // enable clock, otherwise it is gated
	input  logic        test_en_i,     // enable all clock gates for testing

	// Core ID, Cluster ID and boot address are considered more or less static
	input  logic [ 3:0] core_id_i,
	input  logic [ 5:0] cluster_id_i,
	input  logic [31:0] boot_addr_i,

	// Instruction memory interface
	output logic        instr_req_o,
	input  logic        instr_gnt_i,
	input  logic        instr_rvalid_i,
	output logic [31:0] instr_addr_o,
	input  logic [31:0] instr_rdata_i,

	// Data memory interface
	output logic        data_req_o,
	input  logic        data_gnt_i,
	input  logic        data_rvalid_i,
	output logic        data_we_o,
	output logic [3:0]  data_be_o,
	output logic [31:0] data_addr_o,
	output logic [31:0] data_wdata_o,
	input  logic [31:0] data_rdata_i,
	input  logic        data_err_i,

	// Interrupt inputs
	input  logic        irq_i,                 // level sensitive IR lines
	input  logic [4:0]  irq_id_i,
	output logic        irq_ack_o,             // irq ack
	output logic [4:0]  irq_id_o,

	// Debug Interface
	input  logic        debug_req_i,
	output logic        debug_gnt_o,
	output logic        debug_rvalid_o,
	input  logic [14:0] debug_addr_i,
	input  logic        debug_we_i,
	input  logic [31:0] debug_wdata_i,
	output logic [31:0] debug_rdata_o,
	output logic        debug_halted_o,
	input  logic        debug_halt_i,
	input  logic        debug_resume_i,

	// CPU Control Signals
	input  logic        fetch_enable_i,
	input  logic [N_EXT_PERF_COUNTERS-1:0] ext_perf_counters_i
);
 

    //////////////////////////////////////////////////////////////////
    //                        ___        _                   _      //
    //   ___ ___  _ __ ___   / _ \   ___(_) __ _ _ __   __ _| |___  //
    //  / __/ _ \| '__/ _ \ | | | | / __| |/ _` | '_ \ / _` | / __| //
    // | (_| (_) | | |  __/ | |_| | \__ \ | (_| | | | | (_| | \__ \ //
    //  \___\___/|_|  \___|  \___/  |___/_|\__, |_| |_|\__,_|_|___/ //
    //                                     |___/                    //
    //////////////////////////////////////////////////////////////////

    logic           regfile_we_0;
    logic [4:0]     regfile_waddr_0;
    logic [31:0]    regfile_wdata_0;
	logic [31:0]    pc_o_0;
	
	logic           clock_en_0; //  = 1;    // enable clock, otherwise it is gated
	logic           test_en_0; // = 0;     // enable all clock gates for testing
	
	// Core ID, Cluster ID and boot address are considered more or less static
	logic [ 3:0]    core_id_0; // = core_id_i;
	logic [ 5:0]    cluster_id_0; // = cluster_id_i;
	logic [31:0]    boot_addr_0;
	
	// Instruction memory interface
	logic           instr_req_0;
	logic           instr_gnt_0;
	logic           instr_rvalid_0;
	logic [31:0]    instr_addr_0;
	logic [31:0]    instr_rdata_0;
	
	// Data memory interface
	logic           data_req_0;
	logic           data_gnt_0;
	logic           data_rvalid_0;
	logic           data_we_0;
	logic [3:0]     data_be_0;
	logic [31:0]    data_addr_0;
	logic [31:0]    data_wdata_0;
	logic [31:0]    data_rdata_0;
	logic           data_err_0;
	
	// Interrupt /* inputs
	logic           irq_0;
	logic [4:0]     irq_id_in_0;
	logic           irq_ack_0;
	logic [4:0]     irq_id_out_0;
	
	// Debug Interface
	logic           debug_req_0;
	logic           debug_gnt_0;
	logic           debug_rvalid_0;
	logic [14:0]    debug_addr_0;
	logic           debug_we_0;
	logic [31:0]    debug_wdata_0;
	logic [31:0]    debug_rdata_0;
	logic           debug_halted_0;
	logic           debug_halt_0;
	logic           debug_resume_0;

    //////////////////////////////////////////////////////////////
    //                       _       _                   _      //
    //   ___ ___  _ __ ___  / |  ___(_) __ _ _ __   __ _| |___  //
    //  / __/ _ \| '__/ _ \ | | / __| |/ _` | '_ \ / _` | / __| //
    // | (_| (_) | | |  __/ | | \__ \ | (_| | | | | (_| | \__ \ //
    //  \___\___/|_|  \___| |_| |___/_|\__, |_| |_|\__,_|_|___/ //
    //                                 |___/                    //
    //////////////////////////////////////////////////////////////

    logic           regfile_we_1;
    logic [4:0]     regfile_waddr_1;
    logic [31:0]    regfile_wdata_1;
	logic [31:0]    pc_o_1;

	logic           clock_en_1; // = 1;    // enable clock, otherwise it is gated
	logic           test_en_1; // = 0;     // enable all clock gates for testing
	
	// Core ID, Cluster ID and boot address are considered more or less static
	logic [ 3:0]    core_id_1; // = core_id_i;
	logic [ 5:0]    cluster_id_1; // = cluster_id_i;
	logic [31:0]    boot_addr_1;
	
	// Instruction memory interface
	logic           instr_req_1;
	logic           instr_gnt_1;
	logic           instr_rvalid_1;
	logic [31:0]    instr_addr_1;
	logic [31:0]    instr_rdata_1;
	
	// Data memory interface
	logic           data_req_1;
	logic           data_gnt_1;
	logic           data_rvalid_1;
	logic           data_we_1;
	logic [3:0]     data_be_1;
	logic [31:0]    data_addr_1;
	logic [31:0]    data_wdata_1;
	logic [31:0]    data_rdata_1;
	logic           data_err_1;
	
	// Interrupt /* inputs
	logic           irq_1;
	logic [4:0]     irq_id_in_1;
	logic           irq_ack_1;
	logic [4:0]     irq_id_out_1;
	
	// Debug Interface
	logic           debug_req_1;
	logic           debug_gnt_1;
	logic           debug_rvalid_1;
	logic [14:0]    debug_addr_1;
	logic           debug_we_1;
	logic [31:0]    debug_wdata_1;
	logic [31:0]    debug_rdata_1;
	logic           debug_halted_1;
	logic           debug_halt_1;
	logic           debug_resume_1;

    ///////////////////////////////////////
    //                _                  //
    //   __ _ ___ ___(_) __ _ _ __  ___  //
    //  / _` / __/ __| |/ _` | '_ \/ __| //
    // | (_| \__ \__ \ | (_| | | | \__ \ //
    //  \__,_|___/___/_|\__, |_| |_|___/ //
    //                  |___/            //
    //                                   //
    ///////////////////////////////////////

	// assign fetch_enable_i 
	// assign instr_addr_o_0

	assign clock_en_0 = clock_en_i;    // enable clock, otherwise it is gated
	assign test_en_0 = test_en_i;     // enable all clock gates for testing

	// Core ID, Cluster ID and boot address are considered more or less static
	assign core_id_0 = core_id_i;
	assign cluster_id_0 = cluster_id_i;
	assign boot_addr_0 = boot_addr_i;

	// Instruction memory interface
	assign instr_req_o = instr_req_0;
	assign instr_gnt_0 = instr_gnt_i;
	assign instr_rvalid_0 = instr_rvalid_i;
	assign instr_addr_o = instr_addr_0;
	assign instr_rdata_0 = instr_rdata_i;

	// Data memory interface
	assign data_req_o = data_req_0;
	assign data_gnt_0 = data_gnt_i;
	assign data_rvalid_0 = data_rvalid_i;
	assign data_we_o = data_we_0;
	assign data_be_o = data_be_0;
	assign data_addr_o = data_addr_0;
	assign data_wdata_o = data_wdata_0;
	assign data_rdata_0 = data_rdata_i;
	assign data_err_0 = data_err_i;

	// Interrupt inputs
	assign irq_0 = irq_i;
	assign irq_id_in_0 = irq_id_i;
	assign irq_ack_o = irq_ack_0;
	assign irq_id_o = irq_id_out_0;

	// Debug Interface
	//assign debug_req_0 = debug_req_i;
	assign debug_gnt_o = debug_gnt_0;
	assign debug_rvalid_o = debug_rvalid_0;
	//assign debug_addr_0 = debug_addr_i;
	//assign debug_we_0 = debug_we_i;
	//assign debug_wdata_0 = debug_wdata_i;
	assign debug_rdata_o = debug_rdata_0;
	assign debug_halted_o = debug_halted_0;
	//assign debug_halt_0 = debug_halt_i;
	//assign debug_resume_0 = debug_resume_i;

    // // assigns core 0
	// assign instr_addr_o_0 = instr_addr_0;
    
    // --- assigns core 1 ---

	assign clock_en_1 = clock_en_i;    // enable clock, otherwise it is gated
	assign test_en_1 = test_en_i;     // enable all clock gates for testing

	// Core ID, Cluster ID and boot address are considered more or less static
	assign core_id_1 = core_id_i;
	assign cluster_id_1 = cluster_id_i;
	assign boot_addr_1 = boot_addr_i;

    // instr memory
    assign instr_rdata_1 = instr_rdata_0;
    assign instr_gnt_1 = instr_gnt_0;
    assign instr_rvalid_1 = instr_rvalid_0;

    // data memory
    assign data_rvalid_1 = data_rvalid_0;
    assign data_gnt_1 = data_gnt_0;
    assign data_rdata_1 = data_rdata_0;

    ///////////////////////////////
    // *** FT MODULE ASSIGNS *** //
    ///////////////////////////////

    logic        rst_n;
    logic        rst_crtl;
    logic        halt;
    logic        resume;
    logic        shift;
    logic [4:0]  addr_ftm;
    logic [14:0] addr_tmp;
    logic [31:0] data_ftm;
    logic [31:0] data_tmp;
    logic [31:0] spc_ftm;

	// These assignments allow the debug interface (Core 0) to be accessed
	// internaly by the FTM and externaly by the SoC

	assign debug_req_0 =  debug_halted_0 | debug_req_i;
	assign debug_req_1 =  debug_halted_1 | debug_req_i;
    assign debug_halt_0   = halt | debug_halt_i;
    assign debug_halt_1   = halt | debug_halt_i;
    assign debug_resume_0 = resume | debug_resume_i;
    assign debug_resume_1 = resume | debug_resume_i;
    assign debug_we_0     = debug_halted_0 | debug_we_i;
    assign debug_we_1     = debug_halted_1 | debug_we_i;
	assign rst_ctrl = rst_n & rst_ni;

	always_comb begin
		if (debug_halted_0 & debug_halted_1) begin
			debug_addr_0   <= addr_tmp;
			debug_addr_1   <= addr_tmp;
			debug_wdata_0  <= data_tmp;
			debug_wdata_1  <= data_tmp;
		end
		else begin
			debug_addr_0   <= debug_addr_i;
			debug_addr_1   <= debug_addr_i;
			debug_wdata_0  <= debug_wdata_i;
			debug_wdata_1  <= debug_wdata_1;
		end
	end

    // muxes
    assign addr_tmp = (shift) ? 15'h2000 : (15'h400 + (addr_ftm << 2)); 
	// Shift operation to allow for aligned access
	// because the debug unit assumes aligned access
    assign data_tmp = (shift) ? spc_ftm : data_ftm;

    // ***** test ***** //
	logic error = 0;
	int error_count = 0;
    logic [31:0] data;
    logic [31:0] test_data;
	logic enable_ftm = 0;

	always_ff @(posedge clk_i) begin
		// This signal instr_rdata_i receives the instruction data
		// When it is "0x00a00033" (add	zero,zero,a0), the error is enabled
		// When it is "0x00b00033" (add	zero,zero,a1), the error is disabled
		// If the "add" operation saves to the zero register, it is a no-operation instruction
		// because any writes to zero register are ignored

		if ( error == 0 && core_0.id_stage_i.instr == 32'h00a00033 ) begin
			$display("ERROR generation ~ENABLED~ at %t ps", $realtime);
			error = 1;
		end else if ( error == 1 && core_0.id_stage_i.instr == 32'h00b00033 ) begin
			$display("ERROR generation ~DISABLED~ at %t ps", $realtime);
			error = 0;
		end
	end

	always_ff @(posedge clk_i) begin
		if ( core_0.id_stage_i.instr == 32'h00c00033 ) begin
			$display("FTM ~ENABLED~ at %t ps", $realtime);
			enable_ftm = 1;
		end else if ( core_0.id_stage_i.instr == 32'h00d00033 ) begin
			$display("FTM ~DISABLED~ at %t ps", $realtime);
			enable_ftm = 0;
		end
	end

	int r;

	function logic [31:0] random_error_generator();
		if (error && error_count < 3) begin
			r = $urandom_range(0,100);
			// state = 0 means that the FTM is not in recovery state
			// We still have to avoid inserting errors during error recovery
			//if (r == 0 && ftm.control_module.state == 3'b000) begin
			if (r == 0) begin
				$display("[ERROR INSERTION] %t", $realtime);
				return 32'b00000000011000110000001110110011; //32'h006303b3
			end
		end 
		return instr_rdata_0;
	endfunction

    // Count detected errors
	always_ff @( posedge ftm.error ) begin : countError
		error_count = error_count + 1;
		$display("[ERROR DETECTED] %t", $realtime);
	end

    always_comb data = random_error_generator(); 

    ////////////////////////////////////////////////////////////////////
    //  _           _              _   _       _   _                  //
    // (_)_ __  ___| |_ __ _ _ __ | |_(_) __ _| |_(_) ___  _ __  ___  //     
    // | | '_ \/ __| __/ _` | '_ \| __| |/ _` | __| |/ _ \| '_ \/ __| //
    // | | | | \__ \ || (_| | | | | |_| | (_| | |_| | (_) | | | \__ \ //
    // |_|_| |_|___/\__\__,_|_| |_|\__|_|\__,_|\__|_|\___/|_| |_|___/ //
    //                                                                //
    ////////////////////////////////////////////////////////////////////

    ft_module ftm
    (
        .clk_i               ( clk_i               ),

        .we_a_i              ( regfile_we_0        ),
        .we_b_i              ( regfile_we_1        ),
        .addr_a_i            ( regfile_waddr_0     ),
        .addr_b_i            ( regfile_waddr_1     ),
        .data_a_i            ( regfile_wdata_0     ),
        .data_b_i            ( regfile_wdata_1     ),
        .spc_i               ( pc_o_0        	   ),
        .halted_i            ( debug_halted_0      ),
		.enable_i            ( enable_ftm          ),

        .spc_o               ( spc_ftm             ),
        .addr_o              ( addr_ftm            ),
        .data_o              ( data_ftm            ),
        .halt_o              ( halt                ),
        .resume_o            ( resume              ),
        .reset_o             ( rst_n               ),
        .shift_o             ( shift               )
    );
	  
	zeroriscy_core 
	#(
		.N_EXT_PERF_COUNTERS ( N_EXT_PERF_COUNTERS ), 
		.RV32E               ( RV32E               ), 
		.RV32M               ( RV32M               )
	)core_0(
        .regfile_we_o        ( regfile_we_0        ),
        .regfile_waddr_o     ( regfile_waddr_0     ),
        .regfile_wdata_o     ( regfile_wdata_0     ),
		.pc_o                ( pc_o_0              ),

		.clk_i               ( clk_i               ),
		.rst_ni              ( rst_ctrl            ),
		
		.clock_en_i          ( clock_en_0          ),
		.test_en_i           ( test_en_0           ),
		
		.core_id_i           ( core_id_0           ),
		.cluster_id_i        ( cluster_id_0        ),
		.boot_addr_i         ( boot_addr_0         ),
		
		.instr_req_o         ( instr_req_0         ),
		.instr_gnt_i         ( instr_gnt_0         ),
		.instr_rvalid_i      ( instr_rvalid_0      ),
		.instr_addr_o        ( instr_addr_0        ),
		.instr_rdata_i       ( data                ),
		
		.data_req_o          ( data_req_0          ),
		.data_gnt_i          ( data_gnt_0          ),
		.data_rvalid_i       ( data_rvalid_0       ),
		.data_we_o           ( data_we_0           ),
		.data_be_o           ( data_be_0           ),
		.data_addr_o         ( data_addr_0         ),
		.data_wdata_o        ( data_wdata_0        ),
		.data_rdata_i        ( data_rdata_0        ),
		.data_err_i          ( data_err_0          ),
		
		.irq_i               ( irq_0               ),
		.irq_id_i            ( irq_id_in_0          ),
		.irq_ack_o           ( irq_ack_0           ),
		.irq_id_o            ( irq_id_oou_0        ),
		
		.debug_req_i         ( debug_req_0         ),
		.debug_gnt_o         ( debug_gnt_0         ),
		.debug_rvalid_o      ( debug_rvalid_0      ),
		.debug_addr_i        ( debug_addr_0        ),
		.debug_we_i          ( debug_we_0          ),
		.debug_wdata_i       ( debug_wdata_0       ),
		.debug_rdata_o       ( debug_rdata_0       ),
		.debug_halted_o      ( debug_halted_0      ),
		.debug_halt_i        ( debug_halt_0        ),
		.debug_resume_i      ( debug_resume_0      ),
		
		.fetch_enable_i      ( fetch_enable_i      ),
	
		.ext_perf_counters_i (                     )
	);

	zeroriscy_core 
	#(
		.N_EXT_PERF_COUNTERS ( N_EXT_PERF_COUNTERS ), 
		.RV32E               ( RV32E               ), 
		.RV32M               ( RV32M               )
	)core_1(
        .regfile_we_o        ( regfile_we_1        ),
        .regfile_waddr_o     ( regfile_waddr_1     ),
        .regfile_wdata_o     ( regfile_wdata_1     ),
		.pc_o                ( pc_o_1              ),

		.clk_i               ( clk_i               ),
		.rst_ni              ( rst_ctrl            ),
		
		.clock_en_i          ( clock_en_1          ),
		.test_en_i           ( test_en_1           ),
		
		.core_id_i           ( core_id_1           ),
		.cluster_id_i        ( cluster_id_1        ),
		.boot_addr_i         ( boot_addr_i         ),
		
		.instr_req_o         ( instr_req_1         ),
		.instr_gnt_i         ( instr_gnt_1         ),
		.instr_rvalid_i      ( instr_rvalid_1      ),
		.instr_addr_o        ( instr_addr_1        ),
		.instr_rdata_i       ( instr_rdata_1       ),
		
		.data_req_o          ( data_req_1          ),
		.data_gnt_i          ( data_gnt_1          ),
		.data_rvalid_i       ( data_rvalid_1       ),
		.data_we_o           ( data_we_1           ),
		.data_be_o           ( data_be_1           ),
		.data_addr_o         ( data_addr_1         ),
		.data_wdata_o        ( data_wdata_1        ),
		.data_rdata_i        ( data_rdata_1        ),
		.data_err_i          ( data_err_1          ),
		
		.irq_i               ( irq_1               ),
		.irq_id_i            ( irq_id_in_1         ),
		.irq_ack_o           ( irq_ack_1           ),
		.irq_id_o            ( irq_id_out_1 )      ,
		
		.debug_req_i         ( debug_req_1         ),
		.debug_gnt_o         ( debug_gnt_1         ),
		.debug_rvalid_o      ( debug_rvalid_1      ),
		.debug_addr_i        ( debug_addr_1        ),
		.debug_we_i          ( debug_we_1          ),
		.debug_wdata_i       ( debug_wdata_1       ),
		.debug_rdata_o       ( debug_rdata_1       ),
		.debug_halted_o      ( debug_halted_1      ),
		.debug_halt_i        ( debug_halt_1        ),
		.debug_resume_i      ( debug_resume_1      ),
		
		.fetch_enable_i      ( fetch_enable_i      ),
	
		.ext_perf_counters_i (                     )
	);
	
endmodule
