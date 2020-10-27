nterface addrsub_interface;
  logic func; //to perform subtraction or addition
  logic in1; //input 1
  logic in2; //input 2
  logic in3; //input 3, carryin or borrowin
  logic sumOrDifference; //output sum or difference
  logic carryOrBorrow; //output Carry or Borrow
  
  modport DUT(input in1, in2,in3,func, output sumOrDifference,carryOrBorrow);
  modport TEST(input carryOrBorrow,sumOrDifference, output in1,in2,in3,func);
endinterface : addrsub_interface

module Fsub_adder(addrsub_interface.DUT dut_interface);
  
  //gate level implementation
  //xor x1(dut_interface.sum, dut_interface.in1, //dut_interface.in2,dut_interface.in3);
  //and ca1(cw1, dut_interface.in3,dut_interface.in1^dut_interface.in2);
  //or ca2(cw2, cw1,dut_interface.in3+dut_interface.in2);
  //end gate level implementation
  
  //dataflow implementation
  assign dut_interface.sumOrDifference = dut_interface.in1^dut_interface.in2^dut_interface.in3;
  //func high -> act as adder
  assign dut_interface.carryOrBorrow = (dut_interface.func&(((dut_interface.in1^dut_interface.in2)&dut_interface.in3) + (dut_interface.in1&dut_interface.in2))) + (~dut_interface.func&((~dut_interface.in1&(dut_interface.in2^dut_interface.in3)) + (dut_interface.in2&dut_interface.in3)));
  
  //end dataflow implementation
  
endmodule : Fsub_adder

//testbench
module Fsub_adder_tb(addrsub_interface.TEST test_interface);
 
  initial begin
     test_interface.func = 1'b0;
     test_interface.in1 = 1'b0; 
     test_interface.in2 = 1'b0;
     test_interface.in3 = 1'b0;	
    repeat(16) begin
      #10 {test_interface.func,test_interface.in1,test_interface.in2,test_interface.in3} = {test_interface.func,test_interface.in1,test_interface.in2,test_interface.in3} + 4'b001;
      $monitor("mode = %d,in1 = %d, in2 = %d, in3 = %d, sum/Diff = %d, carry/borr = %d\n",test_interface.func,test_interface.in1,test_interface.in2,test_interface.in3,test_interface.sumOrDifference,test_interface.carryOrBorrow);
    end //end of repeat
  end //end of initial
endmodule : Fsub_adder_tb

module tb_top();
  
  addrsub_interface interface_init();
  Fsub_adder_tb tb(interface_init);
  Fsub_adder dut (interface_init);
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,tb_top);
  end
endmodule : tb_top
