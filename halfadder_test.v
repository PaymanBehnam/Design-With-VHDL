module halfAdder_test();
reg a_test, b_test;
wire s_test, co_test;
halfAdder HA(a_test, b_test, s_test, co_test);
initial
  begin
    a_test = 0; b_test = 0;
    #10; b_test = 1;
    #10; a_test =1;
    #10; b_test =0;
    #10;
  end
endmodule
