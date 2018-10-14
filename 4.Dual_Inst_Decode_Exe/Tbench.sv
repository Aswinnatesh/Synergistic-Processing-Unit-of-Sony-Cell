//===================================================Test Bench for Cache==========================================================

module tbench();

logic clk, reset, wr_en;
logic [0:63] Instruction_1_2; // Output Instructions after Cache
logic [0:31] inst_feed [0:127];
logic [0:136] Even_Test_Packet;   //Packet Data Sent to Testbench for Verication Purpose
logic [0:168] Odd_Test_Packet;    //Packet Data Sent to Testbench for Verication Purpose

SPU_Cell dut(.clk(clk), 
      .reset(reset),
      .inst_feed(inst_feed),
      .Instruction_1_2(Instruction_1_2),
      .wr_en(wr_en),
      .Even_Test_Packet(Even_Test_Packet), 
      .Odd_Test_Packet(Odd_Test_Packet));

initial begin clk = 0; wr_en = 1; end
always #5 clk = ~clk;

initial begin
  
  // $monitor("\n|| CLOCK IN NS:\t", $time,"\n|| EVEN PIPE RESULT >>>  \n \tAddr_Rt2=\t\t\t\t     %d, \n \tData_Rt= %d, \n \tData_Rt(hex)=\t%h, \n \tWr_en=\t\t\t\t\t       %b, \n|| ODD PIPE RESULT >>>  \n \tAddr_Rt2=\t\t\t\t     %d, \n \tData_Rt= %d, \n \tData_Rt(hex)=\t%h, \n \tWr_en=\t\t\t\t\t       %b, \n \tBr_Pc_out=\t%b, \n",Even_Test_Packet[128:135], Even_Test_Packet[0:127],Even_Test_Packet[0:127], Even_Test_Packet[136], Odd_Test_Packet[128:135], Odd_Test_Packet[0:127],Odd_Test_Packet[0:127], Odd_Test_Packet[136], Odd_Test_Packet[137:168]);
  // //$monitor($time,,"Instruction_1=%b, Instruction_2=%b", Instruction_1_2[0:31], Instruction_1_2[32:63]);
  $readmemb("Instruction.txt", inst_feed); 

  // for(int l=0; l<127; l=l+1) // Check if Data is read Properly from File
  // $display("inst_feed:%b",inst_feed[l]);

  @(posedge clk) 
  #1 reset = 1;
  @(posedge clk) 
  #1 reset = 0;
// end

// initial begin   
  // @(posedge clk);
  // @(posedge clk);


#40 $finish; 

end
 initial begin       
        repeat(1000) begin
         @(posedge clk);
       end
       $display("Warning: Output not produced within 1000 clock cycles; stopping simulation so it doens't run forever");
       $stop;
     end

endmodule
