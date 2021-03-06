module ft_control
#(
    parameter ADDR_WIDTH = 5
)
(
    input  logic                  clk_i,
    input  logic                  error_i,
    input  logic                  halted_i,
    input  logic                  enable_i,
    output logic                  reset_o,
    output logic                  halt_o,
    output logic                  resume_o,
    output logic                  shift_o,
    output logic                  we_sgpr_o,
    output logic                  we_spc_o,
    output logic [ADDR_WIDTH-1:0] replay_addr_o
);

    localparam NUM_REG = 2**ADDR_WIDTH;

    localparam WAIT      = 3'b000;
    localparam RESET     = 3'b001;
    localparam HALT      = 3'b010;
    localparam HALT_WAIT = 3'b011;
    localparam WORK_SPC  = 3'b100;
    localparam WORK_SGPR = 3'b101;
    localparam DONE      = 3'b110;

    logic [2:0]            state = 3'b000;
    logic [ADDR_WIDTH-1:0] iterator;
    logic [ADDR_WIDTH-1:0] addr;
    logic                  recovery_error = 1'b0;

    always_ff @(posedge clk_i) begin
        if (enable_i) begin
            case (state)
            WAIT: begin end                
            RESET:
                state <= HALT;
            HALT:
                state <= HALT_WAIT;
            HALT_WAIT:
                if (halted_i)
                    state <= WORK_SPC;
            WORK_SPC:
                state <= WORK_SGPR;
            WORK_SGPR:
                if (iterator < NUM_REG-1) begin
                    iterator = iterator + 1;
                    addr = iterator;
                end else
                    state <= DONE;
            DONE: begin
                state <= WAIT;
                iterator <= 0;
                recovery_error <= 0;
            end
            default: 
                state <= RESET;
            endcase

            if (error_i) begin
                if (state != WAIT) begin
                    recovery_error <= 1;
                end
                state <= RESET;
                iterator <= 0;
            end
        end
    end

    always_comb begin
        case (state)
            WAIT: begin
                halt_o <= 0;
                resume_o <= 0;
                shift_o <= 0;
                reset_o <= 1;
                we_sgpr_o <= 1;
                we_spc_o <= 0;
            end
            RESET: begin
                halt_o <= 0;
                resume_o <= 0;
                shift_o <= 0;
                reset_o <= 0;
                we_sgpr_o <= 0;
                // spc should be saved only if we have an error during
                // normal program execution. If the error happens during recovery
                // we should avoid spc saving (keeping the spc that was previously saved)
                we_spc_o <= ~recovery_error;
            end
            HALT: begin
                halt_o <= 1;
                resume_o <= 0;
                reset_o <= 1;
                shift_o <= 1;
                we_sgpr_o <= 0;
                we_spc_o <= 0;
            end
            HALT_WAIT: begin
                halt_o <= 0;
                resume_o <= 0;
                reset_o <= 1;
                shift_o <= 1;
                we_sgpr_o <= 0;
                we_spc_o <= 0;
            end
            WORK_SPC: begin
                halt_o <= 0;
                reset_o <= 1;
                resume_o <= 0;
                shift_o <= 0;
                we_spc_o <= 0;
                we_sgpr_o <= 0;
            end
            WORK_SGPR: begin
                halt_o <= 0;
                reset_o <= 1;
                resume_o <= 0;
                shift_o <= 0;
                we_spc_o <= 0;
                we_sgpr_o <= 0;
            end
            DONE: begin
                halt_o <= 0;
                reset_o <= 1;
                resume_o <= 1;
                shift_o <= 0;
                we_spc_o <= 0;
                we_sgpr_o <= 0;
            end
        endcase
    end

    assign replay_addr_o = addr;
endmodule
