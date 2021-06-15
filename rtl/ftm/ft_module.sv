module ft_module
#(
    parameter ADDR_WIDTH = 5,
    parameter DATA_WIDTH = 32
)(
    input  logic                  clk_i,

    // comparator inputs
    input  logic                  we_a_i,
    input  logic                  we_b_i,
    input  logic [ADDR_WIDTH-1:0] addr_a_i,
    input  logic [ADDR_WIDTH-1:0] addr_b_i,
    input  logic [DATA_WIDTH-1:0] data_a_i,
    input  logic [DATA_WIDTH-1:0] data_b_i,
    input  logic                  halted_i,
    input  logic                  enable_i,

    // spc inputs and outputs
    input  logic [DATA_WIDTH-1:0] spc_i,
    output logic [DATA_WIDTH-1:0] spc_o,

    // address output from controller
    output logic [ADDR_WIDTH-1:0] addr_o,

    // sgpr output
    output logic [DATA_WIDTH-1:0] data_o,

    // fetch_block_signal
    output logic                  halt_o,
    output logic                  resume_o,
    output logic                  shift_o,
    output logic                  reset_o
);

    logic                  error;
    logic                  we_sgpr;
    logic                  we_spc;
    logic [ADDR_WIDTH-1:0] addr;
    logic [DATA_WIDTH-1:0] data;

    ft_comparator comparator_module
    (
        .we_a_i         (we_a_i      ),
        .we_b_i         (we_b_i      ),
        .addr_a_i       (addr_a_i    ),
        .addr_b_i       (addr_b_i    ),
        .data_a_i       (data_a_i    ),
        .data_b_i       (data_b_i    ),
        .addr_o         (addr        ),
        .data_o         (data        ),
        .error_o        (error       )
    );

    // Writing to the sgpr should happen only when the controler allows (we_sgpr)
    // and we have both cores writing to the registers (we_a_i & we_b_i)
    assign we_sgpr_i = we_sgpr & we_a_i & we_b_i & ~error;
    ft_sgpr sgpr_module
    (
        .clk            (clk_i       ),
        .rst_n          (            ),
        .test_en_i      (            ),
        .raddr_a_i      (addr_o      ),
        .rdata_a_o      (data_o      ),
        .raddr_b_i      (            ),
        .rdata_b_o      (            ),
        .waddr_a_i      (addr        ),
        .wdata_a_i      (data        ),
        .we_a_i         (we_sgpr_i   )
    );

    ft_spc spc_module
    (
	    .clk            (clk_i       ),
	    .rst_n          (            ),
	    .spc_control_i  (we_spc      ),
	    .spc_i          (spc_i       ), 
	    .spc_o          (spc_o       )
    );

    ft_control control_module
    (
        .clk_i         (clk_i        ),
        .error_i       (error        ),
        .halted_i      (halted_i     ),
        .enable_i      (enable_i     ),
        .reset_o       (reset_o      ),
        .halt_o        (halt_o       ),
        .resume_o      (resume_o     ),
        .shift_o       (shift_o      ),
        .we_sgpr_o     (we_sgpr      ),
        .we_spc_o      (we_spc       ),
        .replay_addr_o (addr_o       )
    );

endmodule
