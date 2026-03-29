module uart_tx_tb;

    logic clk;
    logic rst_n;
    logic tx_start;
    logic [7:0] tx_data;
    logic tx;
    logic tx_busy;

    // DUT
    uart_tx #(
        .CLK_FREQ(50_000_000),
      .BAUD_RATE(1_000_000)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    // Clock generation (50MHz)
    always #10 clk = ~clk;

    // Task to send data
    task send_byte(input [7:0] data);
        begin
            @(posedge clk);
            tx_data  <= data;
            tx_start <= 1;

            @(posedge clk);
            tx_start <= 0;

            wait(tx_busy);
            wait(!tx_busy);
        end
    endtask

    initial begin
        // Init
        clk = 0;
        rst_n = 0;
        tx_start = 0;
        tx_data = 0;

        #100;
        rst_n = 1;

        // Send multiple bytes
        send_byte(8'hA5);
        send_byte(8'h3C);
        send_byte(8'hF0);

        #100000;
        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t | TX=%b | BUSY=%b", $time, tx, tx_busy);
    end
  initial begin
  $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
