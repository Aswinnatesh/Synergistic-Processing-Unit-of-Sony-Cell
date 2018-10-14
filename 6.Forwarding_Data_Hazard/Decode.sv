//========================================================= DECODE ============================================================= (1 CYCLE LAT)

module Decode (clk, reset, Dependency_Stall, Inst_out, decode_stall_1,addr_even_ra, addr_even_rb, addr_even_rc, opcode_even, imm10_even, imm16_even, imm18_even, imm7_even, addr_even_rt,addr_odd_ra, addr_odd_rb, addr_odd_rc, opcode_odd, imm10_odd, imm16_odd, imm18_odd, imm7_odd, addr_odd_rt );

input clk, reset, Dependency_Stall;
input [0:63] Inst_out;


output logic [0:6] addr_even_ra, addr_even_rb, addr_even_rc;  
output logic [0:6] addr_odd_ra, addr_odd_rb, addr_odd_rc;  
output logic [0:10] opcode_even;              
output logic signed [0:6] imm7_even;          
output logic signed [0:9] imm10_even;         
output logic signed [0:15] imm16_even;        
output logic signed [0:17] imm18_even;        
output logic [0:6] addr_even_rt;   
output logic [0:10] opcode_odd;       
output logic [0:6] imm7_odd;          
output logic [0:9] imm10_odd;         
output logic [0:15] imm16_odd;        
output logic [0:17] imm18_odd;        
output logic [0:6] addr_odd_rt;

output logic decode_stall_1;
 
logic Prev_stall; 

// output [0:6] addr_even_ra, addr_even_rb, addr_even_rc;  
// output [0:6] addr_odd_ra, addr_odd_rb, addr_odd_rc;  
// output [0:10] opcode_even;              
// output signed [0:6] imm7_even;          
// output signed [0:9] imm10_even;         
// output signed [0:15] imm16_even;        
// output signed [0:17] imm18_even;        
// output [0:6] addr_even_rt;   
// output [0:10] opcode_odd;       
// output [0:6] imm7_odd;          
// output [0:9] imm10_odd;         
// output [0:15] imm16_odd;        
// output [0:17] imm18_odd;        
// output [0:6] addr_odd_rt;

// output logic decode_stall_1;

logic Even_inst1, Even_inst2, Prev_Even_Hazard, Prev_Odd_Hazard, Even_Structural_Hazard, No_Structural_Hazard, Odd_Structural_Hazard;
logic [0:6]  addr_even_ra_inst1, addr_even_rb_inst1, addr_even_rc_inst1, addr_even_ra_inst2, addr_even_rb_inst2, addr_even_rc_inst2;  
logic [0:6]  addr_odd_ra_inst1, addr_odd_rb_inst1, addr_odd_rc_inst1, addr_odd_ra_inst2, addr_odd_rb_inst2, addr_odd_rc_inst2; 
logic [0:10]  opcode_even_inst1, opcode_even_inst2;       // logic from TB

logic signed [0:6]  imm7_even_inst1, imm7_even_inst2;   // logic from TB
logic signed [0:9]  imm10_even_inst1, imm10_even_inst2;  // logic from TB
logic signed [0:15] imm16_even_inst1, imm16_even_inst2; // logic from TB
logic signed [0:17]  imm18_even_inst1, imm18_even_inst2; // logic from TB
logic [0:6]  addr_even_rt_inst1, addr_even_rt_inst2;       // logic from TB

logic [0:10] opcode_odd_inst1, opcode_odd_inst2;       // logic from TB
logic [0:6]  imm7_odd_inst1, imm7_odd_inst2;          // logic from TB
logic [0:9]  imm10_odd_inst1, imm10_odd_inst2 ;         // logic from TB
logic [0:15] imm16_odd_inst1, imm16_odd_inst2;        // logic from TB
logic [0:17] imm18_odd_inst1, imm18_odd_inst2;        // logic from TB
logic [0:6]  addr_odd_rt_inst1, addr_odd_rt_inst2;       // logic from TB

logic [0:6]  addr_even_ra_tmp, addr_even_rb_tmp, addr_even_rc_tmp, addr_even_ra_bck, addr_even_rb_bck, addr_even_rc_bck;  
logic [0:6]  addr_odd_ra_tmp, addr_odd_rb_tmp, addr_odd_rc_tmp, addr_odd_ra_bck, addr_odd_rb_bck, addr_odd_rc_bck; 
logic [0:10]  opcode_even_tmp, opcode_even_bck;       // logic from TB

logic signed [0:6]  imm7_even_tmp, imm7_even_bck;   // logic from TB
logic signed [0:9]  imm10_even_tmp, imm10_even_bck;  // logic from TB
logic signed [0:15] imm16_even_tmp, imm16_even_bck; // logic from TB
logic signed [0:17]  imm18_even_tmp, imm18_even_bck; // logic from TB
logic [0:6]  addr_even_rt_tmp, addr_even_rt_bck;       // logic from TB

logic [0:10] opcode_odd_tmp, opcode_odd_bck;       // logic from TB
logic [0:6]  imm7_odd_tmp, imm7_odd_bck;          // logic from TB
logic [0:9]  imm10_odd_tmp, imm10_odd_bck ;         // logic from TB
logic [0:15] imm16_odd_tmp, imm16_odd_bck;        // logic from TB
logic [0:17] imm18_odd_tmp, imm18_odd_bck;        // logic from TB
logic [0:6]  addr_odd_rt_tmp, addr_odd_rt_bck;       // logic from TB


logic decode_stall_Remove, Even_inst_nop, Odd_inst_nop;




always_comb begin
                  // ---------------------------------------------------------------------01
                  // Decode Inst_out[0:31] - Instruction 1 - Even Pipe
                    if((Inst_out[0:3] == 4'b1110)
                    || (Inst_out[0:3] == 4'b1111)
                    || (Inst_out[0:3] == 4'b1100)) begin Even_inst1 = 1; Even_inst_nop = 0;
                    opcode_even_inst1   = Inst_out[0:3];
                    addr_even_ra_inst1  = Inst_out[18:24];
                    addr_even_rb_inst1  = Inst_out[11:17];
                    addr_even_rc_inst1  = Inst_out[25:31];
                    imm7_even_inst1    = 0;
                    imm10_even_inst1   = 0;
                    imm16_even_inst1   = 0;
                    imm18_even_inst1   = 0;
                    addr_even_rt_inst1 = Inst_out[4:10];
                    end

                    else if((Inst_out[0:6] == 7'b0100_001)) begin Even_inst1 = 1; Even_inst_nop = 0;
                    opcode_even_inst1   = Inst_out[0:6];
                    addr_even_ra_inst1  = 0;
                    addr_even_rb_inst1  = 0;
                    addr_even_rc_inst1  = 0;
                    imm7_even_inst1    = 0;
                    imm10_even_inst1   = 0;
                    imm16_even_inst1   = 0;
                    imm18_even_inst1   = Inst_out[7:24];
                    addr_even_rt_inst1 = Inst_out[25:31];
                    end

                    else if((Inst_out[0:7] == 8'b0001_1100)
                    || (Inst_out[0:7] == 8'b0001_0110)
                    || (Inst_out[0:7] == 8'b0111_1110)
                    || (Inst_out[0:7] == 8'b0111_1100)
                    || (Inst_out[0:7] == 8'b0100_1110)
                    || (Inst_out[0:7] == 8'b0100_1100)
                    || (Inst_out[0:7] == 8'b0101_1110)
                    || (Inst_out[0:7] == 8'b0000_0100)
                    || (Inst_out[0:7] == 8'b0000_1100)
                    || (Inst_out[0:7] == 8'b0100_0110)
                    || (Inst_out[0:7] == 8'b0100_0100)
                    || (Inst_out[0:7] == 8'b0111_0100)
                    || (Inst_out[0:7] == 8'b0111_0101)) begin Even_inst1 = 1; Even_inst_nop = 0;
                    opcode_even_inst1   = Inst_out[0:7];
                    addr_even_ra_inst1  = Inst_out[18:24];
                    addr_even_rb_inst1  = 0;
                    addr_even_rc_inst1  = 0;
                    imm7_even_inst1    = 0;
                    imm10_even_inst1   = Inst_out[8:17];
                    imm16_even_inst1   = 0;
                    imm18_even_inst1   = 0;
                    addr_even_rt_inst1 = Inst_out[25:31];
                    end

                    else if((Inst_out[0:8] == 9'b0100_0000_1)
                    || (Inst_out[0:8] == 9'b0100_0001_1)) begin Even_inst1 = 1; Even_inst_nop = 0;
                    opcode_even_inst1   = Inst_out[0:8];
                    addr_even_ra_inst1  = 0;
                    addr_even_rb_inst1  = 0;
                    addr_even_rc_inst1  = 0;
                    imm7_even_inst1    = 0;
                    imm10_even_inst1   = 0;
                    imm16_even_inst1   = Inst_out[9:24];
                    imm18_even_inst1   = 0;
                    addr_even_rt_inst1 = Inst_out[25:31];
                    end

                    else if((Inst_out[0:10] == 11'b0001_1000_000)
                    || (Inst_out[0:10] == 11'b1101_0000_000)
                    || (Inst_out[0:10] == 11'b0001_1000_001)
                    || (Inst_out[0:10] == 11'b0101_1000_001)
                    || (Inst_out[0:10] == 11'b0111_1000_000)
                    || (Inst_out[0:10] == 11'b0111_1010_000)
                    || (Inst_out[0:10] == 11'b0100_1010_000)
                    || (Inst_out[0:10] == 11'b0101_1010_000)
                    || (Inst_out[0:10] == 11'b0001_1001_001)
                    || (Inst_out[0:10] == 11'b0000_1001_001)
                    || (Inst_out[0:10] == 11'b0000_1000_001)
                    || (Inst_out[0:10] == 11'b0101_1001_001)
                    || (Inst_out[0:10] == 11'b0000_1000_000)
                    || (Inst_out[0:10] == 11'b0110_1000_001)
                    || (Inst_out[0:10] == 11'b0100_1000_001)
                    || (Inst_out[0:10] == 11'b0000_1010_011)
                    || (Inst_out[0:10] == 11'b0001_1010_011)
                    || (Inst_out[0:10] == 11'b0000_1011_000)
                    || (Inst_out[0:10] == 11'b0000_1011_001)
                    || (Inst_out[0:10] == 11'b0000_1011_011)
                    || (Inst_out[0:10] == 11'b0101_1000_100)
                    || (Inst_out[0:10] == 11'b0101_1000_110)
                    || (Inst_out[0:10] == 11'b0101_1000_101)
                    || (Inst_out[0:10] == 11'b0100_1010_011)
                    || (Inst_out[0:10] == 11'b0111_1000_100)
                    || (Inst_out[0:10] == 11'b0111_1000_111)
                    || (Inst_out[0:10] == 11'b0111_1001_100)) begin Even_inst1 = 1; Even_inst_nop = 0;
                    opcode_even_inst1   = Inst_out[0:10];
                    addr_even_ra_inst1  = Inst_out[18:24];
                    addr_even_rb_inst1  = Inst_out[11:17];
                    addr_even_rc_inst1  = 0;
                    imm7_even_inst1    = 0;
                    imm10_even_inst1   = 0;
                    imm16_even_inst1   = 0;
                    imm18_even_inst1   = 0;
                    addr_even_rt_inst1 = Inst_out[25:31];
                    end

                    else if((Inst_out[0:10] == 11'b0101_0110_100)
                    || (Inst_out[0:10] == 11'b0101_0110_110)
                    || (Inst_out[0:10] == 11'b0101_0101_110)
                    || (Inst_out[0:10] == 11'b0101_0100_110)) begin Even_inst1 = 1;Even_inst_nop = 0;
                    opcode_even_inst1   = Inst_out[0:10];
                    addr_even_ra_inst1  = Inst_out[18:24];
                    addr_even_rb_inst1  = 0;
                    addr_even_rc_inst1  = 0;
                    imm7_even_inst1    = 0;
                    imm10_even_inst1   = 0;
                    imm16_even_inst1   = 0;
                    imm18_even_inst1   = 0;
                    addr_even_rt_inst1 = Inst_out[25:31];
                    end

                    else if((Inst_out[0:10] == 11'b0000_1111_011)) begin Even_inst1 = 1; Even_inst_nop = 0;
                    opcode_even_inst1   = Inst_out[0:10];
                    addr_even_ra_inst1  = Inst_out[18:24];
                    addr_even_rb_inst1  = 0;
                    addr_even_rc_inst1  = 0;
                    imm7_even_inst1    = Inst_out[11:17];
                    imm10_even_inst1   = 0;
                    imm16_even_inst1   = 0;
                    imm18_even_inst1   = 0;
                    addr_even_rt_inst1 = Inst_out[25:31];
                    end

                    else if((Inst_out[0:10] == 11'b0100_0000_001)) begin Even_inst1 = 1;
                    //else begin 
                    //Even_inst_nop = 1;
                    opcode_even_inst1   = 11'b0100_0000_001;
                    addr_even_ra_inst1  = 7'b0;
                    addr_even_rb_inst1  = 7'b0;
                    addr_even_rc_inst1  = 7'b0;
                    imm7_even_inst1    = 7'b0;
                    imm10_even_inst1   = 10'b0;
                    imm16_even_inst1   = 16'b0;
                    imm18_even_inst1   = 18'b0;
                    addr_even_rt_inst1 = 7'b0;
                    end

                    // else begin
                    // //$display ("===========================================>>>> Else Reached No-Op Passed - 371");
                    // Even_inst1 = 0;
                    // opcode_even_inst1   = 11'b0100_0000_001;
                    // addr_even_ra_inst1  = 0;
                    // addr_even_rb_inst1  = 0;
                    // addr_even_rc_inst1  = 0;
                    // imm7_even_inst1    = 0;
                    // imm10_even_inst1   = 0;
                    // imm16_even_inst1   = 0;
                    // imm18_even_inst1   = 0;
                    // addr_even_rt_inst1 = 0;
                    // end

                  // ---------------------------------------------------------------------03
                  // Decode Inst_out[0:31] - Instruction 1 - Odd Pipe

                  if((Inst_out[0:8] == 9'b0010_0001_0)
                  || (Inst_out[0:8] == 9'b0010_0000_0)
                  || (Inst_out[0:8] == 9'b0011_0001_0)
                  || (Inst_out[0:8] == 9'b0011_0011_0)
                  || (Inst_out[0:8] == 9'b0011_0000_1)
                  || (Inst_out[0:8] == 9'b0010_0000_1))begin Even_inst1 = 0; Odd_inst_nop = 0;
                  opcode_odd_inst1  =Inst_out[0:8];
                  addr_odd_ra_inst1 =0;
                  addr_odd_rb_inst1 =0;
                  addr_odd_rc_inst1 =0;
                  addr_odd_rt_inst1=Inst_out[25:31];
                  imm7_odd_inst1    =0;
                  imm10_odd_inst1   =0;
                  imm16_odd_inst1   =Inst_out[9:24];
                  imm18_odd_inst1   =0;
                  end

                  else if ((Inst_out[0:8] == 9'b0011_0010_0)
                  || (Inst_out[0:8] == 9'b0011_0000_0))begin Even_inst1 = 0; Odd_inst_nop = 0;
                  opcode_odd_inst1  =Inst_out[0:8];
                  addr_odd_ra_inst1 =0;
                  addr_odd_rb_inst1 =0;
                  addr_odd_rc_inst1 =0;
                  addr_odd_rt_inst1=0;
                  imm7_odd_inst1    =0;
                  imm10_odd_inst1   =0;
                  imm16_odd_inst1   =Inst_out[9:24];
                  imm18_odd_inst1   =0;
                  end

                  else if ((Inst_out[0:10] == 11'b0011_0101_000)
                  || (Inst_out[0:10] == 11'b0011_0101_001)) begin Even_inst1 = 0; Odd_inst_nop = 0;
                  opcode_odd_inst1  =Inst_out[0:10];
                  addr_odd_ra_inst1 =Inst_out[18:24];
                  addr_odd_rb_inst1 =0;
                  addr_odd_rc_inst1 =0;
                  addr_odd_rt_inst1=0;
                  imm7_odd_inst1    =0;
                  imm10_odd_inst1   =0;
                  imm16_odd_inst1   =0;
                  imm18_odd_inst1   =0;
                  end
                    
                  else if ((Inst_out[0:10] == 11'b0011_1111_100)
                  || (Inst_out[0:10] == 11'b0011_1111_101)
                  || (Inst_out[0:10] == 11'b0011_1111_111)) begin Even_inst1 = 0; Odd_inst_nop = 0;
                  opcode_odd_inst1  =Inst_out[0:10];
                  addr_odd_ra_inst1 =Inst_out[18:24];
                  addr_odd_rb_inst1 =0;
                  addr_odd_rc_inst1 =0;
                  addr_odd_rt_inst1=Inst_out[25:31];
                  imm7_odd_inst1    =Inst_out[11:17];
                  imm10_odd_inst1   =0;
                  imm16_odd_inst1   =0;
                  imm18_odd_inst1   =0;
                  end
                    
                  else if ((Inst_out[0:10] == 11'b0011_1011_100)
                  || (Inst_out[0:10] == 11'b0011_1011_101)
                  || (Inst_out[0:10] == 11'b0011_1011_111)
                  || (Inst_out[0:10] == 11'b0011_1000_100)
                  || (Inst_out[0:10] == 11'b0010_1000_100))begin Even_inst1 = 0; Odd_inst_nop = 0;
                  opcode_odd_inst1  =Inst_out[0:10];
                  addr_odd_ra_inst1 =Inst_out[18:24];
                  addr_odd_rb_inst1 =Inst_out[11:17];
                  addr_odd_rc_inst1 =0;
                  addr_odd_rt_inst1=Inst_out[25:31];
                  imm7_odd_inst1    =0;
                  imm10_odd_inst1   =0;
                  imm16_odd_inst1   =0;
                  imm18_odd_inst1   =0;
                  end
                    
                  else if ((Inst_out[0:10] == 11'b0100_0000_010))begin Even_inst1 = 0;
                  //Odd_inst_nop = 1;
                  opcode_odd_inst1  =Inst_out[0:10];
                  addr_odd_ra_inst1 =7'b0;
                  addr_odd_rb_inst1 =7'b0;;
                  addr_odd_rc_inst1 =7'b0;;
                  addr_odd_rt_inst1=7'b0;;
                  imm7_odd_inst1    =7'b0;;
                  imm10_odd_inst1   =10'b0;;
                  imm16_odd_inst1   =16'b0;;
                  imm18_odd_inst1   =18'b0;;
                  end

                // --------------------------------------000-------------------------------02
                // Decode Inst_out[0:31] - Instruction 1 - Even Pipe
                  if((Inst_out[32:35] == 4'b1110)
                  || (Inst_out[32:35] == 4'b1111)
                  || (Inst_out[32:35] == 4'b1100)) begin Even_inst2 = 1; Even_inst_nop = 0;
                  opcode_even_inst2  = Inst_out[32:35];
                  addr_even_ra_inst2  = Inst_out[50:56];
                  addr_even_rb_inst2  = Inst_out[43:49];
                  addr_even_rc_inst2  = Inst_out[57:63];
                  imm7_even_inst2     = 0;
                  imm10_even_inst2    = 0;
                  imm16_even_inst2    = 0;
                  imm18_even_inst2    = 0;
                  addr_even_rt_inst2  = Inst_out[36:42];
                  end

                  else if((Inst_out[32:38] == 7'b0100_001)) begin Even_inst2 = 1; Even_inst_nop = 0;
                  opcode_even_inst2  = Inst_out[32:38];
                  addr_even_ra_inst2  = 0;
                  addr_even_rb_inst2  = 0;
                  addr_even_rc_inst2  = 0;
                  imm7_even_inst2     = 0;
                  imm10_even_inst2    = 0;
                  imm16_even_inst2    = 0;
                  imm18_even_inst2    = Inst_out[39:56];
                  addr_even_rt_inst2  = Inst_out[57:63];
                  end

                  else if((Inst_out[32:39] == 8'b0001_1100)
                  || (Inst_out[32:39] == 8'b0001_0110)
                  || (Inst_out[32:39] == 8'b0111_1110)
                  || (Inst_out[32:39] == 8'b0111_1100)
                  || (Inst_out[32:39] == 8'b0100_1110)
                  || (Inst_out[32:39] == 8'b0100_1100)
                  || (Inst_out[32:39] == 8'b0101_1110)
                  || (Inst_out[32:39] == 8'b0000_0100)
                  || (Inst_out[32:39] == 8'b0000_1100)
                  || (Inst_out[32:39] == 8'b0100_0110)
                  || (Inst_out[32:39] == 8'b0100_0100)
                  || (Inst_out[32:39] == 8'b0111_0100)
                  || (Inst_out[32:39] == 8'b0111_0101)) begin Even_inst2 = 1; Even_inst_nop = 0;
                  opcode_even_inst2  = Inst_out[32:39];
                  addr_even_ra_inst2  = Inst_out[50:56];
                  addr_even_rb_inst2  = 0;
                  addr_even_rc_inst2  = 0;
                  imm7_even_inst2     = 0;
                  imm10_even_inst2    = Inst_out[40:49];
                  imm16_even_inst2    = 0;
                  imm18_even_inst2    = 0;
                  addr_even_rt_inst2  = Inst_out[57:63];
                  end

                  else if((Inst_out[32:40] == 9'b0100_0000_1)
                  || (Inst_out[32:40] == 9'b0100_0001_1)) begin Even_inst2 = 1; Even_inst_nop = 0;
                  opcode_even_inst2  = Inst_out[32:40];
                  addr_even_ra_inst2  = 0;
                  addr_even_rb_inst2  = 0;
                  addr_even_rc_inst2  = 0;
                  imm7_even_inst2     = 0;
                  imm10_even_inst2    = 0;
                  imm16_even_inst2    = Inst_out[41:56];
                  imm18_even_inst2    = 0;
                  addr_even_rt_inst2  = Inst_out[57:63];
                  end

                  else if((Inst_out[32:42] == 11'b0001_1000_000)
                  || (Inst_out[32:42] == 11'b1101_0000_000)
                  || (Inst_out[32:42] == 11'b0001_1000_001)
                  || (Inst_out[32:42] == 11'b0101_1000_001)
                  || (Inst_out[32:42] == 11'b0111_1000_000)
                  || (Inst_out[32:42] == 11'b0111_1010_000)
                  || (Inst_out[32:42] == 11'b0100_1010_000)
                  || (Inst_out[32:42] == 11'b0101_1010_000)
                  || (Inst_out[32:42] == 11'b0001_1001_001)
                  || (Inst_out[32:42] == 11'b0000_1001_001)
                  || (Inst_out[32:42] == 11'b0000_1000_001)
                  || (Inst_out[32:42] == 11'b0101_1001_001)
                  || (Inst_out[32:42] == 11'b0000_1000_000)
                  || (Inst_out[32:42] == 11'b0110_1000_001)
                  || (Inst_out[32:42] == 11'b0100_1000_001)
                  || (Inst_out[32:42] == 11'b0000_1010_011)
                  || (Inst_out[32:42] == 11'b0001_1010_011)
                  || (Inst_out[32:42] == 11'b0000_1011_000)
                  || (Inst_out[32:42] == 11'b0000_1011_001)
                  || (Inst_out[32:42] == 11'b0000_1011_011)
                  || (Inst_out[32:42] == 11'b0101_1000_100)
                  || (Inst_out[32:42] == 11'b0101_1000_110)
                  || (Inst_out[32:42] == 11'b0101_1000_101)
                  || (Inst_out[32:42] == 11'b0100_1010_011)
                  || (Inst_out[32:42] == 11'b0111_1000_100)
                  || (Inst_out[32:42] == 11'b0111_1000_111)
                  || (Inst_out[32:42] == 11'b0111_1001_100)) begin Even_inst2 = 1; Even_inst_nop = 0;
                  opcode_even_inst2  = Inst_out[32:42];
                  addr_even_ra_inst2  = Inst_out[50:56];
                  addr_even_rb_inst2  = Inst_out[43:49];
                  addr_even_rc_inst2  = 0;
                  imm7_even_inst2     = 0;
                  imm10_even_inst2    = 0;
                  imm16_even_inst2    = 0;
                  imm18_even_inst2    = 0;
                  addr_even_rt_inst2  = Inst_out[57:63];
                  end

                  else if((Inst_out[32:42] == 11'b0101_0110_100)
                  || (Inst_out[32:42] == 11'b0101_0110_110)
                  || (Inst_out[32:42] == 11'b0101_0101_110)
                  || (Inst_out[32:42] == 11'b0101_0100_110)) begin Even_inst2 = 1; Even_inst_nop = 0;
                  opcode_even_inst2  = Inst_out[32:42];
                  addr_even_ra_inst2  = Inst_out[50:56];
                  addr_even_rb_inst2  = 0;
                  addr_even_rc_inst2  = 0;
                  imm7_even_inst2     = 0;
                  imm10_even_inst2    = 0;
                  imm16_even_inst2    = 0;
                  imm18_even_inst2    = 0;
                  addr_even_rt_inst2  = Inst_out[57:63];
                  end

                  else if((Inst_out[32:42] == 11'b0000_1111_011)) begin Even_inst2 = 1; Even_inst_nop = 0;
                  opcode_even_inst2  = Inst_out[32:42];
                  addr_even_ra_inst2  = Inst_out[50:56];
                  addr_even_rb_inst2  = 0;
                  addr_even_rc_inst2  = 0;
                  imm7_even_inst2     = Inst_out[43:49];
                  imm10_even_inst2    = 0;
                  imm16_even_inst2    = 0;
                  imm18_even_inst2    = 0;
                  addr_even_rt_inst2  = Inst_out[57:63];
                  end

                  else if((Inst_out[32:42] == 11'b0100_0000_001)) begin 
                    Even_inst2 = 1;
                  //else begin 
                    //Even_inst_nop = 1;
                  opcode_even_inst2  = 11'b0100_0000_001;
                  addr_even_ra_inst2  = 7'b0;
                  addr_even_rb_inst2  = 7'b0;
                  addr_even_rc_inst2  = 7'b0;
                  imm7_even_inst2     = 7'b0;
                  imm10_even_inst2    = 10'bx;
                  imm16_even_inst2    = 16'bx;
                  imm18_even_inst2    = 18'bx;
                  addr_even_rt_inst2  = 7'b0;
                  end

                  // else begin
                  // $display ("===========================================>>>> Else Reached No-Op Passed - 528");
                  // Even_inst2 = 0;
                  // opcode_even_inst2  = 11'b0100_0000_001;
                  // addr_even_ra_inst2  = 0;
                  // addr_even_rb_inst2  = 0;
                  // addr_even_rc_inst2  = 0;
                  // imm7_even_inst2     = 0;
                  // imm10_even_inst2    = 0;
                  // imm16_even_inst2    = 0;
                  // imm18_even_inst2    = 0;
                  // addr_even_rt_inst2  = 0;
                  // end

                // ---------------------------------------------------------------------04
                // Decode Inst_out[0:31] - Instruction 1 - Odd Pipe

                if((Inst_out[32:40] == 9'b0010_0001_0)
                || (Inst_out[32:40] == 9'b0010_0000_0)
                || (Inst_out[32:40] == 9'b0011_0001_0)
                || (Inst_out[32:40] == 9'b0011_0011_0)
                || (Inst_out[32:40] == 9'b0011_0000_1)
                || (Inst_out[32:40] == 9'b0010_0000_1))begin Even_inst2 = 0; Odd_inst_nop = 0;
                opcode_odd_inst2  =Inst_out[32:40];
                addr_odd_ra_inst2 =0;
                addr_odd_rb_inst2 =0;
                addr_odd_rc_inst2 =0;
                addr_odd_rt_inst2 =Inst_out[57:63];
                imm7_odd_inst2    =0;
                imm10_odd_inst2   =0;
                imm16_odd_inst2   =Inst_out[41:56];
                imm18_odd_inst2   =0;
                end

                else if ((Inst_out[32:40] == 9'b0011_0010_0)
                || (Inst_out[32:40] == 9'b0011_0000_0))begin Even_inst2 = 0; Odd_inst_nop = 0;
                opcode_odd_inst2  =Inst_out[32:40];
                addr_odd_ra_inst2 =0;
                addr_odd_rb_inst2 =0;
                addr_odd_rc_inst2 =0;
                addr_odd_rt_inst2 =0;
                imm7_odd_inst2    =0;
                imm10_odd_inst2   =0;
                imm16_odd_inst2   =Inst_out[41:56];
                imm18_odd_inst2   =0;
                end

                else if ((Inst_out[32:42] == 11'b0011_0101_000)
                || (Inst_out[32:42] == 11'b0011_0101_001)) begin Even_inst2 = 0; Odd_inst_nop = 0;
                opcode_odd_inst2  =Inst_out[32:42];
                addr_odd_ra_inst2 =Inst_out[50:56];
                addr_odd_rb_inst2 =0;
                addr_odd_rc_inst2 =0;
                addr_odd_rt_inst2 =0;
                imm7_odd_inst2    =0;
                imm10_odd_inst2   =0;
                imm16_odd_inst2   =0;
                imm18_odd_inst2   =0;
                end
                  
                else if ((Inst_out[32:42] == 11'b0011_1111_100)
                || (Inst_out[32:42] == 11'b0011_1111_101)
                || (Inst_out[32:42] == 11'b0011_1111_111))begin Even_inst2 = 0; Odd_inst_nop = 0;
                opcode_odd_inst2  =Inst_out[32:42];
                addr_odd_ra_inst2 =Inst_out[50:56];
                addr_odd_rb_inst2 =0;
                addr_odd_rc_inst2 =0;
                addr_odd_rt_inst2 =Inst_out[57:63];
                imm7_odd_inst2    =Inst_out[43:49];
                imm10_odd_inst2   =0;
                imm16_odd_inst2   =0;
                imm18_odd_inst2   =0;
                end
                  
                else if ((Inst_out[32:42] == 11'b0011_1011_100)
                || (Inst_out[32:42] == 11'b0011_1011_101)
                || (Inst_out[32:42] == 11'b0011_1011_111)
                || (Inst_out[32:42] == 11'b0011_1000_100)
                || (Inst_out[32:42] == 11'b0010_1000_100))begin Even_inst2 = 0; Odd_inst_nop = 0;
                opcode_odd_inst2  =Inst_out[32:42];
                addr_odd_ra_inst2 =Inst_out[50:56];
                addr_odd_rb_inst2 =Inst_out[43:49];
                addr_odd_rc_inst2 =0;
                addr_odd_rt_inst2 =Inst_out[57:63];
                imm7_odd_inst2    =0;
                imm10_odd_inst2   =0;
                imm16_odd_inst2   =0;
                imm18_odd_inst2   =0;
                end
                  
                                                      else if ((Inst_out[32:42] == 11'b0100_0000_010)) begin Even_inst2 = 0;
                                                      //else begin 
                                                        //Odd_inst_nop = 1;
                                                      opcode_odd_inst2  =Inst_out[32:42];
                                                      addr_odd_ra_inst2 =7'b0;
                                                      addr_odd_rb_inst2 =7'b0;
                                                      addr_odd_rc_inst2 =7'b0;
                                                      addr_odd_rt_inst2 =7'b0;
                                                      imm7_odd_inst2    =7'b0;
                                                      imm10_odd_inst2   =10'bx;
                                                      imm16_odd_inst2   =16'bx;
                                                      imm18_odd_inst2   =18'bx;
                                                      end

                end 
//-------------------------------------------------------------------------------------------------------------------------------------------
always_comb begin
  if((Even_inst1 == 1)&&(Even_inst2 == 1) &&
      (Inst_out[32:42] != 11'b0100_0000_010) && (Inst_out[0:10] != 11'b0100_0000_010) &&
      (Inst_out[32:42] != 11'b0100_0000_001) && (Inst_out[0:10] != 11'b0100_0000_001))
    begin
      Even_Structural_Hazard = 1; No_Structural_Hazard = 0; Odd_Structural_Hazard = 0;

      //if(decode_stall_Remove) decode_stall_1 = 0;
      //$display("Inside Structural Hazard - Even Case");
    end

  else if((Even_inst1 == 0)&&(Even_inst2 == 0) && 
          (Inst_out[32:42] != 11'b0100_0000_010) && (Inst_out[0:10] != 11'b0100_0000_010) &&
          (Inst_out[32:42] != 11'b0100_0000_001) && (Inst_out[0:10] != 11'b0100_0000_001) )
  begin
    Odd_Structural_Hazard = 1; No_Structural_Hazard = 0; Even_Structural_Hazard = 0;
    // decode_stall_1 = 1;
    // if(decode_stall_Remove) decode_stall_1 = 0;
  end

  else begin No_Structural_Hazard = 1; Even_Structural_Hazard = 0; Odd_Structural_Hazard = 0; end
end

    always_comb begin
    if(Even_Structural_Hazard == 1) begin
    opcode_even_tmp   = opcode_even_inst1;
    addr_even_ra_tmp  = addr_even_ra_inst1;
    addr_even_rb_tmp  = addr_even_rb_inst1;
    addr_even_rc_tmp  = addr_even_rc_inst1;
    imm7_even_tmp     = imm7_even_inst1;
    imm10_even_tmp    = imm10_even_inst1;
    imm16_even_tmp    = imm16_even_inst1;
    imm18_even_tmp    = imm18_even_inst1;
    addr_even_rt_tmp  = addr_even_rt_inst1;
    //--------------
    opcode_odd_tmp  = 11'b0100_0000_001;
    addr_odd_ra_tmp =7'b0;
    addr_odd_rb_tmp =7'b0;
    addr_odd_rc_tmp =7'b0;
    addr_odd_rt_tmp =7'b0;
    imm7_odd_tmp    =7'b0;
    imm10_odd_tmp   =10'b0;
    imm16_odd_tmp   =16'b0;
    imm18_odd_tmp   =18'b0;
    end 

    if(Prev_Even_Hazard == 1) begin
    opcode_even_tmp   = opcode_even_inst2;
    addr_even_ra_tmp  = addr_even_ra_inst2;
    addr_even_rb_tmp  = addr_even_rb_inst2;
    addr_even_rc_tmp  = addr_even_rc_inst2;
    imm7_even_tmp     = imm7_even_inst2;
    imm10_even_tmp    = imm10_even_inst2;
    imm16_even_tmp    = imm16_even_inst2;
    imm18_even_tmp    = imm18_even_inst2;
    addr_even_rt_tmp  = addr_even_rt_inst2;
    //--------------
    opcode_odd_tmp  = 11'b0100_0000_001;
    addr_odd_ra_tmp =7'b0;
    addr_odd_rb_tmp =7'b0;
    addr_odd_rc_tmp =7'b0;
    addr_odd_rt_tmp =7'b0;
    imm7_odd_tmp    =7'b0;
    imm10_odd_tmp   =10'b0;
    imm16_odd_tmp   =16'b0;
    imm18_odd_tmp   =18'b0;

    end

    if(Odd_Structural_Hazard == 1) begin
    opcode_odd_tmp   = opcode_odd_inst1;
    addr_odd_ra_tmp  = addr_odd_ra_inst1;
    addr_odd_rb_tmp  = addr_odd_rb_inst1;
    addr_odd_rc_tmp  = addr_odd_rc_inst1;
    imm7_odd_tmp     = imm7_odd_inst1;
    imm10_odd_tmp    = imm10_odd_inst1;
    imm16_odd_tmp    = imm16_odd_inst1;
    imm18_odd_tmp    = imm18_odd_inst1;
    addr_odd_rt_tmp  = addr_odd_rt_inst1;
    //--------------
    opcode_even_tmp  = 11'b0100_0000_001;
    addr_even_ra_tmp =7'b0;
    addr_even_rb_tmp =7'b0;
    addr_even_rc_tmp =7'b0;
    addr_even_rt_tmp =7'b0;
    imm7_even_tmp    =7'b0;
    imm10_even_tmp   =10'b0;
    imm16_even_tmp   =16'b0;
    imm18_even_tmp   =18'b0;
    end

    if(Prev_Odd_Hazard == 1) begin

    opcode_odd_tmp   = opcode_odd_inst2;
    addr_odd_ra_tmp  = addr_odd_ra_inst2;
    addr_odd_rb_tmp  = addr_odd_rb_inst2;
    addr_odd_rc_tmp  = addr_odd_rc_inst2;
    imm7_odd_tmp     = imm7_odd_inst2;
    imm10_odd_tmp    = imm10_odd_inst2;
    imm16_odd_tmp    = imm16_odd_inst2;
    imm18_odd_tmp    = imm18_odd_inst2;
    addr_odd_rt_tmp  = addr_odd_rt_inst2;
    //--------------
    opcode_even_tmp  = 11'b0100_0000_001;
    addr_even_ra_tmp =7'b0;
    addr_even_rb_tmp =7'b0;
    addr_even_rc_tmp =7'b0;
    addr_even_rt_tmp =7'b0;
    imm7_even_tmp    =7'b0;
    imm10_even_tmp   =10'b0;
    imm16_even_tmp   =16'b0;
    imm18_even_tmp   =18'b0;

    end

    if(No_Structural_Hazard) begin
    if((Even_inst1 == 1)&&(Even_inst2 == 0))begin
    opcode_even_tmp   = opcode_even_inst1;
    addr_even_ra_tmp  = addr_even_ra_inst1;
    addr_even_rb_tmp  = addr_even_rb_inst1;
    addr_even_rc_tmp  = addr_even_rc_inst1;
    imm7_even_tmp     = imm7_even_inst1;
    imm10_even_tmp    = imm10_even_inst1;
    imm16_even_tmp    = imm16_even_inst1;
    imm18_even_tmp    = imm18_even_inst1;
    addr_even_rt_tmp  = addr_even_rt_inst1;      
    //--------------
    opcode_odd_tmp   = opcode_odd_inst2;
    addr_odd_ra_tmp  = addr_odd_ra_inst2;
    addr_odd_rb_tmp  = addr_odd_rb_inst2;
    addr_odd_rc_tmp  = addr_odd_rc_inst2;
    imm7_odd_tmp     = imm7_odd_inst2;
    imm10_odd_tmp    = imm10_odd_inst2;
    imm16_odd_tmp    = imm16_odd_inst2;
    imm18_odd_tmp    = imm18_odd_inst2;
    addr_odd_rt_tmp  = addr_odd_rt_inst2;
    end

    else if((Even_inst1 == 0)&&(Even_inst2 == 1))begin
    opcode_even_tmp   = opcode_even_inst2;
    addr_even_ra_tmp  = addr_even_ra_inst2;
    addr_even_rb_tmp  = addr_even_rb_inst2;
    addr_even_rc_tmp  = addr_even_rc_inst2;
    imm7_even_tmp     = imm7_even_inst2;
    imm10_even_tmp    = imm10_even_inst2;
    imm16_even_tmp    = imm16_even_inst2;
    imm18_even_tmp    = imm18_even_inst2;
    addr_even_rt_tmp  = addr_even_rt_inst2;      
    //--------------
    opcode_odd_tmp   = opcode_odd_inst1;
    addr_odd_ra_tmp  = addr_odd_ra_inst1;
    addr_odd_rb_tmp  = addr_odd_rb_inst1;
    addr_odd_rc_tmp  = addr_odd_rc_inst1;
    imm7_odd_tmp     = imm7_odd_inst1;
    imm10_odd_tmp    = imm10_odd_inst1;
    imm16_odd_tmp    = imm16_odd_inst1;
    imm18_odd_tmp    = imm18_odd_inst1;
    addr_odd_rt_tmp  = addr_odd_rt_inst1;
    end
    end end

always_ff @(posedge clk) begin
  if (reset==0) //$display ($time-10, " Dual Instruction: %b_%b| @ Decode Stage - Fetched" , Inst_out[0:31], Inst_out[32:63]);

if(Even_Structural_Hazard == 1) begin
    decode_stall_1 = 1; //$display($time, " Even_Structural_Hazard Resolution in Progress");
    Prev_Even_Hazard <= 1; end

if(Prev_Even_Hazard == 1) begin
    decode_stall_1 = 0;
    Prev_Even_Hazard <= 0; end

if(Odd_Structural_Hazard == 1) begin
    Prev_Odd_Hazard <= 1; //$display($time, " Odd_Structural_Hazard Resolution in Progress");
    decode_stall_1 = 1; end

if(Prev_Odd_Hazard == 1) begin
    Prev_Odd_Hazard <= 0;
    decode_stall_1 = 0; end

if(No_Structural_Hazard) begin //$display($time, " No_Structural_Hazard");
    if((Even_inst1 == 1)&&(Even_inst2 == 0))begin
        decode_stall_1 = 0;end

    else if((Even_inst1 == 0)&&(Even_inst2 == 1))begin
        decode_stall_1 = 0; end end
end 


// -----------------------------------------------
always_ff @(posedge clk) begin

if(Dependency_Stall) begin
            // $display("=====++++++++++++++++++++++++++++++++++++++++++++++++++++++Dependency Stall is High");

             opcode_even_bck   <= opcode_even_tmp;
            addr_even_ra_bck  <= addr_even_ra_tmp;
            addr_even_rb_bck  <= addr_even_rb_tmp;
            addr_even_rc_bck  <= addr_even_rc_tmp;
            imm7_even_bck     <= imm7_even_tmp;
            imm10_even_bck    <= imm10_even_tmp;
            imm16_even_bck    <= imm16_even_tmp;
            imm18_even_bck   <= imm18_even_tmp;
            addr_even_rt_bck  <= addr_even_rt_tmp;      
            //--------------
            opcode_odd_bck   <= opcode_odd_tmp;
            addr_odd_ra_bck  <= addr_odd_ra_tmp;
            addr_odd_rb_bck  <= addr_odd_rb_tmp;
            addr_odd_rc_bck  <= addr_odd_rc_tmp;
            imm7_odd_bck     <= imm7_odd_tmp;
            imm10_odd_bck    <= imm10_odd_tmp;
            imm16_odd_bck    <= imm16_odd_tmp;
            imm18_odd_bck    <= imm18_odd_tmp;
            addr_odd_rt_bck  <= addr_odd_rt_tmp;// end
            Prev_stall =1 ;

    end

    else if(Dependency_Stall==0 && Prev_stall==1)begin


            // decode_stall_1 = 1;
            opcode_even   <= opcode_even_bck;
            addr_even_ra  <= addr_even_ra_bck;
            addr_even_rb  <= addr_even_rb_bck;
            addr_even_rc  <= addr_even_rc_bck;
            imm7_even     <= imm7_even_bck;
            imm10_even    <= imm10_even_bck;
            imm16_even    <= imm16_even_bck;
            imm18_even    <= imm18_even_bck;
            addr_even_rt  <= addr_even_rt_bck;      
            //--------------
            opcode_odd   <= opcode_odd_bck;
            addr_odd_ra  <= addr_odd_ra_bck;
            addr_odd_rb  <= addr_odd_rb_bck;
            addr_odd_rc  <= addr_odd_rc_bck;
            imm7_odd     <= imm7_odd_bck;
            imm10_odd    <= imm10_odd_bck;
            imm16_odd    <= imm16_odd_bck;
            imm18_odd    <= imm18_odd_bck;
            addr_odd_rt  <= addr_odd_rt_bck;
            Prev_stall = 1;
end



else  begin
           // decode_stall_1 = 0;
            opcode_even   <= opcode_even_tmp;
            addr_even_ra  <= addr_even_ra_tmp;
            addr_even_rb  <= addr_even_rb_tmp;
            addr_even_rc  <= addr_even_rc_tmp;
            imm7_even     <= imm7_even_tmp;
            imm10_even    <= imm10_even_tmp;
            imm16_even    <= imm16_even_tmp;
            imm18_even   <= imm18_even_tmp;
            addr_even_rt  <= addr_even_rt_tmp;      
            //--------------
            opcode_odd   <= opcode_odd_tmp;
            addr_odd_ra  <= addr_odd_ra_tmp;
            addr_odd_rb  <= addr_odd_rb_tmp;
            addr_odd_rc  <= addr_odd_rc_tmp;
            imm7_odd     <= imm7_odd_tmp;
            imm10_odd    <= imm10_odd_tmp;
            imm16_odd    <= imm16_odd_tmp;
            imm18_odd    <= imm18_odd_tmp;
            addr_odd_rt  <= addr_odd_rt_tmp; end

           // else if (Prev_stall == 1 && Dependency_Stall==0) begin
            






 // $display ("opcode_even: %b, addr_even_ra: %b, addr_even_rb: %b, addr_even_rc: %b, imm7_even: %b, imm10_even: %b, imm16_even: %b, imm18_even: %b, addr_even_rt: %b", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even, addr_even_rt);
 //     $display ("opcode_odd: %b, addr_odd_ra: %b, addr_odd_rb: %b, addr_odd_rc: %b, addr_odd_rt: %b, imm7_odd: %b, imm10_odd: %b, imm16_odd: %b, imm18_odd: %b", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, addr_odd_rt, imm7_odd, imm10_odd, imm16_odd, imm18_odd);

end 

// always_ff @(posedge clk) begin
//   if(reset==0) begin
//     $display ($time, " == > Opcode_even: %b | @ Decode Stage - Issue" , opcode_even);
//     $display ($time, " == > Opcode_odd: %b | @ Decode Stage - Issue", opcode_odd); end
// end
endmodule // Decode

