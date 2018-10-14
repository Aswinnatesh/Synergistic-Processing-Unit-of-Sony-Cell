

//===================================================Dependency==========================================================

module Dependency (clk, reset,addr_even_ra, addr_even_rb, addr_even_rc, opcode_even, imm10_even, imm16_even, imm18_even, imm7_even, addr_even_rt,
addr_odd_ra, addr_odd_rb, addr_odd_rc, opcode_odd, imm10_odd, imm16_odd, imm18_odd, imm7_odd, addr_odd_rt, flush,opcode_even_depend, imm7_even_depend, imm10_even_depend, imm16_even_depend, imm18_even_depend, addr_even_rt_depend, addr_even_ra_depend, addr_even_rb_depend, addr_even_rc_depend , opcode_odd_depend,imm7_odd_depend,imm10_odd_depend,imm16_odd_depend,imm18_odd_depend,addr_odd_rt_depend,addr_odd_ra_depend, addr_odd_rb_depend, addr_odd_rc_depend, Dependency_stall, Rt_Temp_even, Rt_Temp1_even, Rt_Temp2_even, Rt_Temp3_even, Rt_Temp4_even, Rt_Temp5_even, Rt_Temp6_even, Rt_Temp_odd, Rt_Temp1_odd, Rt_Temp2_odd, Rt_Temp3_odd, Rt_Temp4_odd, Rt_Temp5_odd, Rt_Temp6_odd);

input clk, reset, flush;
input [0:6] addr_even_ra, addr_even_rb, addr_even_rc;  
input [0:6] addr_odd_ra, addr_odd_rb, addr_odd_rc;  
input [0:10] opcode_even;              
input signed [0:6] imm7_even;          
input signed [0:9] imm10_even;         
input signed [0:15] imm16_even;        
input signed [0:17] imm18_even;        
input [0:6] addr_even_rt;              
input [0:142] Rt_Temp_even, Rt_Temp1_even, Rt_Temp2_even, Rt_Temp3_even, Rt_Temp4_even, Rt_Temp5_even, Rt_Temp6_even;


output logic [0:10] opcode_even_depend;         
output logic signed [0:6] imm7_even_depend;           
output logic signed [0:9] imm10_even_depend;          
output logic signed [0:15] imm16_even_depend;        
output logic signed [0:17] imm18_even_depend;         
output logic [0:6] addr_even_rt_depend;         
output logic [0:6] addr_even_ra_depend, addr_even_rb_depend, addr_even_rc_depend; 

input [0:10] opcode_odd;       
input [0:6] imm7_odd;          
input [0:9] imm10_odd;         
input [0:15] imm16_odd;        
input [0:17] imm18_odd;        
input [0:6] addr_odd_rt;                 
input [0:175] Rt_Temp_odd, Rt_Temp1_odd, Rt_Temp2_odd, Rt_Temp3_odd, Rt_Temp4_odd, Rt_Temp5_odd, Rt_Temp6_odd; 


output logic [0:10] opcode_odd_depend;            
output logic signed [0:6] imm7_odd_depend;                
output logic signed [0:9] imm10_odd_depend;              
output logic signed [0:15] imm16_odd_depend;             
output logic signed [0:17] imm18_odd_depend;                 
output logic signed [0:6] addr_odd_rt_depend;   
output logic [0:6] addr_odd_ra_depend, addr_odd_rb_depend, addr_odd_rc_depend; 
logic [0:6] addr_odd_rt_depend2; 
logic signed [0:15] imm16_odd_depend2; 


logic [0:10] opcode_odd_depend_bck;            
logic signed [0:6] imm7_odd_depend_bck;                
logic signed [0:9] imm10_odd_depend_bck;              
logic signed [0:15] imm16_odd_depend_bck;             
logic signed [0:17] imm18_odd_depend_bck;                 
logic signed [0:6] addr_odd_rt_depend_bck;   
logic [0:6] addr_odd_ra_depend_bck, addr_odd_rb_depend_bck, addr_odd_rc_depend_bck; 

logic [0:10] opcode_even_depend_bck;         
logic signed [0:6] imm7_even_depend_bck;           
logic signed [0:9] imm10_even_depend_bck;          
logic signed [0:15] imm16_even_depend_bck;        
logic signed [0:17] imm18_even_depend_bck;         
logic [0:6] addr_even_rt_depend_bck;         
logic [0:6] addr_even_ra_depend_bck, addr_even_rb_depend_bck, addr_even_rc_depend_bck; 

logic [0:10] opcode_odd_depend2, opcode_even_depend2 ;       

output logic Dependency_stall;

logic [0:10] opcode_even_depend_temp, opcode_odd_depend_temp;
logic [0:6] addr_even_rt_depend_temp, addr_odd_rt_depend_temp;
logic [0:2] opcode_even_depend_lat, opcode_odd_depend_lat;
logic [0:2] count, counter;
logic Prev_Stall;


assign Dependency_stall = (counter > 0);

//always_comb begin
//    always_ff @(posedge clk) begin
//     if (Dependency_stall) begin
//     opcode_even_depend = 11'b0100_0000_001; 
//     opcode_odd_depend = 11'b0100_0000_010; end 

//     else begin 
//         opcode_even_depend = opcode_even_depend2;
//         opcode_odd_depend = opcode_odd_depend2;
//         imm16_odd_depend = imm16_odd_depend2;
//         addr_odd_rt_depend = addr_odd_rt_depend2;end
// end

always_ff @(posedge clk) begin
   //$display("Counter:%d, Count:%d ", counter, count);
  
   Prev_Stall <= Dependency_stall;

  if(counter > 0) begin // count == 0 && 
    counter = counter - 1; $display("---------------------------------------|||||||||||||------------------------------>>> Data Hazard");
    //Dependency_stall = 1;
    // opcode_even_depend = 11'b0100_0000_001; 
    // opcode_odd_depend = 11'b0100_0000_010; 
    end

  else if(count == 1) counter <= 1;
  else if (count == 2 ) counter <= 2;
  else if (count == 3 ) counter <= 3;
  else if (count == 4 ) counter <= 4;
  else if (count == 5 ) counter <= 5;
  else if (count == 6 ) counter <= 6;

    else counter <= 0;

    if (Dependency_stall) begin
    opcode_even_depend = 11'b0100_0000_001; 
    opcode_odd_depend = 11'b0100_0000_010; end 
  
  else if (Prev_Stall == 1 && Dependency_stall == 0) begin
    addr_even_ra_depend  <= addr_even_ra_depend_bck;
    addr_even_rb_depend  <= addr_even_rb_depend_bck;
    addr_even_rc_depend  <= addr_even_rc_depend_bck;
    opcode_even_depend  <= opcode_even_depend_bck;
    addr_even_rt_depend  <= addr_even_rt_depend_bck;
    imm7_even_depend     <= imm7_even_depend_bck;
    imm10_even_depend    <= imm10_even_depend_bck;
    imm16_even_depend    <= imm16_even_depend_bck;
    imm18_even_depend    <= imm18_even_depend_bck;

    addr_odd_ra_depend   <= addr_odd_ra_depend_bck;
    addr_odd_rb_depend   <= addr_odd_rb_depend_bck;
    addr_odd_rc_depend   <= addr_odd_rc_depend_bck;
    opcode_odd_depend   <= opcode_odd_depend_bck;
    addr_odd_rt_depend   <= addr_odd_rt_depend_bck;
    imm7_odd_depend      <= imm7_odd_depend_bck;
    imm10_odd_depend     <= imm10_odd_depend_bck;
    imm16_odd_depend     <= imm16_odd_depend_bck;
    imm18_odd_depend     <= imm18_odd_depend_bck;

    end

  else if(count == 0 && counter == 0) begin
    //$display("--------------------------------------------------------------------->>> No Data Hazard, Counter:%d, Count:%d ", counter, count);    
    //Dependency_stall = 0; 
    addr_even_ra_depend<=addr_even_ra;
    addr_even_rb_depend<=addr_even_rb;
    addr_even_rc_depend<=addr_even_rc;
    opcode_even_depend <= opcode_even; addr_even_rt_depend <= addr_even_rt;
    imm7_even_depend <= imm7_even; imm10_even_depend <= imm10_even; 
    imm16_even_depend <= imm16_even; imm18_even_depend <= imm18_even;

    addr_odd_ra_depend<=addr_odd_ra;
    addr_odd_rb_depend<=addr_odd_rb;
    addr_odd_rc_depend<=addr_odd_rc;
    opcode_odd_depend <= opcode_odd; addr_odd_rt_depend <= addr_odd_rt;
    imm7_odd_depend <= imm7_odd; imm10_odd_depend <= imm10_odd; 
    imm16_odd_depend <= imm16_odd; imm18_odd_depend <= imm18_odd; 

// ----------------------------------- For Latency Calculation @ Reg File

    opcode_even_depend_temp  <= opcode_even;
    addr_even_rt_depend_temp <= addr_even_rt;
    opcode_odd_depend_temp   <= opcode_odd;
    addr_odd_rt_depend_temp  <= addr_odd_rt;

  end

   // $display ("opcode_even: %b | @ Dependency Stge" , opcode_even_depend);
   // $display ("opcode_odd: %b | @ Dependency Stage", opcode_odd_depend);
end

always_ff @(posedge clk) begin

if(Dependency_stall) begin
    addr_even_ra_depend_bck<=addr_even_ra;
    addr_even_rb_depend_bck<=addr_even_rb;
    addr_even_rc_depend_bck<=addr_even_rc;
    opcode_even_depend_bck <= opcode_even; 
    addr_even_rt_depend_bck <= addr_even_rt;
    imm7_even_depend_bck <= imm7_even; 
    imm10_even_depend_bck <= imm10_even; 
    imm16_even_depend_bck <= imm16_even; 
    imm18_even_depend_bck <= imm18_even;

    addr_odd_ra_depend_bck<=addr_odd_ra;
    addr_odd_rb_depend_bck<=addr_odd_rb;
    addr_odd_rc_depend_bck<=addr_odd_rc;
    opcode_odd_depend_bck <= opcode_odd; 
    addr_odd_rt_depend_bck <= addr_odd_rt;
    imm7_odd_depend_bck <= imm7_odd; 
    imm10_odd_depend_bck <= imm10_odd; 
    imm16_odd_depend_bck <= imm16_odd; 
    imm18_odd_depend_bck <= imm18_odd; 
end end





always_comb begin 
if (opcode_even_depend_temp == 7'b0100_001||opcode_even_depend_temp == 8'b0001_1100||opcode_even_depend_temp == 8'b0001_0110||opcode_even_depend_temp == 8'b0111_1110||
opcode_even_depend_temp == 8'b0111_1100||opcode_even_depend_temp == 8'b0100_1110||opcode_even_depend_temp == 8'b0100_1100||opcode_even_depend_temp == 8'b0101_1110||
opcode_even_depend_temp == 8'b0000_0100||opcode_even_depend_temp == 8'b0000_1100||opcode_even_depend_temp == 8'b0100_0110||opcode_even_depend_temp == 8'b0100_0100||
opcode_even_depend_temp == 9'b0100_0000_1||opcode_even_depend_temp == 9'b0100_0001_1||opcode_even_depend_temp == 11'b0001_1000_000||opcode_even_depend_temp == 11'b1101_0000_000||
opcode_even_depend_temp == 11'b0001_1000_001||opcode_even_depend_temp == 11'b0101_1000_001||opcode_even_depend_temp == 11'b0111_1000_000||opcode_even_depend_temp == 11'b0111_1010_000||
opcode_even_depend_temp == 11'b0100_1010_000||opcode_even_depend_temp == 11'b0101_1010_000||opcode_even_depend_temp == 11'b0001_1001_001||opcode_even_depend_temp == 11'b0000_1001_001||
opcode_even_depend_temp == 11'b0000_1000_001||opcode_even_depend_temp == 11'b0101_1001_001||opcode_even_depend_temp == 11'b0000_1000_000||opcode_even_depend_temp == 11'b0110_1000_001||
opcode_even_depend_temp == 11'b0100_1000_001||opcode_even_depend_temp == 11'b0101_0110_110||opcode_even_depend_temp == 11'b0101_0101_110||opcode_even_depend_temp == 11'b0101_0100_110)
opcode_even_depend_lat = 3'd2;  
else if(opcode_even_depend_temp == 11'b0000_1111_011|| opcode_even_depend_temp == 11'b0000_1011_000|| opcode_even_depend_temp == 11'b0000_1011_001||opcode_even_depend_temp == 11'b0000_1011_011||
opcode_even_depend_temp == 11'b0101_0110_100||opcode_even_depend_temp == 11'b0000_1010_011||opcode_even_depend_temp == 11'b0001_1010_011||opcode_even_depend_temp == 11'b0100_1010_011)
opcode_even_depend_lat = 3'd4;
else if(opcode_even_depend_temp == 4'b1110_||opcode_even_depend_temp == 4'b1111_||opcode_even_depend_temp == 11'b0101_1000_100||opcode_even_depend_temp == 11'b0101_1000_110||opcode_even_depend_temp == 11'b0101_1000_101)
opcode_even_depend_lat = 3'd6;
else if (opcode_even_depend_temp == 4'b1100_|| opcode_even_depend_temp == 8'b0111_0100|| opcode_even_depend_temp == 8'b0111_0101||opcode_even_depend_temp == 11'b0111_1000_100|| opcode_even_depend_temp == 11'b0111_1000_111||opcode_even_depend_temp == 11'b0111_1001_100)
opcode_even_depend_lat = 3'd7;
else opcode_even_depend_lat = 3'd0;


if(opcode_odd_depend_temp == 11'b0011_1011_101||opcode_odd_depend_temp == 11'b0011_1011_111||opcode_odd_depend_temp == 9'b0011_0001_0||opcode_odd_depend_temp == 9'b0011_0011_0||
opcode_odd_depend_temp == 9'b0011_0010_0||opcode_odd_depend_temp == 9'b0011_0000_0||opcode_odd_depend_temp == 11'b0011_0101_000||opcode_odd_depend_temp == 11'b0011_0101_001||
opcode_odd_depend_temp == 9'b0010_0001_0||opcode_odd_depend_temp == 9'b0010_0000_0)
opcode_odd_depend_lat = 3'd4;
else if (opcode_odd_depend_temp == 9'b0011_0000_1||opcode_odd_depend_temp == 9'b0010_0000_1||opcode_odd_depend_temp == 11'b0011_1000_100||opcode_odd_depend_temp == 11'b0010_1000_100)
opcode_odd_depend_lat = 3'd6;
else opcode_odd_depend_lat = 3'd0;

end // always_comb



always_comb begin 

//$display("========================= > addr_even_rb: %d | Rt_Temp_odd:%d",addr_even_rb, Rt_Temp_odd [7:14]);

if (((addr_even_ra!=7'b0) && (addr_even_ra == addr_even_rt_depend_temp)) || 
        ((addr_even_rb!=7'b0) && (addr_even_rb == addr_even_rt_depend_temp)) || 
        ((addr_even_rc!=7'b0) && (addr_even_rc == addr_even_rt_depend_temp)) || 
        ((addr_odd_ra!=7'b0) && (addr_odd_ra == addr_even_rt_depend_temp)) || 
        ((addr_odd_rb!=7'b0) && (addr_odd_rb == addr_even_rt_depend_temp)) || 
        ((addr_odd_rc!=7'b0) && (addr_odd_rc == addr_even_rt_depend_temp))) begin
        count=opcode_even_depend_lat-1; $display("1st EVEN If - Data Hazard"); 
    end 

else if (((addr_even_ra!=7'b0) && (addr_even_ra == Rt_Temp_even [7:14])) || 
        ((addr_even_rb!=7'b0) && (addr_even_rb == Rt_Temp_even [7:14])) || 
        ((addr_even_rc!=7'b0) && (addr_even_rc == Rt_Temp_even [7:14])) || 
        ((addr_odd_ra!=7'b0) && (addr_odd_ra == Rt_Temp_even [7:14])) || 
        ((addr_odd_rb!=7'b0) && (addr_odd_rb == Rt_Temp_even [7:14])) || 
        ((addr_odd_rc!=7'b0) && (addr_odd_rc == Rt_Temp_even [7:14]))) begin
        count=Rt_Temp_even[3:5]-2; $display("2st EVEN If - Data Hazard"); 
    end

else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp1_even [7:14])) || 
        ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp1_even [7:14])) || 
        ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp1_even [7:14])) || 
        ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp1_even [7:14])) || 
        ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp1_even [7:14])) || 
        ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp1_even [7:14]))) begin
        count=Rt_Temp1_even[3:5]-3; $display("3nd EVEN If - Data Hazard"); end

else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp2_even [7:14])) || 
        ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp2_even [7:14])) || 
        ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp2_even [7:14])) || 
        ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp2_even [7:14])) || 
        ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp2_even [7:14])) || 
        ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp2_even [7:14]))) begin
        count=Rt_Temp2_even[3:5]-4; $display("4rd EVEN If - Data Hazard"); end

else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp3_even [7:14])) || 
        ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp3_even [7:14])) || 
        ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp3_even [7:14])) || 
        ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp3_even [7:14])) || 
        ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp3_even [7:14])) || 
        ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp3_even [7:14]))) begin
        count=Rt_Temp3_even[3:5]-5; $display("5th EVEN If - Data Hazard"); end

else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp4_even [7:14])) || 
        ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp4_even [7:14])) || 
        ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp4_even [7:14])) || 
        ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp4_even [7:14])) || 
        ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp4_even [7:14])) || 
        ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp4_even [7:14]))) begin
        count=Rt_Temp4_even[3:5]-6; $display("6th EVEN If - Data Hazard"); end

else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp5_even [7:14])) || 
        ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp5_even [7:14])) || 
        ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp5_even [7:14])) || 
        ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp5_even [7:14])) || 
        ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp5_even [7:14])) || 
        ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp5_even [7:14]))) begin
        count=Rt_Temp5_even[3:5]-7; $display("7th EVEN If - Data Hazard"); end

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp6_even [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp6_even [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp6_even [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp6_even [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp6_even [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp6_even [7:14]))) begin
//         count=Rt_Temp6_even[3:5]-7; $display("8th EVEN If - Data Hazard"); end

// ------------------------------------------------------------------------------------- 

else if (((addr_even_ra!=7'b0) && (addr_even_ra == addr_odd_rt_depend_temp)) || 
        ((addr_even_rb!=7'b0) && (addr_even_rb == addr_odd_rt_depend_temp)) || 
        ((addr_even_rc!=7'b0) && (addr_even_rc == addr_odd_rt_depend_temp)) || 
        ((addr_odd_ra!=7'b0) && (addr_odd_ra == addr_odd_rt_depend_temp)) || 
        ((addr_odd_rb!=7'b0) && (addr_odd_rb == addr_odd_rt_depend_temp)) || 
        ((addr_odd_rc!=7'b0) && (addr_odd_rc == addr_odd_rt_depend_temp))) begin
        count=opcode_odd_depend_lat-1; $display("1st ODD If - Data Hazard" ); 
    end 

else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp_odd [7:14])) || 
        ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp_odd [7:14])) || 
        ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp_odd [7:14])) || 
        ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp_odd [7:14])) || 
        ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp_odd [7:14])) || 
        ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp_odd [7:14]))) begin
        count=Rt_Temp_odd[3:5]-2; $display("2st ODD If - Data Hazard"); end

else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp1_odd [7:14])) || 
        ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp1_odd [7:14])) || 
        ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp1_odd [7:14])) || 
        ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp1_odd [7:14])) || 
        ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp1_odd [7:14])) || 
        ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp1_odd [7:14]))) begin
        count=Rt_Temp1_odd[3:5]-3; $display("3nd ODD If - Data Hazard"); end

else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp2_odd [7:14])) || 
        ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp2_odd [7:14])) || 
        ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp2_odd [7:14])) || 
        ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp2_odd [7:14])) || 
        ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp2_odd [7:14])) || 
        ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp2_odd [7:14]))) begin
        count=Rt_Temp2_odd[3:5]-4; $display("4rd ODD If - Data Hazard"); end

else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp3_odd [7:14])) || 
        ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp3_odd [7:14])) || 
        ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp3_odd [7:14])) || 
        ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp3_odd [7:14])) || 
        ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp3_odd [7:14])) || 
        ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp3_odd [7:14]))) begin
        count=Rt_Temp3_odd[3:5]-5; $display("5th ODD If - Data Hazard"); end

else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp4_odd [7:14])) || 
        ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp4_odd [7:14])) || 
        ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp4_odd [7:14])) || 
        ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp4_odd [7:14])) || 
        ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp4_odd [7:14])) || 
        ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp4_odd [7:14]))) begin
        count=Rt_Temp4_odd[3:5]-6; $display("6th ODD If - Data Hazard"); end

else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp5_odd [7:14])) || 
        ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp5_odd [7:14])) || 
        ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp5_odd [7:14])) || 
        ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp5_odd [7:14])) || 
        ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp5_odd [7:14])) || 
        ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp5_odd [7:14]))) begin
        count=Rt_Temp5_odd[3:5]-7; $display("7th ODD If - Data Hazard"); end

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp6_odd [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp6_odd [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp6_odd [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp6_odd [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp6_odd [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp6_odd [7:14]))) begin
//         count=Rt_Temp6_odd[3:5]-7; $display("7th ODD If - Data Hazard"); end

else
    count=0;
end 


//always_ff@(posedge clk) begin $display("@ DEPENDENCY Rt_Temp_even: %d",Rt_Temp_even[0:2]); end


endmodule


// -------------- 1st Backup

// always_ff @(posedge clk) begin
//     $display("Counter:%d, Count:%d ", counter, count);
//   if(count == 1) counter <= 1;
//   else if (count == 2 ) counter <= 2;
//   else if (count == 3 ) counter <= 3;
//   else if (count == 4 ) counter <= 4;
//   else if (count == 5 ) counter <= 5;
//   else if (count == 6 ) counter <= 6;
//   else counter <= 0;

//   if(count == 0 && counter > 0) begin
//     counter <= counter - 1; //$display("--------------------------------------------------------------------->>> Data Hazard");
//     Dependency_stall = 1;
//     opcode_even_depend = 11'b0100_0000_001; 
//     opcode_odd_depend = 11'b0100_0000_010; 
//     end
  

//   else if(count == 0 && counter == 0) begin
//     //$display("--------------------------------------------------------------------->>> No Data Hazard, Counter:%d, Count:%d ", counter, count);
//     $display ("opcode_even: %b | @ Dependency Stge" , opcode_even_depend);
//     $display ("opcode_odd: %b | @ Dependency Stage", opcode_odd_depend);
    
//     Dependency_stall = 0; 
//     addr_even_ra_depend<=addr_even_ra;
//     addr_even_rb_depend<=addr_even_rb;
//     addr_even_rc_depend<=addr_even_rc;
//     opcode_even_depend <= opcode_even; addr_even_rt_depend <= addr_even_rt;
//     imm7_even_depend <= imm7_even; imm10_even_depend <= imm10_even; 
//     imm16_even_depend <= imm16_even; imm18_even_depend <= imm18_even;

//     addr_odd_ra_depend<=addr_odd_ra;
//     addr_odd_rb_depend<=addr_odd_rb;
//     addr_odd_rc_depend<=addr_odd_rc;
//     opcode_odd_depend <= opcode_odd; addr_odd_rt_depend <= addr_odd_rt;
//     imm7_odd_depend <= imm7_odd; imm10_odd_depend <= imm10_odd; 
//     imm16_odd_depend <= imm16_odd; imm18_odd_depend <= imm18_odd; 

// // ----------------------------------- For Latency Calculation @ Reg File

//     opcode_even_depend_temp  <= opcode_even;
//     addr_even_rt_depend_temp <= addr_even_rt;
//     opcode_odd_depend_temp   <= opcode_odd;
//     addr_odd_rt_depend_temp  <= addr_odd_rt;

//   end
// end


// ---------------- 2nd Backup

//===================================================Dependency==========================================================

// module Dependency (clk, reset,addr_even_ra, addr_even_rb, addr_even_rc, opcode_even, imm10_even, imm16_even, imm18_even, imm7_even, addr_even_rt,
// addr_odd_ra, addr_odd_rb, addr_odd_rc, opcode_odd, imm10_odd, imm16_odd, imm18_odd, imm7_odd, addr_odd_rt, flush,opcode_even_depend, imm7_even_depend, imm10_even_depend, imm16_even_depend, imm18_even_depend, addr_even_rt_depend, addr_even_ra_depend, addr_even_rb_depend, addr_even_rc_depend , opcode_odd_depend,imm7_odd_depend,imm10_odd_depend,imm16_odd_depend,imm18_odd_depend,addr_odd_rt_depend,addr_odd_ra_depend, addr_odd_rb_depend, addr_odd_rc_depend, Dependency_stall, Rt_Temp_even, Rt_Temp1_even, Rt_Temp2_even, Rt_Temp3_even, Rt_Temp4_even, Rt_Temp5_even, Rt_Temp6_even, Rt_Temp_odd, Rt_Temp1_odd, Rt_Temp2_odd, Rt_Temp3_odd, Rt_Temp4_odd, Rt_Temp5_odd, Rt_Temp6_odd);

// input clk, reset, flush;
// input [0:6] addr_even_ra, addr_even_rb, addr_even_rc;  
// input [0:6] addr_odd_ra, addr_odd_rb, addr_odd_rc;  
// input [0:10] opcode_even;              
// input signed [0:6] imm7_even;          
// input signed [0:9] imm10_even;         
// input signed [0:15] imm16_even;        
// input signed [0:17] imm18_even;        
// input [0:6] addr_even_rt;              
// input [0:142] Rt_Temp_even, Rt_Temp1_even, Rt_Temp2_even, Rt_Temp3_even, Rt_Temp4_even, Rt_Temp5_even, Rt_Temp6_even;


// output logic [0:10] opcode_even_depend;         
// output logic signed [0:6] imm7_even_depend;           
// output logic signed [0:9] imm10_even_depend;          
// output logic signed [0:15] imm16_even_depend;        
// output logic signed [0:17] imm18_even_depend;         
// output logic [0:6] addr_even_rt_depend;         
// output logic [0:6] addr_even_ra_depend, addr_even_rb_depend, addr_even_rc_depend; 

// input [0:10] opcode_odd;       
// input [0:6] imm7_odd;          
// input [0:9] imm10_odd;         
// input [0:15] imm16_odd;        
// input [0:17] imm18_odd;        
// input [0:6] addr_odd_rt;                 
// input [0:175] Rt_Temp_odd, Rt_Temp1_odd, Rt_Temp2_odd, Rt_Temp3_odd, Rt_Temp4_odd, Rt_Temp5_odd, Rt_Temp6_odd; 


// output logic [0:10] opcode_odd_depend;            
// output logic signed [0:6] imm7_odd_depend;                
// output logic signed [0:9] imm10_odd_depend;              
// output logic signed [0:15] imm16_odd_depend;             
// output logic signed [0:17] imm18_odd_depend;                 
// output logic signed [0:6] addr_odd_rt_depend;   
// output logic [0:6] addr_odd_ra_depend, addr_odd_rb_depend, addr_odd_rc_depend; 

// logic [0:10] opcode_odd_depend2, opcode_even_depend2 ;       

// output logic Dependency_stall;

// logic [0:10] opcode_even_depend_temp, opcode_odd_depend_temp;
// logic [0:6] addr_even_rt_depend_temp, addr_odd_rt_depend_temp;
// logic [0:2] opcode_even_depend_lat, opcode_odd_depend_lat;
// logic [0:2] count, counter;


// assign Dependency_stall = (counter > 0);

// always_comb begin
//     if (Dependency_stall) begin
//     opcode_even_depend = 11'b0100_0000_001; 
//     opcode_odd_depend = 11'b0100_0000_010; end

//     else begin 
//         opcode_even_depend = opcode_even_depend2;
//         opcode_odd_depend = opcode_odd_depend2;end
// end

// always_ff @(posedge clk) begin
//     $display("Counter:%d, Count:%d ", counter, count);
  
//   if(counter > 0) begin // count == 0 && 
//     counter = counter - 1; $display("---------------------------------------|||||||||||||------------------------------>>> Data Hazard");
//     //Dependency_stall = 1;
//     // opcode_even_depend = 11'b0100_0000_001; 
//     // opcode_odd_depend = 11'b0100_0000_010; 
//     end

//   else if(count == 1) counter <= 0;
//   else if (count == 2 ) counter <= 1;
//   else if (count == 3 ) counter <= 2;
//   else if (count == 4 ) counter <= 3;
//   else if (count == 5 ) counter <= 4;
//   else if (count == 6 ) counter <= 5;

//   else if(count == 0 && counter == 0) begin
//     //$display("--------------------------------------------------------------------->>> No Data Hazard, Counter:%d, Count:%d ", counter, count);    
//     //Dependency_stall = 0; 
//     addr_even_ra_depend<=addr_even_ra;
//     addr_even_rb_depend<=addr_even_rb;
//     addr_even_rc_depend<=addr_even_rc;
//     opcode_even_depend2 <= opcode_even; addr_even_rt_depend <= addr_even_rt;
//     imm7_even_depend <= imm7_even; imm10_even_depend <= imm10_even; 
//     imm16_even_depend <= imm16_even; imm18_even_depend <= imm18_even;

//     addr_odd_ra_depend<=addr_odd_ra;
//     addr_odd_rb_depend<=addr_odd_rb;
//     addr_odd_rc_depend<=addr_odd_rc;
//     opcode_odd_depend2 <= opcode_odd; addr_odd_rt_depend <= addr_odd_rt;
//     imm7_odd_depend <= imm7_odd; imm10_odd_depend <= imm10_odd; 
//     imm16_odd_depend <= imm16_odd; imm18_odd_depend <= imm18_odd; 

// // ----------------------------------- For Latency Calculation @ Reg File

//     opcode_even_depend_temp  <= opcode_even;
//     addr_even_rt_depend_temp <= addr_even_rt;
//     opcode_odd_depend_temp   <= opcode_odd;
//     addr_odd_rt_depend_temp  <= addr_odd_rt;

//   end

//   else counter <= 0;
  
//     $display ("opcode_even: %b | @ Dependency Stge" , opcode_even_depend);
//     $display ("opcode_odd: %b | @ Dependency Stage", opcode_odd_depend);
// end




// always_comb begin 
// if (opcode_even_depend_temp == 7'b0100_001||opcode_even_depend_temp == 8'b0001_1100||opcode_even_depend_temp == 8'b0001_0110||opcode_even_depend_temp == 8'b0111_1110||
// opcode_even_depend_temp == 8'b0111_1100||opcode_even_depend_temp == 8'b0100_1110||opcode_even_depend_temp == 8'b0100_1100||opcode_even_depend_temp == 8'b0101_1110||
// opcode_even_depend_temp == 8'b0000_0100||opcode_even_depend_temp == 8'b0000_1100||opcode_even_depend_temp == 8'b0100_0110||opcode_even_depend_temp == 8'b0100_0100||
// opcode_even_depend_temp == 9'b0100_0000_1||opcode_even_depend_temp == 9'b0100_0001_1||opcode_even_depend_temp == 11'b0001_1000_000||opcode_even_depend_temp == 11'b1101_0000_000||
// opcode_even_depend_temp == 11'b0001_1000_001||opcode_even_depend_temp == 11'b0101_1000_001||opcode_even_depend_temp == 11'b0111_1000_000||opcode_even_depend_temp == 11'b0111_1010_000||
// opcode_even_depend_temp == 11'b0100_1010_000||opcode_even_depend_temp == 11'b0101_1010_000||opcode_even_depend_temp == 11'b0001_1001_001||opcode_even_depend_temp == 11'b0000_1001_001||
// opcode_even_depend_temp == 11'b0000_1000_001||opcode_even_depend_temp == 11'b0101_1001_001||opcode_even_depend_temp == 11'b0000_1000_000||opcode_even_depend_temp == 11'b0110_1000_001||
// opcode_even_depend_temp == 11'b0100_1000_001||opcode_even_depend_temp == 11'b0101_0110_110||opcode_even_depend_temp == 11'b0101_0101_110||opcode_even_depend_temp == 11'b0101_0100_110)
// opcode_even_depend_lat = 3'd2;  
// else if(opcode_even_depend_temp == 11'b0000_1111_011|| opcode_even_depend_temp == 11'b0000_1011_000|| opcode_even_depend_temp == 11'b0000_1011_001||opcode_even_depend_temp == 11'b0000_1011_011||
// opcode_even_depend_temp == 11'b0101_0110_100||opcode_even_depend_temp == 11'b0000_1010_011||opcode_even_depend_temp == 11'b0001_1010_011||opcode_even_depend_temp == 11'b0100_1010_011)
// opcode_even_depend_lat = 3'd4;
// else if(opcode_even_depend_temp == 4'b1110_||opcode_even_depend_temp == 4'b1111_||opcode_even_depend_temp == 11'b0101_1000_100||opcode_even_depend_temp == 11'b0101_1000_110||opcode_even_depend_temp == 11'b0101_1000_101)
// opcode_even_depend_lat = 3'd6;
// else if (opcode_even_depend_temp == 4'b1100_|| opcode_even_depend_temp == 8'b0111_0100|| opcode_even_depend_temp == 8'b0111_0101||opcode_even_depend_temp == 11'b0111_1000_100|| opcode_even_depend_temp == 11'b0111_1000_111||opcode_even_depend_temp == 11'b0111_1001_100)
// opcode_even_depend_lat = 3'd7;
// else opcode_even_depend_lat = 3'd0;


// if(opcode_odd_depend_temp == 11'b0011_1011_101||opcode_odd_depend_temp == 11'b0011_1011_111||opcode_odd_depend_temp == 9'b0011_0001_0||opcode_odd_depend_temp == 9'b0011_0011_0||
// opcode_odd_depend_temp == 9'b0011_0010_0||opcode_odd_depend_temp == 9'b0011_0000_0||opcode_odd_depend_temp == 11'b0011_0101_000||opcode_odd_depend_temp == 11'b0011_0101_001||
// opcode_odd_depend_temp == 9'b0010_0001_0||opcode_odd_depend_temp == 9'b0010_0000_0)
// opcode_odd_depend_lat = 3'd4;
// else if (opcode_odd_depend_temp == 9'b0011_0000_1||opcode_odd_depend_temp == 9'b0010_0000_1||opcode_odd_depend_temp == 11'b0011_1000_100||opcode_odd_depend_temp == 11'b0010_1000_100)
// opcode_odd_depend_lat = 3'd6;
// else opcode_odd_depend_lat = 3'd0;

// end // always_comb



// always_comb begin 

// $display("========================= > addr_even_rb: %d | Rt_Temp_odd:%d",addr_even_rb, Rt_Temp_odd [7:14]);

// if (((addr_even_ra!=7'b0) && (addr_even_ra == addr_even_rt_depend_temp)) || 
//         ((addr_even_rb!=7'b0) && (addr_even_rb == addr_even_rt_depend_temp)) || 
//         ((addr_even_rc!=7'b0) && (addr_even_rc == addr_even_rt_depend_temp)) || 
//         ((addr_odd_ra!=7'b0) && (addr_odd_ra == addr_even_rt_depend_temp)) || 
//         ((addr_odd_rb!=7'b0) && (addr_odd_rb == addr_even_rt_depend_temp)) || 
//         ((addr_odd_rc!=7'b0) && (addr_odd_rc == addr_even_rt_depend_temp))) begin
//         count=opcode_even_depend_lat-1; $display("1st EVEN If - Data Hazard"); 
//     end 

// else if (((addr_even_ra!=7'b0) && (addr_even_ra == Rt_Temp_even [7:14])) || 
//         ((addr_even_rb!=7'b0) && (addr_even_rb == Rt_Temp_even [7:14])) || 
//         ((addr_even_rc!=7'b0) && (addr_even_rc == Rt_Temp_even [7:14])) || 
//         ((addr_odd_ra!=7'b0) && (addr_odd_ra == Rt_Temp_even [7:14])) || 
//         ((addr_odd_rb!=7'b0) && (addr_odd_rb == Rt_Temp_even [7:14])) || 
//         ((addr_odd_rc!=7'b0) && (addr_odd_rc == Rt_Temp_even [7:14]))) begin
//         count=Rt_Temp_even[3:5]-2; $display("2st EVEN If - Data Hazard"); 
//     end

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp1_even [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp1_even [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp1_even [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp1_even [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp1_even [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp1_even [7:14]))) begin
//         count=Rt_Temp1_even[3:5]-3; $display("3nd EVEN If - Data Hazard"); end

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp2_even [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp2_even [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp2_even [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp2_even [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp2_even [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp2_even [7:14]))) begin
//         count=Rt_Temp2_even[3:5]-4; $display("4rd EVEN If - Data Hazard"); end

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp3_even [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp3_even [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp3_even [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp3_even [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp3_even [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp3_even [7:14]))) begin
//         count=Rt_Temp3_even[3:5]-5; $display("5th EVEN If - Data Hazard"); end

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp4_even [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp4_even [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp4_even [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp4_even [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp4_even [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp4_even [7:14]))) begin
//         count=Rt_Temp4_even[3:5]-6; $display("6th EVEN If - Data Hazard"); end

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp5_even [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp5_even [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp5_even [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp5_even [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp5_even [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp5_even [7:14]))) begin
//         count=Rt_Temp5_even[3:5]-7; $display("7th EVEN If - Data Hazard"); end

// // else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp6_even [7:14])) || 
// //         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp6_even [7:14])) || 
// //         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp6_even [7:14])) || 
// //         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp6_even [7:14])) || 
// //         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp6_even [7:14])) || 
// //         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp6_even [7:14]))) begin
// //         count=Rt_Temp6_even[3:5]-7; $display("8th EVEN If - Data Hazard"); end

// // ------------------------------------------------------------------------------------- 

// else if (((addr_even_ra!=7'b0) && (addr_even_ra == addr_odd_rt_depend_temp)) || 
//         ((addr_even_rb!=7'b0) && (addr_even_rb == addr_odd_rt_depend_temp)) || 
//         ((addr_even_rc!=7'b0) && (addr_even_rc == addr_odd_rt_depend_temp)) || 
//         ((addr_odd_ra!=7'b0) && (addr_odd_ra == addr_odd_rt_depend_temp)) || 
//         ((addr_odd_rb!=7'b0) && (addr_odd_rb == addr_odd_rt_depend_temp)) || 
//         ((addr_odd_rc!=7'b0) && (addr_odd_rc == addr_odd_rt_depend_temp))) begin
//         count=opcode_odd_depend_lat-1; $display("1st ODD If - Data Hazard" ); 
//     end 

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp_odd [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp_odd [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp_odd [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp_odd [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp_odd [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp_odd [7:14]))) begin
//         count=Rt_Temp_odd[3:5]-2; $display("2st ODD If - Data Hazard"); end

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp1_odd [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp1_odd [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp1_odd [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp1_odd [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp1_odd [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp1_odd [7:14]))) begin
//         count=Rt_Temp1_odd[3:5]-3; $display("3nd ODD If - Data Hazard"); end

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp2_odd [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp2_odd [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp2_odd [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp2_odd [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp2_odd [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp2_odd [7:14]))) begin
//         count=Rt_Temp2_odd[3:5]-4; $display("4rd ODD If - Data Hazard"); end

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp3_odd [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp3_odd [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp3_odd [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp3_odd [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp3_odd [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp3_odd [7:14]))) begin
//         count=Rt_Temp3_odd[3:5]-5; $display("5th ODD If - Data Hazard"); end

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp4_odd [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp4_odd [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp4_odd [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp4_odd [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp4_odd [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp4_odd [7:14]))) begin
//         count=Rt_Temp4_odd[3:5]-6; $display("6th ODD If - Data Hazard"); end

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp5_odd [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp5_odd [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp5_odd [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp5_odd [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp5_odd [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp5_odd [7:14]))) begin
//         count=Rt_Temp5_odd[3:5]-7; $display("7th ODD If - Data Hazard"); end

// // else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp6_odd [7:14])) || 
// //         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp6_odd [7:14])) || 
// //         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp6_odd [7:14])) || 
// //         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp6_odd [7:14])) || 
// //         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp6_odd [7:14])) || 
// //         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp6_odd [7:14]))) begin
// //         count=Rt_Temp6_odd[3:5]-7; $display("7th ODD If - Data Hazard"); end

// else
//     count=0;
// end 


// //always_ff@(posedge clk) begin $display("@ DEPENDENCY Rt_Temp_even: %d",Rt_Temp_even[0:2]); end


// endmodule




//-=-=-=-=-=-=-=



// //===================================================Dependency==========================================================

// module Dependency (clk, reset,addr_even_ra, addr_even_rb, addr_even_rc, opcode_even, imm10_even, imm16_even, imm18_even, imm7_even, addr_even_rt,
// addr_odd_ra, addr_odd_rb, addr_odd_rc, opcode_odd, imm10_odd, imm16_odd, imm18_odd, imm7_odd, addr_odd_rt, flush,opcode_even_depend, imm7_even_depend, imm10_even_depend, imm16_even_depend, imm18_even_depend, addr_even_rt_depend, addr_even_ra_depend, addr_even_rb_depend, addr_even_rc_depend , opcode_odd_depend,imm7_odd_depend,imm10_odd_depend,imm16_odd_depend,imm18_odd_depend,addr_odd_rt_depend,addr_odd_ra_depend, addr_odd_rb_depend, addr_odd_rc_depend, Dependency_stall, Rt_Temp_even, Rt_Temp1_even, Rt_Temp2_even, Rt_Temp3_even, Rt_Temp4_even, Rt_Temp5_even, Rt_Temp6_even, Rt_Temp_odd, Rt_Temp1_odd, Rt_Temp2_odd, Rt_Temp3_odd, Rt_Temp4_odd, Rt_Temp5_odd, Rt_Temp6_odd);

// input clk, reset, flush;
// input [0:6] addr_even_ra, addr_even_rb, addr_even_rc;  
// input [0:6] addr_odd_ra, addr_odd_rb, addr_odd_rc;  
// input [0:10] opcode_even;              
// input signed [0:6] imm7_even;          
// input signed [0:9] imm10_even;         
// input signed [0:15] imm16_even;        
// input signed [0:17] imm18_even;        
// input [0:6] addr_even_rt;              
// input [0:142] Rt_Temp_even, Rt_Temp1_even, Rt_Temp2_even, Rt_Temp3_even, Rt_Temp4_even, Rt_Temp5_even, Rt_Temp6_even;


// output logic [0:10] opcode_even_depend;         
// output logic signed [0:6] imm7_even_depend;           
// output logic signed [0:9] imm10_even_depend;          
// output logic signed [0:15] imm16_even_depend;        
// output logic signed [0:17] imm18_even_depend;         
// output logic [0:6] addr_even_rt_depend;         
// output logic [0:6] addr_even_ra_depend, addr_even_rb_depend, addr_even_rc_depend; 

// input [0:10] opcode_odd;       
// input [0:6] imm7_odd;          
// input [0:9] imm10_odd;         
// input [0:15] imm16_odd;        
// input [0:17] imm18_odd;        
// input [0:6] addr_odd_rt;                 
// input [0:175] Rt_Temp_odd, Rt_Temp1_odd, Rt_Temp2_odd, Rt_Temp3_odd, Rt_Temp4_odd, Rt_Temp5_odd, Rt_Temp6_odd; 


// output logic [0:10] opcode_odd_depend;            
// output logic signed [0:6] imm7_odd_depend;                
// output logic signed [0:9] imm10_odd_depend;              
// output logic signed [0:15] imm16_odd_depend;             
// output logic signed [0:17] imm18_odd_depend;                 
// output logic signed [0:6] addr_odd_rt_depend;   
// output logic [0:6] addr_odd_ra_depend, addr_odd_rb_depend, addr_odd_rc_depend; 
// logic [0:6] addr_odd_rt_depend2; 
// logic signed [0:15] imm16_odd_depend2; 


// logic [0:10] opcode_odd_depend_bck;            
// logic signed [0:6] imm7_odd_depend_bck;                
// logic signed [0:9] imm10_odd_depend_bck;              
// logic signed [0:15] imm16_odd_depend_bck;             
// logic signed [0:17] imm18_odd_depend_bck;                 
// logic signed [0:6] addr_odd_rt_depend_bck;   
// logic [0:6] addr_odd_ra_depend_bck, addr_odd_rb_depend_bck, addr_odd_rc_depend_bck; 

// logic [0:10] opcode_even_depend_bck;         
// logic signed [0:6] imm7_even_depend_bck;           
// logic signed [0:9] imm10_even_depend_bck;          
// logic signed [0:15] imm16_even_depend_bck;        
// logic signed [0:17] imm18_even_depend_bck;         
// logic [0:6] addr_even_rt_depend_bck;         
// logic [0:6] addr_even_ra_depend_bck, addr_even_rb_depend_bck, addr_even_rc_depend_bck; 

// logic [0:10] opcode_odd_depend2, opcode_even_depend2 ;       

// output logic Dependency_stall;

// logic [0:10] opcode_even_depend_temp, opcode_odd_depend_temp;
// logic [0:6] addr_even_rt_depend_temp, addr_odd_rt_depend_temp;
// logic [0:2] opcode_even_depend_lat, opcode_odd_depend_lat;
// logic [0:2] count, counter;
// logic Prev_Stall;


// assign Dependency_stall = (counter > 0);


// always_ff @(posedge clk) begin
//    $display("Counter:%d, Count:%d ", counter, count);
  
//    Prev_Stall <= Dependency_stall;

//   if(counter > 0) begin // count == 0 && 
//     counter = counter - 1; $display("---------------------------------------|||||||||||||------------------------------>>> Data Hazard");
//     //Dependency_stall = 1;
//     // opcode_even_depend = 11'b0100_0000_001; 
//     // opcode_odd_depend = 11'b0100_0000_010; 
//     end

//   else if(count == 1) counter <= 1;
//   else if (count == 2 ) counter <= 2;
//   else if (count == 3 ) counter <= 3;
//   else if (count == 4 ) counter <= 4;
//   else if (count == 5 ) counter <= 5;
//   else if (count == 6 ) counter <= 6;

//   if (Dependency_stall) begin
//     opcode_even_depend = 11'b0100_0000_001; 
//     opcode_odd_depend = 11'b0100_0000_010; end 
  
//   else if (Prev_Stall == 1 && Dependency_stall == 0) begin
//     addr_even_ra_depend  <= addr_even_ra_depend_bck;
//     addr_even_rb_depend  <= addr_even_rb_depend_bck;
//     addr_even_rc_depend  <= addr_even_rc_depend_bck;
//     opcode_even_depend  <= opcode_even_depend_bck;
//     addr_even_rt_depend  <= addr_even_rt_depend_bck;
//     imm7_even_depend     <= imm7_even_depend_bck;
//     imm10_even_depend    <= imm10_even_depend_bck;
//     imm16_even_depend    <= imm16_even_depend_bck;
//     imm18_even_depend    <= imm18_even_depend_bck;

//     addr_odd_ra_depend   <= addr_odd_ra_depend_bck;
//     addr_odd_rb_depend   <= addr_odd_rb_depend_bck;
//     addr_odd_rc_depend   <= addr_odd_rc_depend_bck;
//     opcode_odd_depend   <= opcode_odd_depend_bck;
//     addr_odd_rt_depend   <= addr_odd_rt_depend_bck;
//     imm7_odd_depend      <= imm7_odd_depend_bck;
//     imm10_odd_depend     <= imm10_odd_depend_bck;
//     imm16_odd_depend     <= imm16_odd_depend_bck;
//     imm18_odd_depend     <= imm18_odd_depend_bck;

//     end

//   else if(count == 0 && counter == 0) begin
//     //$display("--------------------------------------------------------------------->>> No Data Hazard, Counter:%d, Count:%d ", counter, count);    
//     //Dependency_stall = 0; 
//     addr_even_ra_depend<=addr_even_ra;
//     addr_even_rb_depend<=addr_even_rb;
//     addr_even_rc_depend<=addr_even_rc;
//     opcode_even_depend <= opcode_even; addr_even_rt_depend <= addr_even_rt;
//     imm7_even_depend <= imm7_even; imm10_even_depend <= imm10_even; 
//     imm16_even_depend <= imm16_even; imm18_even_depend <= imm18_even;

//     addr_odd_ra_depend<=addr_odd_ra;
//     addr_odd_rb_depend<=addr_odd_rb;
//     addr_odd_rc_depend<=addr_odd_rc;
//     opcode_odd_depend <= opcode_odd; addr_odd_rt_depend2 <= addr_odd_rt;
//     imm7_odd_depend <= imm7_odd; imm10_odd_depend <= imm10_odd; 
//     imm16_odd_depend <= imm16_odd; imm18_odd_depend <= imm18_odd; 

// // ----------------------------------- For Latency Calculation @ Reg File

//     opcode_even_depend_temp  <= opcode_even;
//     addr_even_rt_depend_temp <= addr_even_rt;
//     opcode_odd_depend_temp   <= opcode_odd;
//     addr_odd_rt_depend_temp  <= addr_odd_rt;

//   end

//   else counter <= 0;

//     $display ("opcode_even: %b | @ Dependency Stge" , opcode_even_depend);
//     $display ("opcode_odd: %b | @ Dependency Stage", opcode_odd_depend);
// end

// always_ff @(posedge clk) begin

// if(Dependency_stall) begin
//     addr_even_ra_depend_bck<=addr_even_ra;
//     addr_even_rb_depend_bck<=addr_even_rb;
//     addr_even_rc_depend_bck<=addr_even_rc;
//     opcode_even_depend_bck <= opcode_even; 
//     addr_even_rt_depend_bck <= addr_even_rt;
//     imm7_even_depend_bck <= imm7_even; 
//     imm10_even_depend_bck <= imm10_even; 
//     imm16_even_depend_bck <= imm16_even; 
//     imm18_even_depend_bck <= imm18_even;

//     addr_odd_ra_depend_bck<=addr_odd_ra;
//     addr_odd_rb_depend_bck<=addr_odd_rb;
//     addr_odd_rc_depend_bck<=addr_odd_rc;
//     opcode_odd_depend_bck <= opcode_odd; 
//     addr_odd_rt_depend_bck <= addr_odd_rt;
//     imm7_odd_depend_bck <= imm7_odd; 
//     imm10_odd_depend_bck <= imm10_odd; 
//     imm16_odd_depend_bck <= imm16_odd; 
//     imm18_odd_depend_bck <= imm18_odd; 
// end end





// always_comb begin 
// if (opcode_even_depend_temp == 7'b0100_001||opcode_even_depend_temp == 8'b0001_1100||opcode_even_depend_temp == 8'b0001_0110||opcode_even_depend_temp == 8'b0111_1110||
// opcode_even_depend_temp == 8'b0111_1100||opcode_even_depend_temp == 8'b0100_1110||opcode_even_depend_temp == 8'b0100_1100||opcode_even_depend_temp == 8'b0101_1110||
// opcode_even_depend_temp == 8'b0000_0100||opcode_even_depend_temp == 8'b0000_1100||opcode_even_depend_temp == 8'b0100_0110||opcode_even_depend_temp == 8'b0100_0100||
// opcode_even_depend_temp == 9'b0100_0000_1||opcode_even_depend_temp == 9'b0100_0001_1||opcode_even_depend_temp == 11'b0001_1000_000||opcode_even_depend_temp == 11'b1101_0000_000||
// opcode_even_depend_temp == 11'b0001_1000_001||opcode_even_depend_temp == 11'b0101_1000_001||opcode_even_depend_temp == 11'b0111_1000_000||opcode_even_depend_temp == 11'b0111_1010_000||
// opcode_even_depend_temp == 11'b0100_1010_000||opcode_even_depend_temp == 11'b0101_1010_000||opcode_even_depend_temp == 11'b0001_1001_001||opcode_even_depend_temp == 11'b0000_1001_001||
// opcode_even_depend_temp == 11'b0000_1000_001||opcode_even_depend_temp == 11'b0101_1001_001||opcode_even_depend_temp == 11'b0000_1000_000||opcode_even_depend_temp == 11'b0110_1000_001||
// opcode_even_depend_temp == 11'b0100_1000_001||opcode_even_depend_temp == 11'b0101_0110_110||opcode_even_depend_temp == 11'b0101_0101_110||opcode_even_depend_temp == 11'b0101_0100_110)
// opcode_even_depend_lat = 3'd2;  
// else if(opcode_even_depend_temp == 11'b0000_1111_011|| opcode_even_depend_temp == 11'b0000_1011_000|| opcode_even_depend_temp == 11'b0000_1011_001||opcode_even_depend_temp == 11'b0000_1011_011||
// opcode_even_depend_temp == 11'b0101_0110_100||opcode_even_depend_temp == 11'b0000_1010_011||opcode_even_depend_temp == 11'b0001_1010_011||opcode_even_depend_temp == 11'b0100_1010_011)
// opcode_even_depend_lat = 3'd4;
// else if(opcode_even_depend_temp == 4'b1110_||opcode_even_depend_temp == 4'b1111_||opcode_even_depend_temp == 11'b0101_1000_100||opcode_even_depend_temp == 11'b0101_1000_110||opcode_even_depend_temp == 11'b0101_1000_101)
// opcode_even_depend_lat = 3'd6;
// else if (opcode_even_depend_temp == 4'b1100_|| opcode_even_depend_temp == 8'b0111_0100|| opcode_even_depend_temp == 8'b0111_0101||opcode_even_depend_temp == 11'b0111_1000_100|| opcode_even_depend_temp == 11'b0111_1000_111||opcode_even_depend_temp == 11'b0111_1001_100)
// opcode_even_depend_lat = 3'd7;
// else opcode_even_depend_lat = 3'd0;


// if(opcode_odd_depend_temp == 11'b0011_1011_101||opcode_odd_depend_temp == 11'b0011_1011_111||opcode_odd_depend_temp == 9'b0011_0001_0||opcode_odd_depend_temp == 9'b0011_0011_0||
// opcode_odd_depend_temp == 9'b0011_0010_0||opcode_odd_depend_temp == 9'b0011_0000_0||opcode_odd_depend_temp == 11'b0011_0101_000||opcode_odd_depend_temp == 11'b0011_0101_001||
// opcode_odd_depend_temp == 9'b0010_0001_0||opcode_odd_depend_temp == 9'b0010_0000_0)
// opcode_odd_depend_lat = 3'd4;
// else if (opcode_odd_depend_temp == 9'b0011_0000_1||opcode_odd_depend_temp == 9'b0010_0000_1||opcode_odd_depend_temp == 11'b0011_1000_100||opcode_odd_depend_temp == 11'b0010_1000_100)
// opcode_odd_depend_lat = 3'd6;
// else opcode_odd_depend_lat = 3'd0;

// end // always_comb



// always_comb begin 

// $display("========================= > addr_even_rb: %d | Rt_Temp_odd:%d",addr_even_rb, Rt_Temp_odd [7:14]);

// if (((addr_even_ra!=7'b0) && (addr_even_ra == addr_even_rt_depend_temp)) || 
//         ((addr_even_rb!=7'b0) && (addr_even_rb == addr_even_rt_depend_temp)) || 
//         ((addr_even_rc!=7'b0) && (addr_even_rc == addr_even_rt_depend_temp)) || 
//         ((addr_odd_ra!=7'b0) && (addr_odd_ra == addr_even_rt_depend_temp)) || 
//         ((addr_odd_rb!=7'b0) && (addr_odd_rb == addr_even_rt_depend_temp)) || 
//         ((addr_odd_rc!=7'b0) && (addr_odd_rc == addr_even_rt_depend_temp))) begin
//         count=opcode_even_depend_lat-1; $display("1st EVEN If - Data Hazard"); 
//     end 

// else if (((addr_even_ra!=7'b0) && (addr_even_ra == Rt_Temp_even [7:14])) || 
//         ((addr_even_rb!=7'b0) && (addr_even_rb == Rt_Temp_even [7:14])) || 
//         ((addr_even_rc!=7'b0) && (addr_even_rc == Rt_Temp_even [7:14])) || 
//         ((addr_odd_ra!=7'b0) && (addr_odd_ra == Rt_Temp_even [7:14])) || 
//         ((addr_odd_rb!=7'b0) && (addr_odd_rb == Rt_Temp_even [7:14])) || 
//         ((addr_odd_rc!=7'b0) && (addr_odd_rc == Rt_Temp_even [7:14]))) begin
//         count=Rt_Temp_even[3:5]-2; $display("2st EVEN If - Data Hazard"); 
//     end

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp1_even [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp1_even [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp1_even [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp1_even [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp1_even [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp1_even [7:14]))) begin
//         count=Rt_Temp1_even[3:5]-3; $display("3nd EVEN If - Data Hazard"); end

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp2_even [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp2_even [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp2_even [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp2_even [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp2_even [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp2_even [7:14]))) begin
//         count=Rt_Temp2_even[3:5]-4; $display("4rd EVEN If - Data Hazard"); end

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp3_even [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp3_even [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp3_even [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp3_even [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp3_even [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp3_even [7:14]))) begin
//         count=Rt_Temp3_even[3:5]-5; $display("5th EVEN If - Data Hazard"); end

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp4_even [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp4_even [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp4_even [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp4_even [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp4_even [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp4_even [7:14]))) begin
//         count=Rt_Temp4_even[3:5]-6; $display("6th EVEN If - Data Hazard"); end

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp5_even [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp5_even [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp5_even [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp5_even [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp5_even [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp5_even [7:14]))) begin
//         count=Rt_Temp5_even[3:5]-7; $display("7th EVEN If - Data Hazard"); end

// // else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp6_even [7:14])) || 
// //         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp6_even [7:14])) || 
// //         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp6_even [7:14])) || 
// //         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp6_even [7:14])) || 
// //         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp6_even [7:14])) || 
// //         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp6_even [7:14]))) begin
// //         count=Rt_Temp6_even[3:5]-7; $display("8th EVEN If - Data Hazard"); end

// // ------------------------------------------------------------------------------------- 

// else if (((addr_even_ra!=7'b0) && (addr_even_ra == addr_odd_rt_depend_temp)) || 
//         ((addr_even_rb!=7'b0) && (addr_even_rb == addr_odd_rt_depend_temp)) || 
//         ((addr_even_rc!=7'b0) && (addr_even_rc == addr_odd_rt_depend_temp)) || 
//         ((addr_odd_ra!=7'b0) && (addr_odd_ra == addr_odd_rt_depend_temp)) || 
//         ((addr_odd_rb!=7'b0) && (addr_odd_rb == addr_odd_rt_depend_temp)) || 
//         ((addr_odd_rc!=7'b0) && (addr_odd_rc == addr_odd_rt_depend_temp))) begin
//         count=opcode_odd_depend_lat-1; $display("1st ODD If - Data Hazard" ); 
//     end 

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp_odd [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp_odd [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp_odd [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp_odd [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp_odd [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp_odd [7:14]))) begin
//         count=Rt_Temp_odd[3:5]-2; $display("2st ODD If - Data Hazard"); end

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp1_odd [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp1_odd [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp1_odd [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp1_odd [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp1_odd [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp1_odd [7:14]))) begin
//         count=Rt_Temp1_odd[3:5]-3; $display("3nd ODD If - Data Hazard"); end

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp2_odd [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp2_odd [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp2_odd [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp2_odd [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp2_odd [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp2_odd [7:14]))) begin
//         count=Rt_Temp2_odd[3:5]-4; $display("4rd ODD If - Data Hazard"); end

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp3_odd [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp3_odd [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp3_odd [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp3_odd [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp3_odd [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp3_odd [7:14]))) begin
//         count=Rt_Temp3_odd[3:5]-5; $display("5th ODD If - Data Hazard"); end

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp4_odd [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp4_odd [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp4_odd [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp4_odd [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp4_odd [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp4_odd [7:14]))) begin
//         count=Rt_Temp4_odd[3:5]-6; $display("6th ODD If - Data Hazard"); end

// else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp5_odd [7:14])) || 
//         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp5_odd [7:14])) || 
//         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp5_odd [7:14])) || 
//         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp5_odd [7:14])) || 
//         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp5_odd [7:14])) || 
//         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp5_odd [7:14]))) begin
//         count=Rt_Temp5_odd[3:5]-7; $display("7th ODD If - Data Hazard"); end

// // else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp6_odd [7:14])) || 
// //         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp6_odd [7:14])) || 
// //         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp6_odd [7:14])) || 
// //         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp6_odd [7:14])) || 
// //         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp6_odd [7:14])) || 
// //         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp6_odd [7:14]))) begin
// //         count=Rt_Temp6_odd[3:5]-7; $display("7th ODD If - Data Hazard"); end

// else
//     count=0;
// end 


// //always_ff@(posedge clk) begin $display("@ DEPENDENCY Rt_Temp_even: %d",Rt_Temp_even[0:2]); end


// endmodule


// // -------------- 1st Backup

// // always_ff @(posedge clk) begin
// //     $display("Counter:%d, Count:%d ", counter, count);
// //   if(count == 1) counter <= 1;
// //   else if (count == 2 ) counter <= 2;
// //   else if (count == 3 ) counter <= 3;
// //   else if (count == 4 ) counter <= 4;
// //   else if (count == 5 ) counter <= 5;
// //   else if (count == 6 ) counter <= 6;
// //   else counter <= 0;

// //   if(count == 0 && counter > 0) begin
// //     counter <= counter - 1; //$display("--------------------------------------------------------------------->>> Data Hazard");
// //     Dependency_stall = 1;
// //     opcode_even_depend = 11'b0100_0000_001; 
// //     opcode_odd_depend = 11'b0100_0000_010; 
// //     end
  

// //   else if(count == 0 && counter == 0) begin
// //     //$display("--------------------------------------------------------------------->>> No Data Hazard, Counter:%d, Count:%d ", counter, count);
// //     $display ("opcode_even: %b | @ Dependency Stge" , opcode_even_depend);
// //     $display ("opcode_odd: %b | @ Dependency Stage", opcode_odd_depend);
    
// //     Dependency_stall = 0; 
// //     addr_even_ra_depend<=addr_even_ra;
// //     addr_even_rb_depend<=addr_even_rb;
// //     addr_even_rc_depend<=addr_even_rc;
// //     opcode_even_depend <= opcode_even; addr_even_rt_depend <= addr_even_rt;
// //     imm7_even_depend <= imm7_even; imm10_even_depend <= imm10_even; 
// //     imm16_even_depend <= imm16_even; imm18_even_depend <= imm18_even;

// //     addr_odd_ra_depend<=addr_odd_ra;
// //     addr_odd_rb_depend<=addr_odd_rb;
// //     addr_odd_rc_depend<=addr_odd_rc;
// //     opcode_odd_depend <= opcode_odd; addr_odd_rt_depend <= addr_odd_rt;
// //     imm7_odd_depend <= imm7_odd; imm10_odd_depend <= imm10_odd; 
// //     imm16_odd_depend <= imm16_odd; imm18_odd_depend <= imm18_odd; 

// // // ----------------------------------- For Latency Calculation @ Reg File

// //     opcode_even_depend_temp  <= opcode_even;
// //     addr_even_rt_depend_temp <= addr_even_rt;
// //     opcode_odd_depend_temp   <= opcode_odd;
// //     addr_odd_rt_depend_temp  <= addr_odd_rt;

// //   end
// // end


// // ---------------- 2nd Backup

// //===================================================Dependency==========================================================

// // module Dependency (clk, reset,addr_even_ra, addr_even_rb, addr_even_rc, opcode_even, imm10_even, imm16_even, imm18_even, imm7_even, addr_even_rt,
// // addr_odd_ra, addr_odd_rb, addr_odd_rc, opcode_odd, imm10_odd, imm16_odd, imm18_odd, imm7_odd, addr_odd_rt, flush,opcode_even_depend, imm7_even_depend, imm10_even_depend, imm16_even_depend, imm18_even_depend, addr_even_rt_depend, addr_even_ra_depend, addr_even_rb_depend, addr_even_rc_depend , opcode_odd_depend,imm7_odd_depend,imm10_odd_depend,imm16_odd_depend,imm18_odd_depend,addr_odd_rt_depend,addr_odd_ra_depend, addr_odd_rb_depend, addr_odd_rc_depend, Dependency_stall, Rt_Temp_even, Rt_Temp1_even, Rt_Temp2_even, Rt_Temp3_even, Rt_Temp4_even, Rt_Temp5_even, Rt_Temp6_even, Rt_Temp_odd, Rt_Temp1_odd, Rt_Temp2_odd, Rt_Temp3_odd, Rt_Temp4_odd, Rt_Temp5_odd, Rt_Temp6_odd);

// // input clk, reset, flush;
// // input [0:6] addr_even_ra, addr_even_rb, addr_even_rc;  
// // input [0:6] addr_odd_ra, addr_odd_rb, addr_odd_rc;  
// // input [0:10] opcode_even;              
// // input signed [0:6] imm7_even;          
// // input signed [0:9] imm10_even;         
// // input signed [0:15] imm16_even;        
// // input signed [0:17] imm18_even;        
// // input [0:6] addr_even_rt;              
// // input [0:142] Rt_Temp_even, Rt_Temp1_even, Rt_Temp2_even, Rt_Temp3_even, Rt_Temp4_even, Rt_Temp5_even, Rt_Temp6_even;


// // output logic [0:10] opcode_even_depend;         
// // output logic signed [0:6] imm7_even_depend;           
// // output logic signed [0:9] imm10_even_depend;          
// // output logic signed [0:15] imm16_even_depend;        
// // output logic signed [0:17] imm18_even_depend;         
// // output logic [0:6] addr_even_rt_depend;         
// // output logic [0:6] addr_even_ra_depend, addr_even_rb_depend, addr_even_rc_depend; 

// // input [0:10] opcode_odd;       
// // input [0:6] imm7_odd;          
// // input [0:9] imm10_odd;         
// // input [0:15] imm16_odd;        
// // input [0:17] imm18_odd;        
// // input [0:6] addr_odd_rt;                 
// // input [0:175] Rt_Temp_odd, Rt_Temp1_odd, Rt_Temp2_odd, Rt_Temp3_odd, Rt_Temp4_odd, Rt_Temp5_odd, Rt_Temp6_odd; 


// // output logic [0:10] opcode_odd_depend;            
// // output logic signed [0:6] imm7_odd_depend;                
// // output logic signed [0:9] imm10_odd_depend;              
// // output logic signed [0:15] imm16_odd_depend;             
// // output logic signed [0:17] imm18_odd_depend;                 
// // output logic signed [0:6] addr_odd_rt_depend;   
// // output logic [0:6] addr_odd_ra_depend, addr_odd_rb_depend, addr_odd_rc_depend; 

// // logic [0:10] opcode_odd_depend2, opcode_even_depend2 ;       

// // output logic Dependency_stall;

// // logic [0:10] opcode_even_depend_temp, opcode_odd_depend_temp;
// // logic [0:6] addr_even_rt_depend_temp, addr_odd_rt_depend_temp;
// // logic [0:2] opcode_even_depend_lat, opcode_odd_depend_lat;
// // logic [0:2] count, counter;


// // assign Dependency_stall = (counter > 0);

// // always_comb begin
// //     if (Dependency_stall) begin
// //     opcode_even_depend = 11'b0100_0000_001; 
// //     opcode_odd_depend = 11'b0100_0000_010; end

// //     else begin 
// //         opcode_even_depend = opcode_even_depend2;
// //         opcode_odd_depend = opcode_odd_depend2;end
// // end

// // always_ff @(posedge clk) begin
// //     $display("Counter:%d, Count:%d ", counter, count);
  
// //   if(counter > 0) begin // count == 0 && 
// //     counter = counter - 1; $display("---------------------------------------|||||||||||||------------------------------>>> Data Hazard");
// //     //Dependency_stall = 1;
// //     // opcode_even_depend = 11'b0100_0000_001; 
// //     // opcode_odd_depend = 11'b0100_0000_010; 
// //     end

// //   else if(count == 1) counter <= 0;
// //   else if (count == 2 ) counter <= 1;
// //   else if (count == 3 ) counter <= 2;
// //   else if (count == 4 ) counter <= 3;
// //   else if (count == 5 ) counter <= 4;
// //   else if (count == 6 ) counter <= 5;

// //   else if(count == 0 && counter == 0) begin
// //     //$display("--------------------------------------------------------------------->>> No Data Hazard, Counter:%d, Count:%d ", counter, count);    
// //     //Dependency_stall = 0; 
// //     addr_even_ra_depend<=addr_even_ra;
// //     addr_even_rb_depend<=addr_even_rb;
// //     addr_even_rc_depend<=addr_even_rc;
// //     opcode_even_depend2 <= opcode_even; addr_even_rt_depend <= addr_even_rt;
// //     imm7_even_depend <= imm7_even; imm10_even_depend <= imm10_even; 
// //     imm16_even_depend <= imm16_even; imm18_even_depend <= imm18_even;

// //     addr_odd_ra_depend<=addr_odd_ra;
// //     addr_odd_rb_depend<=addr_odd_rb;
// //     addr_odd_rc_depend<=addr_odd_rc;
// //     opcode_odd_depend2 <= opcode_odd; addr_odd_rt_depend <= addr_odd_rt;
// //     imm7_odd_depend <= imm7_odd; imm10_odd_depend <= imm10_odd; 
// //     imm16_odd_depend <= imm16_odd; imm18_odd_depend <= imm18_odd; 

// // // ----------------------------------- For Latency Calculation @ Reg File

// //     opcode_even_depend_temp  <= opcode_even;
// //     addr_even_rt_depend_temp <= addr_even_rt;
// //     opcode_odd_depend_temp   <= opcode_odd;
// //     addr_odd_rt_depend_temp  <= addr_odd_rt;

// //   end

// //   else counter <= 0;
  
// //     $display ("opcode_even: %b | @ Dependency Stge" , opcode_even_depend);
// //     $display ("opcode_odd: %b | @ Dependency Stage", opcode_odd_depend);
// // end




// // always_comb begin 
// // if (opcode_even_depend_temp == 7'b0100_001||opcode_even_depend_temp == 8'b0001_1100||opcode_even_depend_temp == 8'b0001_0110||opcode_even_depend_temp == 8'b0111_1110||
// // opcode_even_depend_temp == 8'b0111_1100||opcode_even_depend_temp == 8'b0100_1110||opcode_even_depend_temp == 8'b0100_1100||opcode_even_depend_temp == 8'b0101_1110||
// // opcode_even_depend_temp == 8'b0000_0100||opcode_even_depend_temp == 8'b0000_1100||opcode_even_depend_temp == 8'b0100_0110||opcode_even_depend_temp == 8'b0100_0100||
// // opcode_even_depend_temp == 9'b0100_0000_1||opcode_even_depend_temp == 9'b0100_0001_1||opcode_even_depend_temp == 11'b0001_1000_000||opcode_even_depend_temp == 11'b1101_0000_000||
// // opcode_even_depend_temp == 11'b0001_1000_001||opcode_even_depend_temp == 11'b0101_1000_001||opcode_even_depend_temp == 11'b0111_1000_000||opcode_even_depend_temp == 11'b0111_1010_000||
// // opcode_even_depend_temp == 11'b0100_1010_000||opcode_even_depend_temp == 11'b0101_1010_000||opcode_even_depend_temp == 11'b0001_1001_001||opcode_even_depend_temp == 11'b0000_1001_001||
// // opcode_even_depend_temp == 11'b0000_1000_001||opcode_even_depend_temp == 11'b0101_1001_001||opcode_even_depend_temp == 11'b0000_1000_000||opcode_even_depend_temp == 11'b0110_1000_001||
// // opcode_even_depend_temp == 11'b0100_1000_001||opcode_even_depend_temp == 11'b0101_0110_110||opcode_even_depend_temp == 11'b0101_0101_110||opcode_even_depend_temp == 11'b0101_0100_110)
// // opcode_even_depend_lat = 3'd2;  
// // else if(opcode_even_depend_temp == 11'b0000_1111_011|| opcode_even_depend_temp == 11'b0000_1011_000|| opcode_even_depend_temp == 11'b0000_1011_001||opcode_even_depend_temp == 11'b0000_1011_011||
// // opcode_even_depend_temp == 11'b0101_0110_100||opcode_even_depend_temp == 11'b0000_1010_011||opcode_even_depend_temp == 11'b0001_1010_011||opcode_even_depend_temp == 11'b0100_1010_011)
// // opcode_even_depend_lat = 3'd4;
// // else if(opcode_even_depend_temp == 4'b1110_||opcode_even_depend_temp == 4'b1111_||opcode_even_depend_temp == 11'b0101_1000_100||opcode_even_depend_temp == 11'b0101_1000_110||opcode_even_depend_temp == 11'b0101_1000_101)
// // opcode_even_depend_lat = 3'd6;
// // else if (opcode_even_depend_temp == 4'b1100_|| opcode_even_depend_temp == 8'b0111_0100|| opcode_even_depend_temp == 8'b0111_0101||opcode_even_depend_temp == 11'b0111_1000_100|| opcode_even_depend_temp == 11'b0111_1000_111||opcode_even_depend_temp == 11'b0111_1001_100)
// // opcode_even_depend_lat = 3'd7;
// // else opcode_even_depend_lat = 3'd0;


// // if(opcode_odd_depend_temp == 11'b0011_1011_101||opcode_odd_depend_temp == 11'b0011_1011_111||opcode_odd_depend_temp == 9'b0011_0001_0||opcode_odd_depend_temp == 9'b0011_0011_0||
// // opcode_odd_depend_temp == 9'b0011_0010_0||opcode_odd_depend_temp == 9'b0011_0000_0||opcode_odd_depend_temp == 11'b0011_0101_000||opcode_odd_depend_temp == 11'b0011_0101_001||
// // opcode_odd_depend_temp == 9'b0010_0001_0||opcode_odd_depend_temp == 9'b0010_0000_0)
// // opcode_odd_depend_lat = 3'd4;
// // else if (opcode_odd_depend_temp == 9'b0011_0000_1||opcode_odd_depend_temp == 9'b0010_0000_1||opcode_odd_depend_temp == 11'b0011_1000_100||opcode_odd_depend_temp == 11'b0010_1000_100)
// // opcode_odd_depend_lat = 3'd6;
// // else opcode_odd_depend_lat = 3'd0;

// // end // always_comb



// // always_comb begin 

// // $display("========================= > addr_even_rb: %d | Rt_Temp_odd:%d",addr_even_rb, Rt_Temp_odd [7:14]);

// // if (((addr_even_ra!=7'b0) && (addr_even_ra == addr_even_rt_depend_temp)) || 
// //         ((addr_even_rb!=7'b0) && (addr_even_rb == addr_even_rt_depend_temp)) || 
// //         ((addr_even_rc!=7'b0) && (addr_even_rc == addr_even_rt_depend_temp)) || 
// //         ((addr_odd_ra!=7'b0) && (addr_odd_ra == addr_even_rt_depend_temp)) || 
// //         ((addr_odd_rb!=7'b0) && (addr_odd_rb == addr_even_rt_depend_temp)) || 
// //         ((addr_odd_rc!=7'b0) && (addr_odd_rc == addr_even_rt_depend_temp))) begin
// //         count=opcode_even_depend_lat-1; $display("1st EVEN If - Data Hazard"); 
// //     end 

// // else if (((addr_even_ra!=7'b0) && (addr_even_ra == Rt_Temp_even [7:14])) || 
// //         ((addr_even_rb!=7'b0) && (addr_even_rb == Rt_Temp_even [7:14])) || 
// //         ((addr_even_rc!=7'b0) && (addr_even_rc == Rt_Temp_even [7:14])) || 
// //         ((addr_odd_ra!=7'b0) && (addr_odd_ra == Rt_Temp_even [7:14])) || 
// //         ((addr_odd_rb!=7'b0) && (addr_odd_rb == Rt_Temp_even [7:14])) || 
// //         ((addr_odd_rc!=7'b0) && (addr_odd_rc == Rt_Temp_even [7:14]))) begin
// //         count=Rt_Temp_even[3:5]-2; $display("2st EVEN If - Data Hazard"); 
// //     end

// // else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp1_even [7:14])) || 
// //         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp1_even [7:14])) || 
// //         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp1_even [7:14])) || 
// //         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp1_even [7:14])) || 
// //         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp1_even [7:14])) || 
// //         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp1_even [7:14]))) begin
// //         count=Rt_Temp1_even[3:5]-3; $display("3nd EVEN If - Data Hazard"); end

// // else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp2_even [7:14])) || 
// //         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp2_even [7:14])) || 
// //         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp2_even [7:14])) || 
// //         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp2_even [7:14])) || 
// //         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp2_even [7:14])) || 
// //         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp2_even [7:14]))) begin
// //         count=Rt_Temp2_even[3:5]-4; $display("4rd EVEN If - Data Hazard"); end

// // else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp3_even [7:14])) || 
// //         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp3_even [7:14])) || 
// //         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp3_even [7:14])) || 
// //         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp3_even [7:14])) || 
// //         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp3_even [7:14])) || 
// //         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp3_even [7:14]))) begin
// //         count=Rt_Temp3_even[3:5]-5; $display("5th EVEN If - Data Hazard"); end

// // else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp4_even [7:14])) || 
// //         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp4_even [7:14])) || 
// //         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp4_even [7:14])) || 
// //         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp4_even [7:14])) || 
// //         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp4_even [7:14])) || 
// //         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp4_even [7:14]))) begin
// //         count=Rt_Temp4_even[3:5]-6; $display("6th EVEN If - Data Hazard"); end

// // else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp5_even [7:14])) || 
// //         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp5_even [7:14])) || 
// //         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp5_even [7:14])) || 
// //         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp5_even [7:14])) || 
// //         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp5_even [7:14])) || 
// //         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp5_even [7:14]))) begin
// //         count=Rt_Temp5_even[3:5]-7; $display("7th EVEN If - Data Hazard"); end

// // // else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp6_even [7:14])) || 
// // //         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp6_even [7:14])) || 
// // //         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp6_even [7:14])) || 
// // //         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp6_even [7:14])) || 
// // //         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp6_even [7:14])) || 
// // //         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp6_even [7:14]))) begin
// // //         count=Rt_Temp6_even[3:5]-7; $display("8th EVEN If - Data Hazard"); end

// // // ------------------------------------------------------------------------------------- 

// // else if (((addr_even_ra!=7'b0) && (addr_even_ra == addr_odd_rt_depend_temp)) || 
// //         ((addr_even_rb!=7'b0) && (addr_even_rb == addr_odd_rt_depend_temp)) || 
// //         ((addr_even_rc!=7'b0) && (addr_even_rc == addr_odd_rt_depend_temp)) || 
// //         ((addr_odd_ra!=7'b0) && (addr_odd_ra == addr_odd_rt_depend_temp)) || 
// //         ((addr_odd_rb!=7'b0) && (addr_odd_rb == addr_odd_rt_depend_temp)) || 
// //         ((addr_odd_rc!=7'b0) && (addr_odd_rc == addr_odd_rt_depend_temp))) begin
// //         count=opcode_odd_depend_lat-1; $display("1st ODD If - Data Hazard" ); 
// //     end 

// // else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp_odd [7:14])) || 
// //         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp_odd [7:14])) || 
// //         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp_odd [7:14])) || 
// //         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp_odd [7:14])) || 
// //         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp_odd [7:14])) || 
// //         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp_odd [7:14]))) begin
// //         count=Rt_Temp_odd[3:5]-2; $display("2st ODD If - Data Hazard"); end

// // else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp1_odd [7:14])) || 
// //         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp1_odd [7:14])) || 
// //         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp1_odd [7:14])) || 
// //         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp1_odd [7:14])) || 
// //         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp1_odd [7:14])) || 
// //         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp1_odd [7:14]))) begin
// //         count=Rt_Temp1_odd[3:5]-3; $display("3nd ODD If - Data Hazard"); end

// // else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp2_odd [7:14])) || 
// //         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp2_odd [7:14])) || 
// //         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp2_odd [7:14])) || 
// //         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp2_odd [7:14])) || 
// //         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp2_odd [7:14])) || 
// //         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp2_odd [7:14]))) begin
// //         count=Rt_Temp2_odd[3:5]-4; $display("4rd ODD If - Data Hazard"); end

// // else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp3_odd [7:14])) || 
// //         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp3_odd [7:14])) || 
// //         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp3_odd [7:14])) || 
// //         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp3_odd [7:14])) || 
// //         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp3_odd [7:14])) || 
// //         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp3_odd [7:14]))) begin
// //         count=Rt_Temp3_odd[3:5]-5; $display("5th ODD If - Data Hazard"); end

// // else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp4_odd [7:14])) || 
// //         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp4_odd [7:14])) || 
// //         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp4_odd [7:14])) || 
// //         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp4_odd [7:14])) || 
// //         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp4_odd [7:14])) || 
// //         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp4_odd [7:14]))) begin
// //         count=Rt_Temp4_odd[3:5]-6; $display("6th ODD If - Data Hazard"); end

// // else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp5_odd [7:14])) || 
// //         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp5_odd [7:14])) || 
// //         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp5_odd [7:14])) || 
// //         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp5_odd [7:14])) || 
// //         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp5_odd [7:14])) || 
// //         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp5_odd [7:14]))) begin
// //         count=Rt_Temp5_odd[3:5]-7; $display("7th ODD If - Data Hazard"); end

// // // else if (((addr_even_ra!=7'bx) && (addr_even_ra == Rt_Temp6_odd [7:14])) || 
// // //         ((addr_even_rb!=7'bx) && (addr_even_rb == Rt_Temp6_odd [7:14])) || 
// // //         ((addr_even_rc!=7'bx) && (addr_even_rc == Rt_Temp6_odd [7:14])) || 
// // //         ((addr_odd_ra!=7'bx) && (addr_odd_ra == Rt_Temp6_odd [7:14])) || 
// // //         ((addr_odd_rb!=7'bx) && (addr_odd_rb == Rt_Temp6_odd [7:14])) || 
// // //         ((addr_odd_rc!=7'bx) && (addr_odd_rc == Rt_Temp6_odd [7:14]))) begin
// // //         count=Rt_Temp6_odd[3:5]-7; $display("7th ODD If - Data Hazard"); end

// // else
// //     count=0;
// // end 


// // //always_ff@(posedge clk) begin $display("@ DEPENDENCY Rt_Temp_even: %d",Rt_Temp_even[0:2]); end


// // endmodule