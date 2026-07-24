module tb_streamAdder ();
  wire       clk;
  reg        rst;
  reg  [1:0] in;
  wire       carry;
  wire       sum;

  clk clkUUT (.clk(clk));
  streamAdder streamAdderUUT (
      .clk(clk),
      .rst(rst),
      .in(in),
      .carry(carry),
      .sum(sum)
  );


  initial begin
    $dumpfile("build/test_001.vcd");
    $dumpvars(0, tb_streamAdder);

    in  = 2'b00;
    rst = 1'b0;
    #10;

    rst = 1'b1;
    @(negedge clk);
    in = 2'b00;

    @(negedge clk);
    in = 2'b01;

    @(negedge clk);
    in = 2'b11;

    @(negedge clk);
    in = 2'b10;

    @(negedge clk);
    in = 2'b00;

    #10;

    $finish;
  end

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      $display("in: %b -> sum: %b, carry: %b", in, sum, carry);
    end
  end

endmodule

