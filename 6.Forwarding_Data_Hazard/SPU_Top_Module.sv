// g++ Parser.cc -o gen -std=c++11 -O3

//./a.out

// vlog +acc SPU_Top_Module.sv Cache.sv Decode.sv Dependency.sv Regfile.sv Evenpipe.sv Oddpipe.sv Tbench.sv

// vsim tbench -c -do "run -all"

//=================================================== PARAMETERIZATION  =========================================================

parameter SIMPLE_FIXED1_UNIT      =1;     parameter SIMPLE_FIXED1_LATENCY      =2;
parameter SIMPLE_FIXED2_UNIT      =2;     parameter SIMPLE_FIXED2_LATENCY      =4;
parameter SINGLE_PRECISION1_UNIT  =3;     parameter SINGLE_PRECISION1_LATENCY  =6;
parameter SINGLE_PRECISION2_UNIT  =3;     parameter SINGLE_PRECISION2_LATENCY  =7;
parameter BYTE_UNIT               =4;     parameter BYTE_LATENCY               =4;
parameter PERMUTE_UNIT            =5;     parameter PERMUTE_LATENCY            =4; 
parameter LOCALSTORE_UNIT         =6;     parameter LOCALSTORE_LATENCY         =6; 
parameter BRANCH_UNIT             =7;     parameter BRANCH_LATENCY             =4;
  
//=====================================================  SPU TOP MOD  =========================================================== (0 CYCLE LAT)
module SPU_Cell(clk, reset, inst_feed, Instruction_1_2, wr_en, Even_Test_Packet, Odd_Test_Packet);

input clk, reset, wr_en;
input  [0:31] inst_feed [0:127];
output [0:63] Instruction_1_2; // Output Instructions after Cache

output logic [0:136] Even_Test_Packet;   //Packet Data Sent to Testbench for Verication Purpose
output logic [0:168] Odd_Test_Packet;    //Packet Data Sent to Testbench for Verication Purpose

logic imiss, decode_stall_1;
logic [0:14] pc;
logic  [0:14] Cache_load_addr;
logic  [0:1023] Cache_load_data;

logic [0:6] addr_even_ra, addr_even_rb, addr_even_rc;  
logic [0:6] addr_odd_ra, addr_odd_rb, addr_odd_rc;  
logic [0:10] opcode_even;              
logic signed [0:6] imm7_even;          
logic signed [0:9] imm10_even;         
logic signed [0:15] imm16_even;        
logic signed [0:17] imm18_even;        
logic [0:6] addr_even_rt;   
logic [0:10] opcode_odd;       
logic [0:6] imm7_odd;          
logic [0:9] imm10_odd;         
logic [0:15] imm16_odd;        
logic [0:17] imm18_odd;        
logic [0:6] addr_odd_rt;

logic [0:10] opcode_even_depend;         
logic signed [0:6] imm7_even_depend;           
logic signed [0:9] imm10_even_depend;          
logic signed [0:15] imm16_even_depend;        
logic signed [0:17] imm18_even_depend;         
logic [0:6] addr_even_rt_depend;         
logic [0:6] addr_even_ra_depend, addr_even_rb_depend, addr_even_rc_depend; 

logic [0:142] Rt_Temp_even, Rt_Temp1_even, Rt_Temp2_even, Rt_Temp3_even, Rt_Temp4_even, Rt_Temp5_even, Rt_Temp6_even;

logic [0:10] opcode_odd_depend;            
logic signed [0:6] imm7_odd_depend;                
logic signed [0:9] imm10_odd_depend;              
logic signed [0:15] imm16_odd_depend;             
logic signed [0:17] imm18_odd_depend;                 
logic signed [0:6] addr_odd_rt_depend;   
logic [0:6] addr_odd_ra_depend, addr_odd_rb_depend, addr_odd_rc_depend;  

logic [0:175] Rt_Temp_odd, Rt_Temp1_odd, Rt_Temp2_odd, Rt_Temp3_odd, Rt_Temp4_odd, Rt_Temp5_odd, Rt_Temp6_odd;


Local_Store LS( .clk(clk),
                .reset(reset),
                .data_in(inst_feed),
                .addr(Cache_load_addr),
                .data_out(Cache_load_data),
                .wr_en(wr_en),
                .pc(pc), 
                .imiss(imiss));

Cache Cache   (.clk(clk), 
               .reset(reset), 
               .Cache_load_addr(Cache_load_addr), 
               .Cache_load_data(Cache_load_data), 
               .pc(pc),
               .imiss(imiss),  
               .Inst_out(Instruction_1_2));

PC PC         (.clk(clk),
               .reset(reset),
               .pc(pc),
               .imiss(imiss),
               .decode_stall_1(decode_stall_1),
               .Dependency_stall(Dependency_stall));


Decode Decode (.clk(clk), 
               .reset(reset), 
               .Inst_out(Instruction_1_2),
               .decode_stall_1(decode_stall_1),
               .addr_even_ra(addr_even_ra), 
               .addr_even_rb(addr_even_rb),
               .addr_even_rc(addr_even_rc), 
               .opcode_even(opcode_even),
               .imm10_even(imm10_even), 
               .imm16_even(imm16_even), 
               .imm18_even(imm18_even), 
               .imm7_even(imm7_even),
               .addr_even_rt(addr_even_rt),
               .addr_odd_ra(addr_odd_ra), 
               .addr_odd_rb(addr_odd_rb), 
               .addr_odd_rc(addr_odd_rc), 
               .opcode_odd(opcode_odd), 
               .imm10_odd(imm10_odd), 
               .imm16_odd(imm16_odd), 
               .imm18_odd(imm18_odd),
               .imm7_odd(imm7_odd),
               .addr_odd_rt(addr_odd_rt),
               .Dependency_Stall(Dependency_stall));

Dependency Dependency (.clk(clk),
                       .reset(reset),
                       .addr_even_ra(addr_even_ra), 
                       .addr_even_rb(addr_even_rb),
                       .addr_even_rc(addr_even_rc), 
                       .opcode_even(opcode_even),
                       .imm10_even(imm10_even), 
                       .imm16_even(imm16_even), 
                       .imm18_even(imm18_even), 
                       .imm7_even(imm7_even), 
                       .Rt_Temp_even(Rt_Temp_even), 
                       .Rt_Temp1_even(Rt_Temp1_even), 
                       .Rt_Temp2_even(Rt_Temp2_even), 
                       .Rt_Temp3_even(Rt_Temp3_even), 
                       .Rt_Temp4_even(Rt_Temp4_even), 
                       .Rt_Temp5_even(Rt_Temp5_even), 
                       .Rt_Temp6_even(Rt_Temp6_even),
                       .addr_even_rt(addr_even_rt),


                       .addr_odd_ra(addr_odd_ra), 
                       .addr_odd_rb(addr_odd_rb), 
                       .addr_odd_rc(addr_odd_rc), 
                       .opcode_odd(opcode_odd), 
                       .imm10_odd(imm10_odd), 
                       .imm16_odd(imm16_odd), 
                       .imm18_odd(imm18_odd),
                       .imm7_odd(imm7_odd), 
                       .Rt_Temp_odd(Rt_Temp_odd), 
                       .Rt_Temp1_odd(Rt_Temp1_odd), 
                       .Rt_Temp2_odd(Rt_Temp2_odd), 
                       .Rt_Temp3_odd(Rt_Temp3_odd), 
                       .Rt_Temp4_odd(Rt_Temp4_odd), 
                       .Rt_Temp5_odd(Rt_Temp5_odd), 
                       .Rt_Temp6_odd(Rt_Temp6_odd),

                       .addr_odd_rt(addr_odd_rt), 

                       .flush(flush),

                       .opcode_even_depend(opcode_even_depend), 
                       .imm7_even_depend(imm7_even_depend), 
                       .imm10_even_depend(imm10_even_depend), 
                       .imm16_even_depend(imm16_even_depend), 
                       .imm18_even_depend(imm18_even_depend), 
                       .addr_even_rt_depend(addr_even_rt_depend), 
                       .addr_even_ra_depend(addr_even_ra_depend), 
                       .addr_even_rb_depend(addr_even_rb_depend), 
                       .addr_even_rc_depend(addr_even_rc_depend),
                       .opcode_odd_depend(opcode_odd_depend),
                       .imm7_odd_depend(imm7_odd_depend),
                       .imm10_odd_depend(imm10_odd_depend),
                       .imm16_odd_depend(imm16_odd_depend),
                       .imm18_odd_depend(imm18_odd_depend),
                       .addr_odd_rt_depend(addr_odd_rt_depend),
                       .addr_odd_ra_depend(addr_odd_ra_depend), 
                       .addr_odd_rb_depend(addr_odd_rb_depend), 
                       .addr_odd_rc_depend (addr_odd_rc_depend), 


                       .Dependency_stall (Dependency_stall));


reg_file reg_file(  .clk(clk),                                            
                    .reset(reset),                                       

                    .opcode_even(opcode_even_depend),                   
                    .imm7_even(imm7_even_depend),                      
                    .imm10_even(imm10_even_depend),                    
                    .imm16_even(imm16_even_depend),                    
                    .imm18_even(imm18_even_depend),                    
                    .addr_even_rt(addr_even_rt_depend),               
                    .addr_even_ra(addr_even_ra_depend),               
                    .addr_even_rb(addr_even_rb_depend),               
                    .addr_even_rc(addr_even_rc_depend),               
                    .Rt_Temp_even_Rout(Rt_Temp_even), 
                    .Rt_Temp1_even_Rout(Rt_Temp1_even), 
                    .Rt_Temp2_even_Rout(Rt_Temp2_even), 
                    .Rt_Temp3_even_Rout(Rt_Temp3_even), 
                    .Rt_Temp4_even_Rout(Rt_Temp4_even), 
                    .Rt_Temp5_even_Rout(Rt_Temp5_even), 
                    .Rt_Temp6_even_Rout(Rt_Temp6_even),


                    .opcode_odd(opcode_odd_depend),                  
                    .imm7_odd(imm7_odd_depend),                  
                    .imm10_odd(imm10_odd_depend),                
                    .imm16_odd(imm16_odd_depend),                
                    .imm18_odd(imm18_odd_depend),                
                    .addr_odd_rt(addr_odd_rt_depend),            
                    .addr_odd_ra(addr_odd_ra_depend),             
                    .addr_odd_rb(addr_odd_rb_depend),            
                    .addr_odd_rc(addr_odd_rc_depend),            
                    .Rt_Temp_odd_Rout(Rt_Temp_odd), 
                    .Rt_Temp1_odd_Rout(Rt_Temp1_odd), 
                    .Rt_Temp2_odd_Rout(Rt_Temp2_odd), 
                    .Rt_Temp3_odd_Rout(Rt_Temp3_odd), 
                    .Rt_Temp4_odd_Rout(Rt_Temp4_odd), 
                    .Rt_Temp5_odd_Rout(Rt_Temp5_odd), 
                    .Rt_Temp6_odd_Rout(Rt_Temp6_odd),

                    .Even_Test_Packet(Even_Test_Packet),
                    .Odd_Test_Packet(Odd_Test_Packet),

                    
                    .Pc_in(pc),
                    .flush(flush));



//always_ff@(posedge clk) begin $display("@ SPU CELL Rt_Temp_even: %h",Rt_Temp_even); end

endmodule
