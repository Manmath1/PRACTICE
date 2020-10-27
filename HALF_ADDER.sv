interface ha_interface;
  logic in1; //input 1
  logic in2; //input 2
  logic sum; //output sum
  logic carry; //output carry
  
  modport DUT(input in1, in2, output sum,carry);
  modport TEST(input sum,carry, output in1,in2);
endinterface : ha_interface

module half_adder(ha_interface.DUT dut_interface);
  
  //gate level implementation
  //xor x1(dut_interface.sum, dut_interface.in1, dut_interface.in2);
  //and a1(dut_interface.carry, dut_interface.in1, dut_interface.in2);
  //end gate level implementation
  
  //dataflow implementation
  assign dut_interface.sum = dut_interface.in1^dut_interface.in2;
  assign dut_interface.carry = dut_interface.in1&dut_interface.in2;
  //end dataflow implementation
  
endmodule : half_adder

//Test bench to be copied to testbench file
module ha_tb(ha_interface.TEST test_interface);
 
  initial begin
     test_interface.in1 = 1'b0; 
     test_interface.in2 = 1'b0;
    repeat(4) begin
      #10 {test_interface.in1,test_interface.in2} = {test_interface.in1,test_interface.in2} + 2'b01;
      $monitor("in1 = %d, in2 = %d, sum = %d, carry = %d\n",test_interface.in1,test_interface.in2,test_interface.sum,test_interface.carry);
    end //end of repeat
  end //end of initial
endmodule : ha_tb

module tb_top();
  
  ha_interface interface_init();
  ha_tb tb(interface_init);
  half_adder dut (interface_init);
  
endmodule : tb_top
