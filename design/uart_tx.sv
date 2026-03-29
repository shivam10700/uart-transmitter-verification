module uart_tx #(
    parameter CLK_FREQ = 50_000_000,   // 50 MHz
    parameter BAUD_RATE = 1_000_000	// 1 Mbps
)(
    input  logic clk,
    input  logic rst_n,
    input  logic tx_start,
    input  logic [7:0] tx_data,
    output logic tx,
    output logic tx_busy
);

    // Baud rate counter
    localparam int CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

    typedef enum logic [2:0] {
        IDLE,
        START,
        DATA,
        STOP
    } state_t;

    state_t state;

    logic [$clog2(CLKS_PER_BIT):0] clk_cnt;
    logic [2:0] bit_idx;
    logic [7:0] data_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            tx       <= 1'b1;
            clk_cnt  <= 0;
            bit_idx  <= 0;
            tx_busy  <= 0;
        end else begin
            case (state)

                IDLE: begin
                    tx <= 1'b1;
                    clk_cnt <= 0;
                    bit_idx <= 0;
                    tx_busy <= 0;

                    if (tx_start) begin
                        data_reg <= tx_data;
                        state    <= START;
                        tx_busy  <= 1;
                    end
                end

                START: begin
                    tx <= 1'b0; // Start bit
                    if (clk_cnt < CLKS_PER_BIT-1)
                        clk_cnt <= clk_cnt + 1;
                    else begin
                        clk_cnt <= 0;
                        state   <= DATA;
                    end
                end

                DATA: begin
                    tx <= data_reg[bit_idx];
                    if (clk_cnt < CLKS_PER_BIT-1)
                        clk_cnt <= clk_cnt + 1;
                    else begin
                        clk_cnt <= 0;
                        if (bit_idx < 7)
                            bit_idx <= bit_idx + 1;
                        else begin
                            bit_idx <= 0;
                            state   <= STOP;
                        end
                    end
                end

                STOP: begin
                    tx <= 1'b1;
                    if (clk_cnt < CLKS_PER_BIT-1)
                        clk_cnt <= clk_cnt + 1;
                    else begin
                        clk_cnt <= 0;
                        state   <= IDLE;
                    end
                end

            endcase
        end
    end

endmodule
