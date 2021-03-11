module ft_comparator
#(
    parameter ADDR_WIDTH = 5,
    parameter DATA_WIDTH = 32
)
(
    input  logic                  we_a_i,
    input  logic                  we_b_i,
    input  logic [ADDR_WIDTH-1:0] addr_a_i,
    input  logic [ADDR_WIDTH-1:0] addr_b_i,
    input  logic [DATA_WIDTH-1:0] data_a_i,
    input  logic [DATA_WIDTH-1:0] data_b_i,
    output logic [ADDR_WIDTH-1:0] addr_o,
    output logic [DATA_WIDTH-1:0] data_o,
    output logic                  error_o
);

always_comb
    if ({we_a_i,addr_a_i,data_a_i} ^ {we_b_i,addr_b_i,data_b_i})
        error_o <= 1'b1;
    else begin
        addr_o <= addr_a_i;
        data_o <= data_a_i;
        error_o <= 1'b0;
    end
endmodule
