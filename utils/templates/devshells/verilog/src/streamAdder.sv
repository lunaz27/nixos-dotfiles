module streamAdder (
    input            clk,
    input            rst,
    input      [1:0] in,
    output reg       carry,
    output reg       sum
);

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      carry <= 1'b0;
      sum   <= 1'b0;
    end else begin
      carry <= (in[0] & in[1]) | (in[0] & carry) | (in[1] & carry);
      sum   <= in[0] ^ in[1] ^ carry;
    end
  end

endmodule
