module tb_cases ();

  wire signal;
  assign signal = 1'b1;

  initial begin
    case (signal)
      1'bz: $display("signal is floating.");
      1'bx: $display("signal is unknown.");
      default: $display("signal is %b.", signal);
    endcase

    casez (signal)
      1'bz: $display("signal is floating.");
      1'bx: $display("signal is unknown.");
      default: $display("signal is %b.", signal);
    endcase

    casez (signal)
      1'bx: $display("signal is unknown.");
      1'bz: $display("signal is floating.");
      default: $display("signal is %b.", signal);
    endcase

    casex (signal)
      1'bx: $display("signal is unknown.");
      1'bz: $display("signal is floating.");
      default: $display("signal is %b.", signal);
    endcase

    $finish;
  end

endmodule
