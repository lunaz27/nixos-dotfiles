module clk (
    output reg clk
);

  initial begin
    clk = 1'b0;
    forever begin
      #5 clk = ~clk;
    end
  end

endmodule
