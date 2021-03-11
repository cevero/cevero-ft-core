module ft_spc
(
	input               clk,
	input               rst_n,
	input               spc_control_i,
	input  logic [31:0] spc_i,        
	output logic [31:0] spc_o
);

	logic [31:0] pc;

	always_ff @(posedge clk)
		if (spc_control_i)
			spc_o <= pc;
		else
			pc <= spc_i;	
	
	always_ff @(posedge clk, negedge rst_n)
		if (!rst_n)
			pc <= 32'd0;

endmodule
