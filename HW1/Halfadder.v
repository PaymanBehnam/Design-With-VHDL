module halfAdder(a, b, s, co);
  input a, b;
  output s, co;
  reg s, co;
  always @(a,b)
  begin
    {co, s} = a + b;
  end
endmodule
