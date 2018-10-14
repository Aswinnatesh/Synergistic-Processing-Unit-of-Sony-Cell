
//=================================================== Register File ==========================================================

module reg_file (clk, reset, Pc_in, addr_even_ra, addr_even_rb, addr_even_rc, opcode_even, imm10_even, imm16_even, imm18_even, imm7_even, addr_even_rt,
addr_odd_ra, addr_odd_rb, addr_odd_rc, opcode_odd, imm10_odd, imm16_odd, imm18_odd, imm7_odd, addr_odd_rt, flush,Rt_Temp_even_Rout, Rt_Temp1_even_Rout, Rt_Temp2_even_Rout, Rt_Temp3_even_Rout, Rt_Temp4_even_Rout, Rt_Temp5_even_Rout, Rt_Temp6_even_Rout,Rt_Temp_odd_Rout, Rt_Temp1_odd_Rout, Rt_Temp2_odd_Rout, Rt_Temp3_odd_Rout, Rt_Temp4_odd_Rout, Rt_Temp5_odd_Rout, Rt_Temp6_odd_Rout, Even_Test_Packet, Odd_Test_Packet);

    // Input to REG File for Processing
     input clk, reset;
     input [0:6] addr_even_ra, addr_even_rb, addr_even_rc;  
     input [0:6] addr_odd_ra, addr_odd_rb, addr_odd_rc;   
     output logic [0:136] Even_Test_Packet;   //Packet Data Sent to Testbench for Verication Purpose
     output logic [0:168] Odd_Test_Packet;    //Packet Data Sent to Testbench for Verication Purpose
    
    // Even Pipe Forwarding and Data Stuff
    input [0:10] opcode_even;              // Input from TB
    input signed [0:6] imm7_even;          // logic from TB
    input signed [0:9] imm10_even;         // logic from TB
    input signed [0:15] imm16_even;        // logic from TB
    input signed [0:17] imm18_even;        // logic from TB
    input [0:6] addr_even_rt;              // Input from TB
    logic [0:6] addr_even_rt2;             // Receiving from Even Pipe
    logic signed [0:127] data_even_rt;     // Receiving from Even Pipe
    logic wr_en_even;                      // Receiving from Even Pipe
    logic [0:142]Rt_Temp_even, Rt_Temp1_even, Rt_Temp2_even, Rt_Temp3_even, Rt_Temp4_even, Rt_Temp5_even, Rt_Temp6_even;
    output logic [0:142]Rt_Temp_even_Rout, Rt_Temp1_even_Rout, Rt_Temp2_even_Rout, Rt_Temp3_even_Rout, Rt_Temp4_even_Rout, Rt_Temp5_even_Rout, Rt_Temp6_even_Rout;

    logic [0:142] Rt_Temp_even_Test; 


    logic signed [0:127] data_even_ra, data_even_rb, data_even_rc;  // Data to Even Pipe
    logic signed [0:127] data_even_ra1, data_even_ra2,data_even_ra3,data_even_ra4,data_even_ra5,data_even_ra6,data_even_ra_new;
    logic signed [0:127] data_even_rb1, data_even_rb2,data_even_rb3,data_even_rb4,data_even_rb5,data_even_rb6,data_even_rb_new;
    logic signed [0:127] data_even_rc1, data_even_rc2,data_even_rc3,data_even_rc4,data_even_rc5,data_even_rc6,data_even_rc_new;
    logic [0:10] opcode_even_fwd;        // Forward Reg for 1 Cycle Delay
    logic signed [0:6] imm7_even_fwd;          // Forward Reg for 1 Cycle Delay 
    logic signed [0:9] imm10_even_fwd;         // Forward Reg for 1 Cycle Delay 
    logic signed [0:15] imm16_even_fwd;        // Forward Reg for 1 Cycle Delay 
    logic signed [0:17] imm18_even_fwd;        // Forward Reg for 1 Cycle Delay 
    logic [0:6] addr_even_rt_fwd;        // Forward Reg for 1 Cycle Delay        
 
    // Odd Pipe Forwarding and Data Stuff
    input flush;
    input [0:10] opcode_odd;       // Input from TB
    input [0:6] imm7_odd;          // logic from TB
    input [0:9] imm10_odd;         // logic from TB
    input [0:15] imm16_odd;        // logic from TB
    input [0:17] imm18_odd;        // logic from TB
    input [0:6] addr_odd_rt;       // Input from TB
    input [0:14] Pc_in;            // Input from TB
    logic [0:6] addr_odd_rt2;      // Receiving from odd Pipe
    logic [0:127] data_odd_rt;     // Receiving from odd Pipe
    logic [0:14] Pc_out_2;    
    logic wr_en_odd, flush_fwd;               // Receiving from odd Pipe
    
    output logic [0:175]Rt_Temp_odd_Rout, Rt_Temp1_odd_Rout, Rt_Temp2_odd_Rout, Rt_Temp3_odd_Rout, Rt_Temp4_odd_Rout, Rt_Temp5_odd_Rout, Rt_Temp6_odd_Rout;
    logic [0:175]Rt_Temp_odd, Rt_Temp1_odd, Rt_Temp2_odd, Rt_Temp3_odd, Rt_Temp4_odd, Rt_Temp5_odd, Rt_Temp6_odd;
    

    logic [0:127] data_odd_ra, data_odd_rb, data_odd_rc; // Data to odd Pipe
    logic [0:10] opcode_odd_fwd;            // Forward Reg for 1 Cycle Delay
    logic [0:6] imm7_odd_fwd;               // Forward Reg for 1 Cycle Delay 
    logic [0:9] imm10_odd_fwd;              // Forward Reg for 1 Cycle Delay 
    logic [0:15] imm16_odd_fwd;             // Forward Reg for 1 Cycle Delay 
    logic [0:17] imm18_odd_fwd;             // Forward Reg for 1 Cycle Delay   
    logic [0:6] addr_odd_rt_fwd;            // Forward Reg for 1 Cycle Delay
    logic [0:14] Pc_in_fwd;                 // Forward Reg for 1 Cycle Delay

    // Odd and Even Pipe Connections

     evenpipe evenp (   .clk(clk),                                     // Input
                        .reset(reset),                                 // Input
                        .opcode_even(opcode_even_fwd),                 // Input
                        .imm7_even(imm7_even_fwd),                     // Input
                        .imm10_even(imm10_even_fwd),                   // Input
                        .imm16_even(imm16_even_fwd),                   // Input
                        .imm18_even(imm18_even_fwd),                   // Input
                        .data_even_ra(data_even_ra),                   // Input
                        .data_even_rb(data_even_rb),                   // Input
                        .data_even_rc(data_even_rc),                   // Input
                        .addr_even_rt(addr_even_rt_fwd),               // Input
                        .addr_even_rt2(addr_even_rt2),                 // Output Receiving
                        .data_even_rt(data_even_rt),                   // Output Receiving                 
                        .wr_en_even(wr_en_even),                       // Output Receiving
                        .Rt_Temp(Rt_Temp_even), // Rt_Temp_even

                        .Rt_Temp1(Rt_Temp1_even), 
                        .Rt_Temp2(Rt_Temp2_even), 
                        .Rt_Temp3(Rt_Temp3_even), 
                        .Rt_Temp4(Rt_Temp4_even), 
                        .Rt_Temp5(Rt_Temp5_even), 
                        .Rt_Temp6(Rt_Temp6_even));

     oddpipe oddp (     .clk(clk),                      // Input
                        .reset(reset),                  // Input
                        .opcode_odd(opcode_odd_fwd),    // Input
                        .imm7_odd(imm7_odd_fwd),        // Input
                        .imm10_odd(imm10_odd_fwd),      // Input
                        .imm16_odd(imm16_odd_fwd),      // Input
                        .imm18_odd(imm18_odd_fwd),      // Input
                        .data_odd_ra(data_odd_ra),      // Input
                        .data_odd_rb(data_odd_rb),      // Input
                        .data_odd_rc(data_odd_rc),      // Input
                        .addr_odd_rt(addr_odd_rt_fwd),  // Input
                        .addr_odd_rt2(addr_odd_rt2),    //Output Receiving
                        .data_odd_rt(data_odd_rt),      //Output Receiving
                        .wr_en_odd(wr_en_odd),          //Output Receiving  
                        .Pc_in(Pc_in_fwd),              //Output Receiving
                        .Pc_out_2(Pc_out_2),            //Output Receiving
                        .flush(flush_fwd),    // Flush Signal from TB 
                        .Rt_Temp0_fwd(Rt_Temp_odd), 
                        .Rt_Temp1(Rt_Temp1_odd), 
                        .Rt_Temp2(Rt_Temp2_odd), 
                        .Rt_Temp3(Rt_Temp3_odd), 
                        .Rt_Temp4(Rt_Temp4_odd), 
                        .Rt_Temp5(Rt_Temp5_odd), 
                        .Rt_Temp6(Rt_Temp6_odd)); 

     always_comb begin
      Rt_Temp_odd_Rout   =  Rt_Temp_odd;   
      Rt_Temp1_odd_Rout  = Rt_Temp1_odd;
      Rt_Temp2_odd_Rout  = Rt_Temp2_odd;
      Rt_Temp3_odd_Rout  = Rt_Temp3_odd;
      Rt_Temp4_odd_Rout  = Rt_Temp4_odd;
      Rt_Temp5_odd_Rout  = Rt_Temp5_odd;
      Rt_Temp6_odd_Rout  = Rt_Temp6_odd;
      
      Rt_Temp_even_Rout = Rt_Temp_even; 
      Rt_Temp1_even_Rout = Rt_Temp1_even; 
      Rt_Temp2_even_Rout = Rt_Temp2_even; 
      Rt_Temp3_even_Rout = Rt_Temp3_even; 
      Rt_Temp4_even_Rout = Rt_Temp4_even; 
      Rt_Temp5_even_Rout = Rt_Temp5_even; 
      Rt_Temp6_even_Rout = Rt_Temp6_even;
   end


   //always_ff @(posedge clk) begin $display("@REG FILE: %d", Rt_Temp_even_Rout[0:2]); $display("@REG 2 FILE: %d", Rt_Temp_even[0:2]); end


     logic [0:127][0:127] mem;     

     assign Even_Test_Packet = {data_even_rt, addr_even_rt2, wr_en_even}; 
     assign Odd_Test_Packet = {data_odd_rt, addr_odd_rt2,  wr_en_odd, Pc_out_2};
 
     always_ff @(posedge clk) begin
        if(reset) begin 
            // integer i; 
            // for (i=0; i<124; i=i+1)
            // mem[i] = i;
            mem[124]=32'h408ccccd;
            mem[125]=128'd79228162532711081671548469249;
            mem[126]=128'd170808406006153739902585569290863280256;
            mem[127]=128'd170808403787765189503184116671632670848;
            mem[12] = 128'b00111111100000000000000000000000_01000000000000000000000000000000_01000000010000000000000000000000_01000000100000000000000000000000; // A Reg Matrix 1 (1,2,3,4)
            //mem[112] = 128'h3F800000400000004040000040800000; // A Reg Matrix 1 (1,2,3,4)
            mem[13] = 128'b01000000101000000000000000000000_01000000111000000000000000000000_01000000101000000000000000000000_01000000111000000000000000000000; // B1 Reg Matrix (5 7 5 7)
            mem[14] = 128'b01000000110000000000000000000000_01000001000000000000000000000000_01000000110000000000000000000000_01000001000000000000000000000000; // B2 Reg Matrix (6 8 6 8)

        end
    end

     always_ff @(posedge clk) begin         // Write data to Even Pipe
        if(wr_en_even)
        mem[addr_even_rt2] <= data_even_rt;
     end

     always_ff @(posedge clk) begin         // Write data to Odd Pipe
        if(wr_en_odd)
        mem[addr_odd_rt2] <= data_odd_rt;
     end

/*always_ff @(posedge clk) begin

        data_even_ra1 <= data_even_ra; 
  data_even_ra2 <= data_even_ra1;
  data_even_ra3 <= data_even_ra2;
  data_even_ra4 <= data_even_ra3;
  data_even_ra5 <= data_even_ra4;
  data_even_ra6 <= data_even_ra5;
    end
*/

    always_ff @(posedge clk) begin
/*
//latency=2,stage=2
if (Rt_Temp1_even [3:5] == 2 && Rt_Temp1_even [7:14] == addr_even_ra) begin   // Even vs Even
$display("Lat 2 & stage 2");
       data_even_ra <= Rt_Temp1_even [15:142]; data_even_rb <= mem[addr_even_rb]; data_even_rc <= mem[addr_even_rc];data_odd_ra <=mem[addr_odd_ra]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <= mem[addr_odd_rc];
    //data_even_ra_new<=data_even_ra;
    end
    else if(Rt_Temp1_even [3:5] == 2 && Rt_Temp1_even [7:14] == addr_even_rb) begin // Even vs Even
       data_even_ra <= mem[addr_even_ra]; data_even_rb <= Rt_Temp1_even [15:142]; data_even_rc <= mem[addr_even_rc];data_odd_ra <=mem[addr_odd_ra]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <= mem[addr_odd_rc]; end
    else if (Rt_Temp1_even [3:5] == 2 && Rt_Temp1_even [7:14] == addr_even_rc) begin  // Even vs Even
       data_even_ra <=mem[addr_even_ra];  data_even_rb <= mem[addr_even_rb]; data_even_rc <= Rt_Temp1_even [15:142];data_odd_ra <=mem[addr_odd_ra]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <= mem[addr_odd_rc]; end
    else if (Rt_Temp1_even [3:5] == 2 && Rt_Temp1_even [7:14] == addr_odd_ra) begin // Even vs Odd
       data_odd_ra <= Rt_Temp1_even [15:142]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <= mem[addr_odd_rc];data_even_ra <=mem[addr_even_ra]; data_even_rb <= mem[addr_even_rb]; data_even_rc <= mem[addr_even_rc];  end
    else if(Rt_Temp1_even [3:5] == 2 && Rt_Temp1_even [7:14] == addr_odd_rb) begin  // Even vs Odd
       data_odd_ra <= mem[addr_odd_ra]; data_odd_rb <= Rt_Temp1_even [15:142]; data_odd_rc <= mem[addr_odd_rc];data_even_ra <=mem[addr_even_ra]; data_even_rb <= mem[addr_even_rb]; data_even_rc <= mem[addr_even_rc];  end
    else if (Rt_Temp1_even [3:5] == 2 && Rt_Temp1_even [7:14] == addr_odd_rc) begin // Even vs Odd
       data_odd_ra <= mem[addr_odd_ra]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <=  Rt_Temp1_even [15:142];data_even_ra <=mem[addr_even_ra]; data_even_rb <= mem[addr_even_rb]; data_even_rc <= mem[addr_even_rc];end
   

    //latency=4,stage=4
    else if (Rt_Temp3_even [3:5] == 4 && Rt_Temp3_even [7:14] == addr_even_ra) begin    // Even vs Even
       data_even_ra <= Rt_Temp3_even [15:142]; data_even_rb <= mem[addr_even_rb]; data_even_rc <= mem[addr_even_rc];data_odd_ra <=mem[addr_odd_ra]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <= mem[addr_odd_rc];end
    else if(Rt_Temp3_even [3:5] == 4 && Rt_Temp3_even [7:14] == addr_even_rb) begin // Even vs Even
       data_even_ra <= mem[addr_even_ra]; data_even_rb <= Rt_Temp3_even [15:142]; data_even_rc <= mem[addr_even_rc];data_odd_ra <=mem[addr_odd_ra]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <= mem[addr_odd_rc]; end
    else if (Rt_Temp3_even [3:5] == 4 && Rt_Temp3_even [7:14] == addr_even_rc) begin  // Even vs Even
       data_even_ra <=mem[addr_even_ra];  data_even_rb <= mem[addr_even_rb]; data_even_rc <= Rt_Temp3_even [15:142];data_odd_ra <=mem[addr_odd_ra]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <= mem[addr_odd_rc]; end
    else if (Rt_Temp3_even [3:5] == 4 && Rt_Temp3_even [7:14] == addr_odd_ra) begin // Even vs Odd
       data_odd_ra <= Rt_Temp3_even [15:142]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <= mem[addr_odd_rc];data_even_ra <=mem[addr_even_ra]; data_even_rb <= mem[addr_even_rb]; data_even_rc <= mem[addr_even_rc];  end
    else if(Rt_Temp3_even [3:5] == 4 && Rt_Temp3_even [7:14] == addr_odd_rb) begin  // Even vs Odd
       data_odd_ra <= mem[addr_odd_ra]; data_odd_rb <= Rt_Temp3_even [15:142]; data_odd_rc <= mem[addr_odd_rc];data_even_ra <=mem[addr_even_ra]; data_even_rb <= mem[addr_even_rb]; data_even_rc <= mem[addr_even_rc];  end
    else if (Rt_Temp3_even [3:5] == 4 && Rt_Temp3_even [7:14] == addr_odd_rc) begin // Even vs Odd
       data_odd_ra <= mem[addr_odd_ra]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <= Rt_Temp3_even [15:142];data_even_ra <=mem[addr_even_ra]; data_even_rb <= mem[addr_even_rb]; data_even_rc <= mem[addr_even_rc];end
    
   


     //latency=6,stage=6
        else if (Rt_Temp5_even [3:5] == 6 && Rt_Temp5_even [7:14] == addr_even_ra) begin    // Even vs Even
       data_even_ra <= Rt_Temp5_even [15:142]; data_even_rb <= mem[addr_even_rb]; data_even_rc <= mem[addr_even_rc];data_odd_ra <=mem[addr_odd_ra]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <= mem[addr_odd_rc];end
    else if(Rt_Temp5_even [3:5] == 6 && Rt_Temp5_even [7:14] == addr_even_rb) begin // Even vs Even
       data_even_ra <= mem[addr_even_ra]; data_even_rb <= Rt_Temp5_even [15:142]; data_even_rc <= mem[addr_even_rc];data_odd_ra <=mem[addr_odd_ra]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <= mem[addr_odd_rc]; end
    else if (Rt_Temp5_even [3:5] == 6 && Rt_Temp5_even [7:14] == addr_even_rc) begin  // Even vs Even
       data_even_ra <=mem[addr_even_ra];  data_even_rb <= mem[addr_even_rb]; data_even_rc <= Rt_Temp5_even [15:142];data_odd_ra <=mem[addr_odd_ra]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <= mem[addr_odd_rc]; end
    else if (Rt_Temp5_even [3:5] == 6 && Rt_Temp5_even [7:14] == addr_odd_ra) begin // Even vs Odd
       data_odd_ra <= Rt_Temp5_even [15:142]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <= mem[addr_odd_rc];data_even_ra <=mem[addr_even_ra]; data_even_rb <= mem[addr_even_rb]; data_even_rc <= mem[addr_even_rc];  end
    else if(Rt_Temp5_even [3:5] == 6 && Rt_Temp5_even [7:14] == addr_odd_rb) begin  // Even vs Odd
       data_odd_ra <= mem[addr_odd_ra]; data_odd_rb <= Rt_Temp5_even [15:142]; data_odd_rc <= mem[addr_odd_rc];data_even_ra <=mem[addr_even_ra]; data_even_rb <= mem[addr_even_rb]; data_even_rc <= mem[addr_even_rc];  end
    else if (Rt_Temp5_even [3:5] == 6 && Rt_Temp5_even [7:14] == addr_odd_rc) begin // Even vs Odd
       data_odd_ra <= mem[addr_odd_ra]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <=  Rt_Temp5_even [15:142];data_even_ra <=mem[addr_even_ra]; data_even_rb <= mem[addr_even_rb]; data_even_rc <= mem[addr_even_rc];end

   
     //latency=7,stage=7
        else if (Rt_Temp6_even [3:5] == 7 && Rt_Temp6_even [7:14] == addr_even_ra) begin    // Even vs Even
    //for(int i=0; i<6; i=i+1)begin
    //data_even_ra<=128'bx;
    //end
$display("Lat 7 & stage 7");
       data_even_ra6 <= Rt_Temp6_even [15:142]; data_even_rb <= mem[addr_even_rb]; data_even_rc <= mem[addr_even_rc];data_odd_ra <=mem[addr_odd_ra]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <= mem[addr_odd_rc];end
    else if(Rt_Temp6_even [3:5] == 7 && Rt_Temp6_even [7:14] == addr_even_rb) begin // Even vs Even
       data_even_ra <= mem[addr_even_ra]; data_even_rb <= Rt_Temp6_even [15:142]; data_even_rc <= mem[addr_even_rc];data_odd_ra <=mem[addr_odd_ra]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <= mem[addr_odd_rc]; end
    else if (Rt_Temp6_even [3:5] == 7 && Rt_Temp6_even [7:14] == addr_even_rc) begin  // Even vs Even
       data_even_ra <=mem[addr_even_ra];  data_even_rb <= mem[addr_even_rb]; data_even_rc <= Rt_Temp6_even [15:142];data_odd_ra <=mem[addr_odd_ra]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <= mem[addr_odd_rc]; end
    else if (Rt_Temp6_even [3:5] == 7 && Rt_Temp6_even [7:14] == addr_odd_ra) begin // Even vs Odd
       data_odd_ra <= Rt_Temp6_even [15:142]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <= mem[addr_odd_rc];data_even_ra <=mem[addr_even_ra]; data_even_rb <= mem[addr_even_rb]; data_even_rc <= mem[addr_even_rc];  end
    else if(Rt_Temp6_even [3:5] == 7 && Rt_Temp6_even [7:14] == addr_odd_rb) begin  // Even vs Odd
       data_odd_ra <= mem[addr_odd_ra]; data_odd_rb <= Rt_Temp6_even [15:142]; data_odd_rc <= mem[addr_odd_rc];data_even_ra <=mem[addr_even_ra]; data_even_rb <= mem[addr_even_rb]; data_even_rc <= mem[addr_even_rc];  end
    else if (Rt_Temp6_even [3:5] == 7 && Rt_Temp6_even [7:14] == addr_odd_rc) begin // Even vs Odd
       data_odd_ra <= mem[addr_odd_ra]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <=  Rt_Temp6_even [15:142];data_even_ra <=mem[addr_even_ra]; data_even_rb <= mem[addr_even_rb]; data_even_rc <= mem[addr_even_rc];end
   
  //latency=4,stage=4
    if (Rt_Temp1_odd [3:5] == 4 && Rt_Temp1_odd [7:14] == addr_even_ra && Rt_Temp2_odd [7:14] != addr_even_ra && Rt_Temp1_odd [7:14] != addr_even_ra) begin   // Even vs Even
       data_even_ra <= Rt_Temp3_odd [15:142]; data_even_rb <= mem[addr_even_rb]; data_even_rc <= mem[addr_even_rc];data_odd_ra <=mem[addr_odd_ra]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <= mem[addr_odd_rc];end
    else if(Rt_Temp1_odd [3:5] == 4 && Rt_Temp1_odd [7:14] == addr_even_rb && Rt_Temp2_odd [7:14] != addr_even_rb && Rt_Temp1_odd [7:14] != addr_even_rb) begin // Even vs Even
       data_even_ra <= mem[addr_even_ra]; data_even_rb <= Rt_Temp3_odd [15:142]; data_even_rc <= mem[addr_even_rc];data_odd_ra <=mem[addr_odd_ra]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <= mem[addr_odd_rc]; end
    else if (Rt_Temp1_odd [3:5] == 4 && Rt_Temp1_odd [7:14] == addr_even_rc && Rt_Temp2_odd [7:14] != addr_even_rc && Rt_Temp1_odd [7:14] != addr_even_rc) begin  // Even vs Even
       data_even_ra <= mem[addr_even_ra]; data_even_rb <= mem[addr_even_rb]; data_even_rc <= Rt_Temp3_odd [15:142] ;data_odd_ra <=mem[addr_odd_ra]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <= mem[addr_odd_rc];  end
    else if (Rt_Temp1_odd [3:5] == 4 && Rt_Temp1_odd [7:14] == addr_odd_ra && Rt_Temp2_odd [7:14] != addr_odd_ra && Rt_Temp1_odd [7:14] != addr_odd_ra) begin // Even vs Odd
       data_odd_ra <= Rt_Temp3_odd [15:142]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <= mem[addr_odd_rc];data_even_ra <=mem[addr_even_ra]; data_even_rb <= mem[addr_even_rb]; data_even_rc <= mem[addr_even_rc]; end
    else if(Rt_Temp1_odd [3:5] == 4 && Rt_Temp1_odd [7:14] == addr_odd_rb && Rt_Temp2_odd [7:14] != addr_odd_rb && Rt_Temp1_odd [7:14] != addr_odd_rb) begin  // Even vs Odd
       data_odd_ra <= mem[addr_odd_ra]; data_odd_rb <= Rt_Temp3_odd [15:142]; data_odd_rc <= mem[addr_odd_rc];data_even_ra <=mem[addr_even_ra]; data_even_rb <= mem[addr_even_rb]; data_even_rc <= mem[addr_even_rc]; end
    else if (Rt_Temp1_odd [3:5] == 4 && Rt_Temp1_odd [7:14] == addr_odd_rc && Rt_Temp2_odd [7:14] != addr_odd_rc && Rt_Temp1_odd [7:14] != addr_odd_rc) begin // Even vs Odd
       data_odd_ra <= mem[addr_odd_ra]; data_odd_rb <= mem[addr_odd_rb]; data_odd_rc <= Rt_Temp3_odd [15:142];data_even_ra <=mem[addr_even_ra]; data_even_rb <= mem[addr_even_rb]; data_even_rc <= mem[addr_even_rc]; end
    
    
   

else begin
*/ 
        data_even_ra <= mem[addr_even_ra];
        data_even_rb <= mem[addr_even_rb];
        data_even_rc <= mem[addr_even_rc];

        data_odd_ra <= mem[addr_odd_ra];
        data_odd_rb <= mem[addr_odd_rb];
        data_odd_rc <= mem[addr_odd_rc];
     end
//end
    always_ff @(posedge clk) begin       // Instruction Forward to Pipes
      opcode_even_fwd <= opcode_even; addr_even_rt_fwd <= addr_even_rt;
      imm7_even_fwd <= imm7_even; imm10_even_fwd <= imm10_even; 
      imm16_even_fwd <= imm16_even; imm18_even_fwd <= imm18_even; 
      
      opcode_odd_fwd <= opcode_odd; addr_odd_rt_fwd <= addr_odd_rt;
      imm7_odd_fwd <= imm7_odd; imm10_odd_fwd <= imm10_odd; 
      imm16_odd_fwd <= imm16_odd; imm18_odd_fwd <= imm18_odd; 
      Pc_in_fwd <= Pc_in;  flush_fwd <= flush;
     end

     //always_comb $display ("===========>>> unit_temp:%d , latency_temp:%d , wr_en:%d , addr_even_rt:%d",    Rt_Temp_even[0:2], Rt_Temp_even[3:5],  Rt_Temp_even[6], Rt_Temp_even[7:14]);

endmodule
