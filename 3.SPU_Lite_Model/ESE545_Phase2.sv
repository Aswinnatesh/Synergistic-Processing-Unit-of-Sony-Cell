//-----------------------------------------------------------------------------------------------------------------------------//
//-----------------------------------------------------------------------------------------------------------------------------//
// Project Title    : DUAL-ISSUE MULTIMEDIA PROCESSOR ARCHITECTURE                                       ESE 545 [SPRING 2018] //
//                                                                                                                             //
// Project Member 1 : Aswin Natesh Venkatesh    [SBU ID: 111582677]                                                            //
// Project Member 2 : Salome Devkule            [SBU ID: 111678929]                                                            // 
//                                                                                                                             //
// Submission Date  : March 18, 2018                                                                                           //
//-----------------------------------------------------------------------------------------------------------------------------//
//-----------------------------------------------------------------------------------------------------------------------------//

//=================================================== PARAMETERIZATION  =========================================================

parameter SIMPLE_FIXED1_UNIT      =1;     parameter SIMPLE_FIXED1_LATENCY      =2;
parameter SIMPLE_FIXED2_UNIT      =2;     parameter SIMPLE_FIXED2_LATENCY      =4;
parameter SINGLE_PRECISION1_UNIT  =3;     parameter SINGLE_PRECISION1_LATENCY  =6;
parameter SINGLE_PRECISION2_UNIT  =3;     parameter SINGLE_PRECISION2_LATENCY  =7;
parameter BYTE_UNIT               =4;     parameter BYTE_LATENCY               =4;
parameter PERMUTE_UNIT            =5;     parameter PERMUTE_LATENCY            =4; 
parameter LOCALSTORE_UNIT         =6;     parameter LOCALSTORE_LATENCY         =6; 
parameter BRANCH_UNIT             =7;     parameter BRANCH_LATENCY             =4;

//====================================================  REGISTER FILE  ==========================================================

module reg_file (clk, reset, addr_even_ra, addr_even_rb, addr_even_rc, opcode_even, imm10_even, imm16_even, imm18_even, imm7_even, addr_even_rt, addr_odd_ra, addr_odd_rb, addr_odd_rc, opcode_odd, imm10_odd, imm16_odd, imm18_odd, imm7_odd, addr_odd_rt, Even_Test_Packet, Odd_Test_Packet, Pc_in, flush);

    // Input to REG File for Processing
     input clk, reset;
     input [0:7] addr_even_ra, addr_even_rb, addr_even_rc;  
     input [0:7] addr_odd_ra, addr_odd_rb, addr_odd_rc;   
     output [0:136] Even_Test_Packet;   //Packet Data Sent to Testbench for Verication Purpose
     output [0:168] Odd_Test_Packet;	  //Packet Data Sent to Testbench for Verication Purpose
    
    // Even Pipe Forwarding and Data Stuff
    input [0:10] opcode_even;              // Input from TB
    input signed [0:6] imm7_even;          // logic from TB
    input signed [0:9] imm10_even;         // logic from TB
    input signed [0:15] imm16_even;        // logic from TB
    input signed [0:17] imm18_even;        // logic from TB
    input [0:7] addr_even_rt;              // Input from TB
    logic [0:7] addr_even_rt2;             // Receiving from Even Pipe
    logic signed [0:127] data_even_rt;     // Receiving from Even Pipe
    logic wr_en_even;                      // Receiving from Even Pipe
    logic signed [0:127] data_even_ra, data_even_rb, data_even_rc;  // Data to Even Pipe
    logic [0:10] opcode_even_fwd;			   // Forward Reg for 1 Cycle Delay
    logic signed [0:6] imm7_even_fwd;          // Forward Reg for 1 Cycle Delay 
    logic signed [0:9] imm10_even_fwd;         // Forward Reg for 1 Cycle Delay 
    logic signed [0:15] imm16_even_fwd;        // Forward Reg for 1 Cycle Delay 
    logic signed [0:17] imm18_even_fwd;        // Forward Reg for 1 Cycle Delay 
    logic [0:7] addr_even_rt_fwd;			   // Forward Reg for 1 Cycle Delay			 	 
 
    // Odd Pipe Forwarding and Data Stuff
    input flush;
    input [0:10] opcode_odd;       // Input from TB
    input [0:6] imm7_odd;          // logic from TB
    input [0:9] imm10_odd;         // logic from TB
    input [0:15] imm16_odd;        // logic from TB
    input [0:17] imm18_odd;        // logic from TB
    input [0:7] addr_odd_rt;       // Input from TB
    input [0:31] Pc_in;            // Input from TB
    logic [0:7] addr_odd_rt2;      // Receiving from odd Pipe
    logic [0:127] data_odd_rt;     // Receiving from odd Pipe
    logic [0:31] Pc_out_2;    
    logic wr_en_odd, flush_fwd;               // Receiving from odd Pipe

    logic [0:127] data_odd_ra, data_odd_rb, data_odd_rc; // Data to odd Pipe
    logic [0:10] opcode_odd_fwd;			      // Forward Reg for 1 Cycle Delay
    logic [0:6] imm7_odd_fwd;               // Forward Reg for 1 Cycle Delay 
    logic [0:9] imm10_odd_fwd;              // Forward Reg for 1 Cycle Delay 
    logic [0:15] imm16_odd_fwd;             // Forward Reg for 1 Cycle Delay 
    logic [0:17] imm18_odd_fwd;             // Forward Reg for 1 Cycle Delay 	 
    logic [0:7] addr_odd_rt_fwd;			      // Forward Reg for 1 Cycle Delay
    logic [0:31] Pc_in_fwd;                 // Forward Reg for 1 Cycle Delay


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
                        .wr_en_even(wr_en_even));                      // Output Receiving

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
                        .flush(flush_fwd));			    		// Flush Signal from TB		




     logic [0:127][0:127] mem;     

     assign Even_Test_Packet = {data_even_rt, addr_even_rt2, wr_en_even}; 
     assign Odd_Test_Packet = {data_odd_rt, addr_odd_rt2,  wr_en_odd, Pc_out_2};
 
     always_ff @(posedge clk) begin
        if(reset) begin 
            integer i; 
            for (i=0; i<124; i=i+1)
            mem[i] = i;
        		mem[124]=32'h408ccccd;
		    		mem[125]=128'd79228162532711081671548469249;
		    		mem[126]=128'd170808406006153739902585569290863280256;
        		mem[127]=128'd170808403787765189503184116671632670848;

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

    always_ff @(posedge clk) begin
        data_even_ra <= mem[addr_even_ra];
        data_even_rb <= mem[addr_even_rb];
        data_even_rc <= mem[addr_even_rc];

        data_odd_ra <= mem[addr_odd_ra];
        data_odd_rb <= mem[addr_odd_rb];
        data_odd_rc <= mem[addr_odd_rc];
     end

    always_ff @(posedge clk) begin       // Instruction Forward to Pipes
    	opcode_even_fwd <= opcode_even; addr_even_rt_fwd <= addr_even_rt;
      imm7_even_fwd <= imm7_even; imm10_even_fwd <= imm10_even; 
      imm16_even_fwd <= imm16_even; imm18_even_fwd <= imm18_even; 
      
      opcode_odd_fwd <= opcode_odd; addr_odd_rt_fwd <= addr_odd_rt;
      imm7_odd_fwd <= imm7_odd; imm10_odd_fwd <= imm10_odd; 
      imm16_odd_fwd <= imm16_odd; imm18_odd_fwd <= imm18_odd; 
      Pc_in_fwd <= Pc_in;  flush_fwd <= flush;
     end

endmodule

//====================================================    EVEN PIPE    ========================================================

module evenpipe(clk, reset, opcode_even, data_even_ra, data_even_rb, data_even_rc, imm7_even, imm10_even, imm16_even, imm18_even, addr_even_rt, data_even_rt, addr_even_rt2, wr_en_even); 

input clk, reset;
input [0:7] addr_even_rt;
input [0:10] opcode_even;
input signed [0:6] imm7_even;          // logic from TB
input signed [0:9] imm10_even;         // logic from TB
input signed [0:15] imm16_even;        // logic from TB
input signed [0:17] imm18_even;        // logic from TB
input signed [0:127] data_even_ra, data_even_rb, data_even_rc;
output logic signed [0:127] data_even_rt;
output logic [0:7] addr_even_rt2;
output logic wr_en_even;

logic firstbit, wr_en, stop;
logic signed [0:142] Rt_Temp, Rt_Temp1, Rt_Temp2, Rt_Temp3, Rt_Temp4, Rt_Temp5, Rt_Temp6, Rt_Temp7;
logic signed [0:31]temp_imm10, temp_imm;
logic signed [0:127] Rt; 
logic [0:2] count;
logic [0:3] latency_temp, unit_temp, latency, unit;
logic [0:7] b, ra_byte;
logic [0:31] bbbb, rb_word;
logic [0:63] shift_count;
logic [0:127] rt_temp;

  always_comb begin
      case(opcode_even)

    //1. Add Word
      11'b00011000000:begin                                      
		Rt[0:31]=data_even_ra[0:31]+data_even_rb[0:31];
		Rt[32:63]=data_even_ra[32:63]+data_even_rb[32:63];
		Rt[64:95]=data_even_ra[64:95]+data_even_rb[64:95];
		Rt[96:127]=data_even_ra[96:127]+data_even_rb[96:127];
		wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;
		end 
      
    //2.Add extended word			
  	  11'b01101000000:begin 
		for(int i=0; i<4; i=i+1)
		Rt[(i*32)+: 32]=data_even_ra[(i*32)+: 32] + data_even_rb[(i*32)+: 32] + data_even_rc[(i*32)+: 32]; 
		wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;
		end 
		
	  //3. Add word immediate
      11'b00011100:begin                                            
		firstbit = imm10_even[0];
		temp_imm10 = {{22{firstbit}},imm10_even};
		Rt[0:31]=data_even_ra[0:31]+temp_imm10;
		Rt[32:63]=data_even_ra[32:63]+temp_imm10;
		Rt[64:95]=data_even_ra[64:95]+temp_imm10;
		Rt[96:127]=data_even_ra[96:127]+temp_imm10;
		wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;
		end 

	  //4. And
      11'b00011000001:begin 
		Rt[0:31]=data_even_ra[0:31] & data_even_rb[0:31];
		Rt[32:63]=data_even_ra[32:63] & data_even_rb[32:63];
		Rt[64:95]=data_even_ra[64:95] & data_even_rb[64:95];
		Rt[96:127]=data_even_ra[96:127] & data_even_rb[96:127];  
		wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;
		end 						

	  //5. And Byte Imm
      11'b00010110:begin 
		b = imm10_even & 8'hff;
		bbbb = {b,b,b,b};
		Rt[0:31]=data_even_ra[0:31] & bbbb;
		Rt[32:63]=data_even_ra[32:63] & bbbb;
		Rt[64:95]=data_even_ra[64:95] & bbbb;
		Rt[96:127]=data_even_ra[96:127] & bbbb;  
		wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;
		end 						

	  //6. And with Complement
      11'b01011000001:begin 
		Rt[0:31]=data_even_ra[0:31] & ~(data_even_rb[0:31]);
		Rt[32:63]=data_even_ra[32:63] & ~(data_even_rb[32:63]);
		Rt[64:95]=data_even_ra[64:95] & ~(data_even_rb[64:95]);
		Rt[96:127]=data_even_ra[96:127] & ~(data_even_rb[96:127]);
		wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;  
		end 

      //7. compare equal word
      11'b01111000000:begin
          for(int i=0; i<4; i=i+1)begin
          if((data_even_ra[(i*32)+: 32])==(data_even_rb[(i*32)+: 32]))
          Rt[(i*32)+: 32]='1;
          else Rt[(i*32)+: 32]='0; end
          wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY; 
      end

      //8. compare equal byte
      11'b01111010000:begin
          for(int i=0; i<16; i=i+1)begin
          if((data_even_ra[(i*8)+: 8])==(data_even_rb[(i*8)+: 8]))
          Rt[(i*8)+: 8]='1;
          else Rt[(i*8)+: 8]='0; end
          wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;
      end

      //9. compare equal byte immediate
      11'b01111110:begin
          b = imm10_even & 8'hff;
          for(int i=0; i<16; i=i+1)begin
          if((data_even_ra[(i*8)+: 8])==b)
          Rt[(i*8)+: 8]='1;
          else Rt[(i*8)+: 8]='0; end
          wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;
      end

      //10. compare equal word immediate
      11'b01111100:begin
          firstbit = imm10_even[0];
          temp_imm10 = {{22{firstbit}},imm10_even};
          for(int i=0; i<4; i=i+1)begin
          if((data_even_ra[(i*32)+: 32])==temp_imm10)
          Rt[(i*32)+: 32]='1;
          else Rt[(i*32)+: 32]='0; end
          wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;
      end

      //11. compare greater than byte
      11'b01001010000:begin
          for(int i=0; i<16; i=i+1)begin
          if((data_even_ra[(i*8)+: 8])>(data_even_rb[(i*8)+: 8]))
          Rt[(i*8)+: 8]='1;
          else Rt[(i*8)+: 8]='0; end
          wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;
      end

      //12. compare greater byte immediate
      11'b01001110:begin
          b = imm10_even & 8'hff;
          for(int i=0; i<16; i=i+1)begin
          if(data_even_ra[(i*8)+: 8]> b)
          Rt[(i*8)+: 8]='1; else
          Rt[(i*8)+: 8]='0; end
          wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;
      end


      //13. compare greater than word immediate
      11'b01001100:begin
          firstbit = imm10_even[0];
          temp_imm10 = {{22{firstbit}},imm10_even};
          for(int i=0; i<4; i=i+1)begin
          if((data_even_ra[(i*32)+: 32])>temp_imm10)
          Rt[(i*32)+: 32]='1;
          else Rt[(i*32)+: 32]='0; end
          wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;
      end

      //14. compare logical greater than byte
      11'b01011010000:begin
          for(int i=0; i<16; i=i+1)begin
          if($unsigned(data_even_ra[(i*8)+: 8])>$unsigned(data_even_rb[(i*8)+: 8]))
          Rt[(i*8)+: 8]='1;
          else Rt[(i*8)+: 8]='0; end
          wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;
      end

      //15. compare logical greater byte immediate
      11'b00001011110:begin 
          b = $unsigned(imm10_even) & 8'hff;
          for(int i=0; i<16; i=i+1)begin
          if($unsigned(data_even_ra[(i*8)+: 8])> b)
          Rt[(i*8)+: 8]='1;
          else Rt[(i*8)+: 8]='0; end
          wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;
      end

      //16. Immediate load word
      11'b010000001:begin
          firstbit = imm16_even[0];
          temp_imm = {{16{firstbit}},imm16_even};
          Rt[0:31]=temp_imm; Rt[32:63]=temp_imm;
          Rt[64:95]=temp_imm; Rt[96:127]=temp_imm;
          wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;
      end 

      //17. Immediate load address
      11'b0100001:begin 
          Rt[0:31]=imm18_even; Rt[32:63]=imm18_even;
          Rt[64:95]=imm18_even; Rt[96:127]=imm18_even;
          wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;
      end 

    //18. Immediate load halfword
    11'b010000011:begin 
          Rt[0:15]=imm16_even; Rt[16:31]=imm16_even;
          Rt[32:47]=imm16_even; Rt[48:63]=imm16_even;
          Rt[64:79]=imm16_even; Rt[80:95]=imm16_even;
          Rt[96:111]=imm16_even; Rt[112:127]=imm16_even;
          wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;
    end

    //19. Nand
    11'b00011001001:begin        
          Rt[0:31]=~(data_even_ra[0:31] & data_even_rb[0:31]);
          Rt[32:63]=~(data_even_ra[32:63] & data_even_rb[32:63]);
          Rt[64:95]=~(data_even_ra[64:95] & data_even_rb[64:95]);
          Rt[96:127]=~(data_even_ra[96:127] & data_even_rb[96:127]);
          wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;  
    end            

    //20. Nor
    11'b00001001001:begin        
          Rt[0:31]=~(data_even_ra[0:31] | data_even_rb[0:31]);
          Rt[32:63]=~(data_even_ra[32:63] | data_even_rb[0:68]);
          Rt[64:95]=~(data_even_ra[64:95] | data_even_rb[64:95]);
          Rt[96:127]=~(data_even_ra[96:127] | data_even_rb[96:127]);
          wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;  
    end            

    //21. Or
    11'b00001000001:begin        
          Rt[0:31]=data_even_ra[0:31] | data_even_rb[0:31];
          Rt[32:63]=data_even_ra[32:63] | data_even_rb[32:63];
          Rt[64:95]=data_even_ra[64:95] | data_even_rb[64:95];
          Rt[96:127]=data_even_ra[96:127] | data_even_rb[96:127];
          wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY; 
    end             

    //22. Or with complement
    11'b01011001001:begin 
          Rt[0:31]=data_even_ra[0:31] | ~(data_even_rb[0:31]);
          Rt[32:63]=data_even_ra[32:63] | ~(data_even_rb[32:63]);
          Rt[64:95]=data_even_ra[64:95] | ~(data_even_rb[64:95]);
          Rt[96:127]=data_even_ra[96:127] | ~(data_even_rb[96:127]);
          wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;  
    end 

    //23. Or word immediate
    11'b00000100:begin        
          firstbit = imm10_even[0];
          temp_imm10 = {{22{firstbit}},imm10_even};
          Rt[0:31]=data_even_ra[0:31]|temp_imm10;
          Rt[32:63]=data_even_ra[32:63]|temp_imm10;
          Rt[64:95]=data_even_ra[64:95]|temp_imm10;
          Rt[96:127]=data_even_ra[96:127]|temp_imm10;
          wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;
    end           

    //24. Subtract from word
    11'b00001000000:begin 
          Rt[0:31]=data_even_ra[0:31] + ~(data_even_rb[0:31]) + 1;
          Rt[32:63]=data_even_ra[32:63] + ~(data_even_rb[32:63]) + 1;
          Rt[64:95]=data_even_ra[64:95] + ~(data_even_rb[64:95]) + 1;
          Rt[96:127]=data_even_ra[96:127] + ~(data_even_rb[96:127]) + 1;
          wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;  
    end 

    //25. Sub word immediate
    11'b00001100:begin 
          firstbit = imm10_even[0];
          temp_imm10 = {{22{firstbit}},imm10_even};
          Rt[0:31]=temp_imm10 + ~(data_even_ra[0:31]) + 1;
          Rt[32:63]=temp_imm10 + ~(data_even_ra[32:63]) + 1;
          Rt[64:95]=temp_imm10 + ~(data_even_ra[64:95]) + 1;
          Rt[96:127]=temp_imm10 + ~(data_even_ra[96:127]) + 1;
          wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;  
    end 

    //26. Sub extended from word
    11'b01101000001:begin 
		for(int i=0; i<4; i=i+1)begin
		temp_imm=data_even_rc[(i*32)+: 32];
        if(temp_imm[31]==0) 
		Rt[(i*32)+: 32]=data_even_ra[(i*32)+: 32] + ~(data_even_rb[(i*32)+: 32]) + 1; 
		else Rt[(i*32)+: 32]=data_even_ra[(i*32)+: 32] + ~(data_even_rb[(i*32)+: 32]) + temp_imm[31]; end 
	 	wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;		
    end

    //27. ExOr
    11'b01001000001:begin         
        Rt[0:31]=data_even_ra[0:31] ^ data_even_rb[0:31];
        Rt[32:63]=data_even_ra[32:63] ^ data_even_rb[32:63];
        Rt[64:95]=data_even_ra[64:95] ^ data_even_rb[64:95];
        Rt[96:127]=data_even_ra[96:127] ^ data_even_rb[96:127];
        wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;  
    end             

    //28. Exor byte immediate
    11'b01000110:begin 
        b = imm10_even & 8'hff;
        bbbb = {b,b,b,b};
        Rt[0:31]=data_even_ra[0:31] ^ bbbb;
        Rt[32:63]=data_even_ra[32:63] ^ bbbb;
        Rt[64:95]=data_even_ra[64:95] ^ bbbb;
        Rt[96:127]=data_even_ra[96:127] ^ bbbb;
        wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;  
    end 

    //29. Ex or word immediate
    11'b01000100:begin
        firstbit = imm10_even[0];
        temp_imm10 = {{22{firstbit}},imm10_even};
        Rt[0:31]=data_even_ra[0:31] ^ temp_imm10;
        Rt[32:63]=data_even_ra[32:63] ^ temp_imm10;
        Rt[64:95]=data_even_ra[64:95] ^ temp_imm10;
        Rt[96:127]=data_even_ra[96:127] ^ temp_imm10;
        wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;
    end 

    //30. Extend Sign Byte to Halfword
    11'b01010110110:begin  
        Rt[0:15]={{8{data_even_ra[8]}},data_even_ra[8:15]};
        Rt[16:31]={{8{data_even_ra[24]}},data_even_ra[24:31]};
        Rt[32:47]={{8{data_even_ra[40]}},data_even_ra[40:47]};
        Rt[48:63]={{8{data_even_ra[56]}},data_even_ra[56:63]};
        Rt[64:79]={{8{data_even_ra[72]}},data_even_ra[72:79]};
        Rt[80:95]={{8{data_even_ra[88]}},data_even_ra[88:95]};
        Rt[96:111]={{8{data_even_ra[104]}},data_even_ra[104:111]};
        Rt[112:127]={{8{data_even_ra[112]}},data_even_ra[112:127]};
        wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;
    end

    //31. Extend sign halfword to word
    11'b01010101110:begin
        Rt[0:31]={{16{data_even_ra[16]}},data_even_ra[16:31]};
        Rt[32:63]={{16{data_even_ra[48]}},data_even_ra[48:63]};
        Rt[64:95]={{16{data_even_ra[80]}},data_even_ra[80:95]};
        Rt[96:127]={{16{data_even_ra[112]}},data_even_ra[112:127]};
        wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;
    end
  
    //32. Extend sign word to doubleword
    11'b01010100110:begin
      Rt[0:63]={{32{data_even_ra[32]}},data_even_ra[32:63]};
      Rt[64:127]={{32{data_even_ra[96]}},data_even_ra[96:127]};
      wr_en = 1; unit_temp = SIMPLE_FIXED1_UNIT; latency_temp = SIMPLE_FIXED1_LATENCY;
    end

    //33. Absolute differences of bytes
    11'b00001010011:begin
        for(int i=0; i<16; i=i+1)begin
        if((data_even_rb[(i*8)+: 8])>(data_even_ra[(i*8)+: 8]))
        Rt[(i*8)+: 8]=(data_even_rb[(i*8)+: 8])-(data_even_ra[(i*8)+: 8]);
        else Rt[(i*8)+: 8]=(data_even_ra[(i*8)+: 8])-(data_even_rb[(i*8)+: 8]); end
        wr_en = 1; unit_temp = BYTE_UNIT; latency_temp = BYTE_LATENCY;
    end

    //34. Average bytes
    11'b00011010011:begin
      for(int i=0; i<16; i=i+1)begin
      Rt[(i*8)+: 8]=((data_even_rb[(i*8)+: 8])+(data_even_ra[(i*8)+: 8])+1)>>1;
      wr_en = 1; unit_temp = BYTE_UNIT; latency_temp = BYTE_LATENCY;
      end
    end 

    //35. Count ones in bytes
    11'b01010110100: begin  
      for(int i=0; i<16; i=i+1) begin 
      ra_byte=data_even_ra[(i*8)+: 8];
      count=0;
      for(int j=0; j<8; j=j+1)begin
      if(ra_byte[j]==1'b1)
      count++; end
      Rt[(i*8)+:8] =count; end
      wr_en = 1; unit_temp = BYTE_UNIT; latency_temp = BYTE_LATENCY;  
      end

    //36. sum bytes into halfword
    11'b01001010011:begin
      Rt[0:15]=data_even_rb[0:7]+data_even_rb[8:15]+data_even_rb[16:23]+data_even_rb[24:31];
      Rt[16:31]=data_even_ra[0:7]+data_even_ra[8:15]+data_even_ra[16:23]+data_even_ra[24:31];
      Rt[32:47]=data_even_rb[32:39]+data_even_rb[40:47]+data_even_rb[48:55]+data_even_rb[56:63];
      Rt[48:63]=data_even_ra[32:39]+data_even_ra[40:47]+data_even_ra[48:55]+data_even_ra[56:63];
      Rt[64:79]=data_even_rb[64:71]+data_even_rb[72:79]+data_even_rb[80:87]+data_even_rb[88:95];
      Rt[80:95]=data_even_ra[64:71]+data_even_ra[72:79]+data_even_ra[80:87]+data_even_ra[88:95];
      Rt[96:111]=data_even_rb[96:103]+data_even_rb[104:111]+data_even_rb[112:119]+data_even_rb[120:127];
      Rt[112:127]=data_even_ra[96:103]+data_even_ra[104:111]+data_even_ra[112:119]+data_even_ra[120:127];
      wr_en = 1; unit_temp = BYTE_UNIT; latency_temp = BYTE_LATENCY;
    end

    //37. Rotate word
    11'b00001011000:begin
        for(int i=0; i<4; i=i+1)begin
        rb_word=data_even_rb[(i*32)+: 32];
        if(rb_word[28:31]==5'b0)
        Rt[(i*32)+: 32]=(data_even_ra[(i*32)+: 32]);
        else 
        Rt[(i*32)+: 32]=((data_even_ra[(i*32)+: 32])<<(rb_word[28:31]))|((data_even_ra[(i*32)+:32])>>(32-(rb_word[28:31]))); end
        wr_en = 1; unit_temp = SIMPLE_FIXED2_UNIT; latency_temp = SIMPLE_FIXED2_LATENCY;
    end

    //38. Rotate and mask word
    11'b00001011001:begin
        for(int i=0; i<4; i=i+1)begin
        shift_count=(0-data_even_rb[(i*32)+: 32])%64;
        if(shift_count<32)
        Rt[(i*32)+: 32]=(data_even_ra[(i*32)+: 32])>>shift_count;
        else
        Rt[(i*32)+: 32]=32'b0; end
        wr_en = 1; unit_temp = SIMPLE_FIXED2_UNIT; latency_temp = SIMPLE_FIXED2_LATENCY;
    end

    //39. Shift left word
    11'b00001011011:begin  
        for(int i=0; i<4; i=i+1)begin
        rb_word=data_even_rb[(i*32)+: 32];
        if(rb_word[26:31]==5'b0)
        Rt[(i*32)+: 32]=(data_even_ra[(i*32)+: 32]);
        else if(rb_word[26:31]>31)  
        Rt[(i*32)+: 32]=5'b0;
        else
        Rt[(i*32)+: 32]=(data_even_ra[(i*32)+: 32])<<(rb_word[26:31]); end
        wr_en = 1; unit_temp = SIMPLE_FIXED2_UNIT; latency_temp = SIMPLE_FIXED2_LATENCY;
    end
  
    //40. Shift left word immediate
    11'b00001111011:begin
        for(int i=0; i<4; i=i+1)begin
        firstbit = imm7_even[0];
        temp_imm = {{25{firstbit}},imm7_even};
        if(temp_imm[26:31]==5'b0)
        Rt[(i*32)+: 32]=(data_even_ra[(i*32)+: 32]);
        else if(temp_imm[26:31]>31) 
        Rt[(i*32)+: 32]=5'b0;
        else Rt[(i*32)+: 32]=(data_even_ra[(i*32)+: 32])<<(temp_imm[26:31]); end
        wr_en = 1; unit_temp = SIMPLE_FIXED2_UNIT; latency_temp = SIMPLE_FIXED2_LATENCY;
    end

    //53. Floating Add
	  11'b0101_1000_100: begin
	  	for(int i=0; i<4; i=i+1)begin
	  	Rt[i*32+:32] = $shortrealtobits(($bitstoshortreal(data_even_ra[i*32+:32]) + $bitstoshortreal(data_even_rb[i*32+:32]))); end
	  	wr_en = 1; unit_temp = SINGLE_PRECISION1_UNIT; latency_temp = SINGLE_PRECISION1_LATENCY;
			end

			//54. Floating Multiply
			11'b0101_1000_110: begin
			  for(int i=0; i<4; i=i+1)begin
			  Rt[i*32+:32] = $shortrealtobits(($bitstoshortreal(data_even_ra[i*32+:32]) * $bitstoshortreal(data_even_rb[i*32+:32]))); end
			  wr_en = 1; unit_temp = SINGLE_PRECISION1_UNIT; latency_temp = SINGLE_PRECISION1_LATENCY;
			end

			//55. Floating Multiply and Add
			11'b1110: begin
			  for(int i=0; i<4; i=i+1)begin
			  Rt[i*32+:32] = $shortrealtobits(($bitstoshortreal(data_even_ra[i*32+:32]) * $bitstoshortreal(data_even_rb[i*32+:32]))+$bitstoshortreal(data_even_rc[i*32+:32])); end
			  wr_en = 1; unit_temp = SINGLE_PRECISION1_UNIT; latency_temp = SINGLE_PRECISION1_LATENCY;
			end

			//56. Floating Multiply and Subtract
			11'b1111: begin
			  for(int i=0; i<4; i=i+1)begin
			  Rt[i*32+:32] = $shortrealtobits(($bitstoshortreal(data_even_ra[i*32+:32]) * $bitstoshortreal(data_even_rb[i*32+:32]))-$bitstoshortreal(data_even_rc[i*32+:32])); end
			  wr_en = 1; unit_temp = SINGLE_PRECISION1_UNIT; latency_temp = SINGLE_PRECISION1_LATENCY;
			end
			
			//57. Floating Subtract
			11'b0101_1000_101: begin
			  for(int i=0; i<4; i=i+1)begin
			  Rt[i*32+:32] = $shortrealtobits(($bitstoshortreal(data_even_ra[i*32+:32]) - $bitstoshortreal(data_even_rb[i*32+:32]))); end
			  wr_en = 1; unit_temp = SINGLE_PRECISION1_UNIT; latency_temp = SINGLE_PRECISION1_LATENCY;
			end

    //62.  Multiply
    11'b01111000100:begin                            
      Rt[0:31]=data_even_ra[16:31]*data_even_rb[16:31];
      Rt[32:63]=data_even_ra[48:63]*data_even_rb[48:63];
      Rt[64:95]=data_even_ra[80:95]*data_even_rb[80:95];
      Rt[96:127]=data_even_ra[112:127]*data_even_rb[112:127];
      wr_en = 1; unit_temp = SINGLE_PRECISION2_UNIT; latency_temp = SINGLE_PRECISION2_LATENCY;
    end                                              

    //63. Multiply and add
    11'b1100:begin 
      rt_temp[0:31]=$signed(data_even_ra[16:31])*$signed(data_even_rb[16:31]);
      rt_temp[32:63]=$signed(data_even_ra[48:63])*$signed(data_even_rb[48:63]);
      rt_temp[64:95]=$signed(data_even_ra[80:95])*$signed(data_even_rb[80:95]);
      rt_temp[96:127]=$signed(data_even_ra[112:127])*$signed(data_even_rb[112:127]);
      Rt[0:31]=rt_temp[0:31]+data_even_rc[0:31];
      Rt[32:63]=rt_temp[32:63]+data_even_rc[32:63];
      Rt[64:95]=rt_temp[64:95]+data_even_rc[64:95];
      Rt[96:127]=rt_temp[96:127]+data_even_rc[96:127];
      wr_en = 1; unit_temp = SINGLE_PRECISION2_UNIT; latency_temp = SINGLE_PRECISION2_LATENCY;
    end 

    //64. MultiplyImmediate
    11'b01110100:begin                               
      firstbit = imm10_even[0];
      temp_imm10 = {{6{firstbit}},imm10_even};
      Rt[0:31]=data_even_ra[16:31]*temp_imm10;
      Rt[32:63]=data_even_ra[48:63]*temp_imm10;
      Rt[64:95]=data_even_ra[80:95]*temp_imm10;
      Rt[96:127]=data_even_ra[112:127]*temp_imm10;
      wr_en = 1; unit_temp = SINGLE_PRECISION2_UNIT; latency_temp = SINGLE_PRECISION2_LATENCY;
    end                                               

    //65. Multiply and shift right
    11'b01111000111:begin 
      rt_temp[0:31]=(data_even_ra[16:31])*(data_even_rb[16:31]);
      rt_temp[32:63]=(data_even_ra[48:63])*(data_even_rb[48:63]);
      rt_temp[64:95]=(data_even_ra[80:95])*(data_even_rb[80:95]);
      rt_temp[96:127]=(data_even_ra[112:127])*(data_even_rb[112:127]);
      Rt[0:31]={{16{rt_temp[0]}},rt_temp[0:15]};  
      Rt[32:63]={{16{rt_temp[32]}},rt_temp[32:47]};
      Rt[64:95]={{16{rt_temp[64]}},rt_temp[64:79]};
      Rt[96:127]={{16{rt_temp[96]}},rt_temp[96:111]};
      wr_en = 1; unit_temp = SINGLE_PRECISION2_UNIT; latency_temp = SINGLE_PRECISION2_LATENCY;
    end   
    
    //66. Multiply Unsigned
    11'b01111001100:begin 
      Rt[0:31]=$unsigned(data_even_ra[16:31])*$unsigned(data_even_rb[16:31]);
      Rt[32:63]=$unsigned(data_even_ra[48:63])*$unsigned(data_even_rb[48:63]);
      Rt[64:95]=$unsigned(data_even_ra[80:95])*$unsigned(data_even_rb[80:95]);
      Rt[96:127]=$unsigned(data_even_ra[112:127])*$unsigned(data_even_rb[112:127]);
      wr_en = 1; unit_temp = SINGLE_PRECISION2_UNIT; latency_temp = SINGLE_PRECISION2_LATENCY;
    end 
  
    //67. Multiply unsigned Immediate
    11'b01110101:begin 
      firstbit = imm10_even[0];
      temp_imm10 = {{6{firstbit}},imm10_even};
      Rt[0:31]=$unsigned(data_even_ra[16:31])*$unsigned(temp_imm10);
      Rt[32:63]=$unsigned(data_even_ra[48:63])*$unsigned(temp_imm10);
      Rt[64:95]=$unsigned(data_even_ra[80:95])*$unsigned(temp_imm10);
      Rt[96:127]=$unsigned(data_even_ra[112:127])*$unsigned(temp_imm10);
      wr_en = 1; unit_temp = SINGLE_PRECISION2_UNIT; latency_temp = SINGLE_PRECISION2_LATENCY;
    end 

	    //71. No Operation (Execute)
    	11'b0100_0000_001:begin 
    		Rt=128'bx;
    		wr_en = 1; 
  		end

      //Stop 
      11'b0:begin 
        stop=1; 
      end
      
    default: begin  // Do Nothing
        Rt=128'bz;
      end
  endcase
  end
          
  // Shift Registers - Pipelining 
  //assign Rt_Temp = {unit_temp, latency_temp, wr_en, addr_even_rt, Rt};

    always_comb begin
    if(stop==1)
      Rt_Temp = 142'b0;
    else 
      Rt_Temp = {unit_temp, latency_temp, wr_en, addr_even_rt, Rt}; end

    always_ff @(posedge clk) begin

        Rt_Temp1 <= Rt_Temp; 
        Rt_Temp2 <= Rt_Temp1;
        Rt_Temp3 <= Rt_Temp2;
        Rt_Temp4 <= Rt_Temp3;
        Rt_Temp5 <= Rt_Temp4;
        Rt_Temp6 <= Rt_Temp5;
        Rt_Temp7 <= Rt_Temp6;
    end

    assign unit = Rt_Temp7 [0:2];
    assign latency = Rt_Temp7 [3:5];
    assign data_even_rt = Rt_Temp7 [15:142];
    assign wr_en_even = Rt_Temp7 [6];
    assign addr_even_rt2 = Rt_Temp7 [7:14];

endmodule

//================================================  ODD PIPE  ==============================================================
module oddpipe(clk, reset, opcode_odd, addr_odd_rt, data_odd_ra, data_odd_rb, data_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd, addr_odd_rt2, data_odd_rt, wr_en_odd,Pc_in, Pc_out_2, flush);

    parameter WIDTH=8, SIZE=32768;

    input clk, reset, flush;
    input [0:7] addr_odd_rt;
    input [0:10] opcode_odd;
    input [0:6] imm7_odd;          // logic from TB
    input [0:9] imm10_odd;         // logic from TB
    input [0:15] imm16_odd;        // logic from TB
    input [0:17] imm18_odd;        // logic from TB
    input [0:31] Pc_in;           
    input signed [0:127] data_odd_ra, data_odd_rb, data_odd_rc;

    output [0:7] addr_odd_rt2;
    output logic signed [0:127] data_odd_rt;
    output logic wr_en_odd;
    output [0:31] Pc_out_2;


    logic [0:175] Rt_Temp, Rt_Temp1, Rt_Temp2, Rt_Temp3, Rt_Temp4, Rt_Temp5, Rt_Temp6, Rt_Temp7;
    logic signed [0:31] addr_ls_temp, addr_ls;
    logic [0:13] LSA_val; 
    logic [0:127] Rt;   
    logic [0:2] latency_temp, unit_temp, latency, unit; 
    logic signed [0:127] data_in, data_out;
    logic [0:31] imm16_ext;
    logic [0:3] rb_bits;
    logic [0:31] shift_count, Pc_out;
    logic [0:4] rb_bits_2;
    logic wr_en, wr_en_ls, Br_Flag, Br_Flag_2, stop;
    integer i;


    logic [0:16843008][0:31] mem; 
    //assign Br_Pc_Out = Pc_out_2;

    always_comb begin
      case(opcode_odd)

      //41. Branch Indirect
       11'b0011_0101_000: begin
          logic e, d;
          logic [0:1] intr;
          Pc_out = (data_odd_ra[0:31] & 32'hfffffffc);   // Branch Target Address
          Br_Flag = 1;                   // Branch Flush Signal
          if(e==1 && d==0) intr = 2'd1;
          else if(e==0 && d==1) intr = 2'd2;
          else if(e==0 && d==1) intr = 2'd3;
          else intr = 2'd0;
          wr_en = 1;  unit_temp = BRANCH_UNIT; latency_temp = BRANCH_LATENCY;
          end


       //42. Branch Indirect and Set Link
        11'b0011_0101_001: begin
          logic e, d;
          logic [0:1] intr;
          Pc_out = (data_odd_ra[0:31] & 32'hfffffffc);   // Branch Target Address
          Rt[0:31] = (Pc_in +4);
          Rt[32:127] = 95'd0;
          Br_Flag = 1;                   // Branch Flush Signal
          if(e==1 && d==0) intr = 2'd1;
          else if(e==0 && d==1) intr = 2'd2;
          else if(e==0 && d==1) intr = 2'd3;
          else intr = 2'd0;
          wr_en = 1;  unit_temp = BRANCH_UNIT; latency_temp = BRANCH_LATENCY;
          end

       //43. Branch Relative
       11'b0011_0010_0: begin
          for(i=0;i<14;i=i+1)
          imm16_ext[i]=imm16_odd[0];
          imm16_ext[14:29]=imm16_odd;
          imm16_ext[30:31]=2'b00;
          Pc_out = (Pc_in + imm16_ext);    // Branch Target Address
          Br_Flag = 1;                   // Branch Flush Signal
          Rt[0:127] = 128'd0; 
          wr_en = 1;  unit_temp = BRANCH_UNIT; latency_temp = BRANCH_LATENCY;
          end

      //44. Branch Absolute
      11'b0011_0000_0: begin
        for(i=0;i<14;i=i+1)
        imm16_ext[i]=imm16_odd[0];
        imm16_ext[14:29]=imm16_odd;
        imm16_ext[30:31]=2'b00;
        Pc_out = imm16_ext;           // Branch Target Address               
        Br_Flag = 1;                  // Branch Flush Signal
        Rt[0:127] = 128'd0; 
        wr_en = 1;  unit_temp = BRANCH_UNIT; latency_temp = BRANCH_LATENCY;
      end

      //45. Branch Absolute and Set Link
      11'b0011_0001_0: begin
        for(i=0;i<14;i=i+1)
        imm16_ext[i]=imm16_odd[0];
        imm16_ext[14:29]=imm16_odd;
        imm16_ext[30:31]=2'b00;
        Pc_out = imm16_ext;            // Branch Target Address               
        Rt[0:31] = (Pc_in +4);
        Rt[32:127] = 95'd0;
        Br_Flag = 1;                   // Branch Flush Signal
        wr_en = 1;  unit_temp = BRANCH_UNIT; latency_temp = BRANCH_LATENCY;
      end

     //46. Branch Relative and Set Link  
    11'b0011_0011_0: begin
    for(i=0;i<14;i=i+1)
      imm16_ext[i] = imm16_odd[0];
      imm16_ext[14:29] = imm16_odd;
      imm16_ext[30:31] = 2'b00;
      Pc_out = (Pc_in+(imm16_ext + 4));
      Br_Flag = 1;                   // Branch Flush Signal
      Rt[0:127] = 128'd0; 
      wr_en = 1;  unit_temp = BRANCH_UNIT; latency_temp = BRANCH_LATENCY;
    end

    // 68. Branch if Not Zero Word
    11'b0010_0001_0: begin
      for(i=0;i<14;i=i+1)
      	imm16_ext[i]=imm16_odd[0];
        imm16_ext[14:29]=imm16_odd;
        imm16_ext[30:31]=2'b00;
	  	if(data_odd_rc[0:31] != 32'b0) begin
      	Pc_out = ((Pc_in + imm16_ext) & 32'hfffffffc);    // Branch Target Address
        Br_Flag = 1; end 						                     // Branch Flush Signal
      else begin 
      	Pc_out = (Pc_in + 4); 
      	Br_Flag = 0; end                    // Branch Flush Signal
      	Rt[0:127] = 128'd0; 			         // Optional
      	wr_en = 1;  unit_temp = BRANCH_UNIT; latency_temp = BRANCH_LATENCY;
      end

    //69. Branch if Zero Word
     11'b0010_0000_0: begin
      for(i=0;i<14;i=i+1)
      	imm16_ext[i]=imm16_odd[0];
      	imm16_ext[14:29]=imm16_odd;
      	imm16_ext[30:31]=2'b00;
	  	if(data_odd_rc[0:31] == 32'b0) begin 
      	Pc_out = ((Pc_in + imm16_ext) & 32'hfffffffc);    // Branch Target Address
        Br_Flag = 1; end 						                     // Branch Flush Signal
      else begin 
      	Pc_out = (Pc_in + 4); 
      	Br_Flag = 0;   end                  // Branch Flush Signal
				Rt[0:127] = 128'd0; 			         // Optional
      	wr_en = 1;  unit_temp = BRANCH_UNIT; latency_temp = BRANCH_LATENCY;
      end


      //47. Rotate quadword by bytes
      11'b00111011100:begin
      rb_bits=data_odd_rb[28:31];     
      for(int i=0; i<16; i=i+1)begin                        
            if(rb_bits==4'b0)
            Rt[(i*8)+: 8]=(data_odd_ra[(i*8)+: 8]);
            else 
            Rt=((data_odd_ra)<<(8*rb_bits))|((data_odd_ra)>>8*(16-(rb_bits)));
      end 
      wr_en = 1;  unit_temp = PERMUTE_UNIT; latency_temp = PERMUTE_LATENCY;
    	end

      //48. Rotate Quadword by Bytes Immediate              
      11'b00111111100:begin//Rotate Quadword by Bytes Immediate
      rb_bits=imm7_odd[3:6];
      for(int i=0; i<16; i=i+1)begin
            if(rb_bits==4'b0)
            Rt[(i*8)+: 8]=(data_odd_ra[(i*8)+: 8]);
            else 
            Rt=((data_odd_ra)<<(8*rb_bits))|((data_odd_ra)>>8*(16-(rb_bits)));
      end 
      wr_en = 1;  unit_temp = PERMUTE_UNIT; latency_temp = PERMUTE_LATENCY;
    	end

      //49. Rotate and mask Quadword by Bytes
      11'b00111011101:begin
      shift_count=(0-data_odd_rb[27:31])%32;
      for(int i=0; i<16; i=i+1)begin
            if(shift_count<16)
            Rt=(data_odd_ra)>>(8*shift_count);
            else
            Rt=128'b0;
      end 
      wr_en = 1;  unit_temp = PERMUTE_UNIT; latency_temp = PERMUTE_LATENCY;
    	end

      //50. Rotate and mask Quadword by Bytes Immediate
      11'b00111111101:begin
      shift_count=(0-imm7_odd)%32;
      for(int i=0; i<16; i=i+1)begin
            if(shift_count<16)
            Rt=(data_odd_ra)>>(8*shift_count);     
            else
            Rt=128'b0;
      end 
      wr_en = 1;  unit_temp = PERMUTE_UNIT; latency_temp = PERMUTE_LATENCY;
    	end

      //51. Shift left quadword by bytes 
      11'b00111011111:begin
      rb_bits_2=data_odd_rb[27:31];           
      for(int i=0; i<16; i=i+1)begin
            if(rb_bits==5'b0)
            Rt[(i*8)+: 8]=(data_odd_ra[(i*8)+: 8]);
            else if(rb_bits>15)  Rt=128'b0;
            else 
            Rt=((data_odd_ra)<<(8*rb_bits));
      end 
      wr_en = 1;  unit_temp = PERMUTE_UNIT; latency_temp = PERMUTE_LATENCY;
    	end
      
      //52. Shift left quadword immediate      
      11'b00111111111:begin
      rb_bits_2=imm7_odd[2:6];
      for(int i=0; i<16; i=i+1)begin
            if(rb_bits==5'b0)
            Rt[(i*8)+: 8]=(data_odd_ra[(i*8)+: 8]);
            else if(rb_bits>15)
            Rt=128'b0;
            else 
            Rt=((data_odd_ra)<<(8*rb_bits));
      end 
      wr_en = 1;  unit_temp = PERMUTE_UNIT; latency_temp = PERMUTE_LATENCY;
    	end

	  //58. Load Quadword (a-form)
	  11'b0000_1100_001: begin
	      for(i=0;i<14;i=i+1)
	      imm16_ext[i]=imm16_odd[0]; 
	      imm16_ext[14:29]=imm16_odd; imm16_ext[30:31]=2'b00;
	      addr_ls = imm16_ext & 32'hfffffff0;
	      Rt = data_out;
	      wr_en = 0; wr_en_ls=0; unit_temp = LOCALSTORE_UNIT; latency_temp = LOCALSTORE_LATENCY;
	      end
	   
	   //59. Load Quadword (x-form)
	   11'b0011_1000_100: begin                               
	      addr_ls_temp = data_odd_ra[0:31] + data_odd_rb[0:31];
	      addr_ls = (addr_ls_temp & 32'hfffffff0);
	        Rt = data_out;
	        wr_en = 0; wr_en_ls=0; unit_temp = LOCALSTORE_UNIT; latency_temp = LOCALSTORE_LATENCY;
	   end           
	   
	   //60. Store Quadword (a-form)
	   11'b0000_1000_001: begin
	      for(i=0;i<14;i=i+1)
	      imm16_ext[i]=imm16_odd[0]; 
	      imm16_ext[14:29]=imm16_odd; imm16_ext[30:31]=2'b00;
	      addr_ls = imm16_ext & 32'hfffffff0;
	      data_in = data_odd_rc;
	      wr_en = 0; wr_en_ls=1; unit_temp = LOCALSTORE_UNIT; latency_temp = LOCALSTORE_LATENCY;
	   end

	   //61. Store Quadword (x-form)
	   11'b0010_1000_100: begin                               
	      addr_ls_temp = data_odd_ra[0:31] + data_odd_rb[0:31];
	      addr_ls = (addr_ls_temp & 32'hfffffff0);
	      data_in = data_odd_rc;
	      wr_en = 0; wr_en_ls=1; unit_temp = LOCALSTORE_UNIT; latency_temp = LOCALSTORE_LATENCY;
	    end

	    //70. No Operation (Execute)
    	11'b0100_0000_001:begin 
    		Rt=128'b0; Pc_out = 128'b0; 
    		wr_en = 1; 
  		end

      //Stop 
      11'b0:begin 
        stop=1; 
      end
	           
	   default: begin                                    // Do Nothing
	        Rt=128'bx; wr_en = 1;
	   		end
		endcase
    end

        // Shift Registers-Pipelining 

      //assign Rt_Temp = {unit_temp, latency_temp, wr_en, addr_odd_rt, Rt, Pc_out, Br_Flag};
    always_comb begin
    if(stop==1)
      Rt_Temp = 142'b0;
    else 
     Rt_Temp = {unit_temp, latency_temp, wr_en, addr_odd_rt, Rt, Pc_out, Br_Flag}; end

      always_ff @(posedge clk) begin
        if (flush) begin
           Rt_Temp1 <= 142'bx;
           Rt_Temp2 <= 142'bx;
           Rt_Temp3 <= 142'bx;
           Rt_Temp4 <= Rt_Temp3;
           Rt_Temp5 <= Rt_Temp4;
           Rt_Temp6 <= Rt_Temp5;
           Rt_Temp7 <= Rt_Temp6;
        end
        else begin
            Rt_Temp1 <= Rt_Temp; 
            Rt_Temp2 <= Rt_Temp1;
            Rt_Temp3 <= Rt_Temp2;
            Rt_Temp4 <= Rt_Temp3;
            Rt_Temp5 <= Rt_Temp4;
            Rt_Temp6 <= Rt_Temp5;
            Rt_Temp7 <= Rt_Temp6;
        end
      end

		assign unit = Rt_Temp7 [0:2];
        assign latency = Rt_Temp7 [3:5];
        assign data_odd_rt = Rt_Temp7 [15:142];
        assign wr_en_odd = Rt_Temp7 [6];
        assign addr_odd_rt2 = Rt_Temp7 [7:14];
        assign Pc_out_2 = Rt_Temp7 [143:174];
        assign Br_Flag_2 = Rt_Temp7 [175];

    always_comb begin
      if (wr_en_ls==1) begin
       mem[addr_ls] = data_in; end end

     always_comb begin
      if (wr_en_ls==0) begin
      data_out = mem[addr_ls]; end end

endmodule 

//====================================================    TEST BENCH   ========================================================

module tbench();

    logic clk, reset, flush;
    logic [0:7] addr_even_ra, addr_even_rb, addr_even_rc;  
    logic [0:7] addr_odd_ra, addr_odd_rb, addr_odd_rc;   

    logic [0:10] opcode_even;      // logic from TB
    logic signed [0:6] imm7_even;			   // logic from TB
    logic signed [0:9] imm10_even;      	 // logic from TB
    logic signed [0:15] imm16_even; 		   // logic from TB
    logic signed [0:17] imm18_even;		   // logic from TB
    logic [0:7] addr_even_rt;      // logic from TB

    logic [0:10] opcode_odd;       // logic from TB
    logic [0:6] imm7_odd;          // logic from TB
    logic [0:9] imm10_odd;         // logic from TB
    logic [0:15] imm16_odd;        // logic from TB
    logic [0:17] imm18_odd;        // logic from TB
    logic [0:7] addr_odd_rt;       // logic from TB
    logic [0:31] Pc_in;            // Input from TB

    //opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd

    logic [0:136] Even_Test_Packet; //Packet Data Sent to Testbench for Verication Purpose
    logic [0:168] Odd_Test_Packet;  //Packet Data Sent to Testbench for Verication Purpose
    

    reg_file dut(       .clk(clk), 
                        .reset(reset), 
                        .addr_even_ra(addr_even_ra), 
                        .addr_even_rb(addr_even_rb),
                        .addr_even_rc(addr_even_rc), 
                        .opcode_even(opcode_even), 
                        .imm7_even(imm7_even),      // Input
                        .imm10_even(imm10_even),    // Input
                        .imm16_even(imm16_even),    // Input
                        .imm18_even(imm18_even),    // Input 
                        .addr_even_rt(addr_even_rt), 
                        .addr_odd_ra(addr_odd_ra), 
                        .addr_odd_rb(addr_odd_rb), 
                        .addr_odd_rc(addr_odd_rc),
                        .opcode_odd(opcode_odd), 
                        .imm7_odd(imm7_odd),        // Input
                        .imm10_odd(imm10_odd),      // Input
                        .imm16_odd(imm16_odd),      // Input
                        .imm18_odd(imm18_odd),      // Input
                        .addr_odd_rt(addr_odd_rt),
                        .Even_Test_Packet(Even_Test_Packet),
                        .Odd_Test_Packet(Odd_Test_Packet),
                        .Pc_in(Pc_in),
                        .flush(flush));

     initial clk = 0;
     always #5 clk = ~clk;

     integer filehandle=$fopen("Test_Inputs.txt");

     initial begin
     @(posedge clk) 
     reset = 1;

      $monitor("\n|| CLOCK IN NS:\t", $time,"\n|| EVEN PIPE RESULT >>>  \n \tAddr_Rt2=\t\t\t\t     %d, \n \tData_Rt= %d, \n \tData_Rt(hex)=\t%h, \n \tWr_en=\t\t\t\t\t       %b, \n|| ODD PIPE RESULT >>>  \n \tAddr_Rt2=\t\t\t\t     %d, \n \tData_Rt= %d, \n \tData_Rt(hex)=\t%h, \n \tWr_en=\t\t\t\t\t       %b, \n \tBr_Pc_out=\t%b, \n",Even_Test_Packet[128:135], Even_Test_Packet[0:127],Even_Test_Packet[0:127], Even_Test_Packet[136], Odd_Test_Packet[128:135], Odd_Test_Packet[0:127],Odd_Test_Packet[0:127], Odd_Test_Packet[136], Odd_Test_Packet[137:168]);
     
      @(posedge clk) reset = 0;opcode_even =11'b0001_1000_000; addr_even_ra =20; addr_even_rb =25; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Add Word"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even);
      opcode_odd =11'b0010_1000_100; addr_odd_ra =127; addr_odd_rb =127; addr_odd_rc =123; addr_odd_rt =0; imm10_odd =0; imm16_odd =0; imm18_odd =0; imm7_odd =0;$fdisplay(filehandle, "\nODD INSTRUCTION || Store Quadword (x-form)"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd);
    
      @(posedge clk) opcode_even =11'b01101000000; addr_even_ra =126; addr_even_rb =127; addr_even_rc =125; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Add Extended"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even);
      opcode_odd =11'b0011_1000_100; addr_odd_ra =127; addr_odd_rb =127; addr_odd_rc =120; addr_odd_rt =80; imm10_odd =0; imm16_odd =0; imm18_odd =0; imm7_odd =0;$fdisplay(filehandle, "\nODD INSTRUCTION || Load Quadword (x-form)"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd);

      @(posedge clk) opcode_even =11'b0001_1100; addr_even_ra =20; addr_even_rb =0; addr_even_rc =0; addr_even_rt =50; imm10_even =25; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Add Word Immediate"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even);
      opcode_odd =11'b0010_0000_1; addr_odd_ra =0; addr_odd_rb =0; addr_odd_rc =122; addr_odd_rt =0; imm10_odd =0; imm16_odd =127; imm18_odd =0; imm7_odd =0;$fdisplay(filehandle, "\nODD INSTRUCTION || Store Quadword (a-form)"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd);
      
      @(posedge clk) opcode_even =11'b0001_1000_001; addr_even_ra =20; addr_even_rb =25; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || And"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even);
      opcode_odd =11'b0011_0000_1; addr_odd_ra =0; addr_odd_rb =0; addr_odd_rc =0; addr_odd_rt =70; imm10_odd =0; imm16_odd =127; imm18_odd =0; imm7_odd =0;$fdisplay(filehandle, "\nODD INSTRUCTION || Load Quadword (a-form)"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd);
    
      @(posedge clk) opcode_even =11'b0001_0110; addr_even_ra =20; addr_even_rb =0; addr_even_rc =0; addr_even_rt =50; imm10_even =9; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || And Byte Immediate"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even);
      opcode_odd =11'b0011_0101_000; addr_odd_ra =127; addr_odd_rb =0; addr_odd_rc =0; addr_odd_rt =55; imm10_odd =0; imm16_odd =0; imm18_odd =0; imm7_odd =0;$fdisplay(filehandle, "\nODD INSTRUCTION || Branch Indirect"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd);

      @(posedge clk) opcode_even =11'b0101_1000_001; addr_even_ra =20; addr_even_rb =25; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || And with Complement"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even);   
      opcode_odd =11'b0011_0101_001; addr_odd_ra =127; addr_odd_rb =0; addr_odd_rc =0; addr_odd_rt =57; imm10_odd =0; imm16_odd =0; imm18_odd =0; imm7_odd =0; Pc_in = 224656; $fdisplay(filehandle, "\nODD INSTRUCTION || Branch Indirect and Set Link"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Odd =\t\t      %d\n-> PC =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd,Pc_in);

      @(posedge clk) opcode_even =11'b0111_1000_000; addr_even_ra =25; addr_even_rb =25; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Compare Equal Word"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      opcode_odd =11'b0011_0010_0; addr_odd_ra =0; addr_odd_rb =0; addr_odd_rc =0; addr_odd_rt =55; imm10_odd =0; imm16_odd =36; imm18_odd =0; imm7_odd =0;Pc_in = 324345; $fdisplay(filehandle, "\nODD INSTRUCTION || Branch Relative"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Odd =\t\t      %d\n-> PC =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd,Pc_in);

      @(posedge clk) opcode_even =11'b0111_1010_000; addr_even_ra =25; addr_even_rb =20; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Compare Equal Byte"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      opcode_odd =11'b0011_0000_0; addr_odd_ra =0; addr_odd_rb =0; addr_odd_rc =0; addr_odd_rt =57; imm10_odd =0; imm16_odd =36; imm18_odd =0; imm7_odd =0;$fdisplay(filehandle, "\nODD INSTRUCTION || Branch Absolute"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd);

      @(posedge clk) opcode_even =11'b0111_1110; addr_even_ra =25; addr_even_rb =0; addr_even_rc =0; addr_even_rt =50; imm10_even =25; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Compare Equal Byte Immediate"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      opcode_odd =11'b0011_0001_0; addr_odd_ra =0; addr_odd_rb =0; addr_odd_rc =0; addr_odd_rt =55; imm10_odd =0; imm16_odd =36; imm18_odd =0; imm7_odd =0; Pc_in = 423536; $fdisplay(filehandle, "\nODD INSTRUCTION || Branch Absolute and Set Link"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Odd =\t\t      %d\n-> PC =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd,Pc_in);

      @(posedge clk) opcode_even =11'b0111_1100; addr_even_ra =25; addr_even_rb =0; addr_even_rc =0; addr_even_rt =50; imm10_even =20; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Compare Equal Word Immediate"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even);
      opcode_odd =11'b0011_0011_0; addr_odd_ra =0; addr_odd_rb =0; addr_odd_rc =0; addr_odd_rt =57; imm10_odd =0; imm16_odd =36; imm18_odd =0; imm7_odd =0; Pc_in = 524656; $fdisplay(filehandle, "\nODD INSTRUCTION || Branch Relative and Set Link"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Odd =\t\t      %d\n-> PC =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd,Pc_in);

      @(posedge clk) opcode_even =11'b0100_1010_000; addr_even_ra =25; addr_even_rb =20; addr_even_rc =0; addr_even_rt =50; imm10_even =25; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Compare Greater Than Byte"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      opcode_odd =11'b00111011100; addr_odd_ra =126; addr_odd_rb =126; addr_odd_rc =0; addr_odd_rt =75; imm10_odd =0; imm16_odd =0; imm18_odd =0; imm7_odd =0;$fdisplay(filehandle, "\nODD INSTRUCTION || Rotate Quadword by Bytes"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd); 

      @(posedge clk) opcode_even =11'b0100_1110; addr_even_ra =20; addr_even_rb =0; addr_even_rc =0; addr_even_rt =50; imm10_even =25; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Compare Greater Than Byte Immediate"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      opcode_odd =11'b00111111100; addr_odd_ra =126; addr_odd_rb =126; addr_odd_rc =0; addr_odd_rt =75; imm10_odd =0; imm16_odd =0; imm18_odd =0; imm7_odd =0;$fdisplay(filehandle, "\nODD INSTRUCTION || Rotate Quadword by Bytes Immediate"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd); 
 
      @(posedge clk) opcode_even =11'b0100_1100; addr_even_ra =25; addr_even_rb =0; addr_even_rc =0; addr_even_rt =50; imm10_even =20; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Compare Greater Than Word Immediate"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even);
      opcode_odd =11'b00111011101; addr_odd_ra =126; addr_odd_rb =126; addr_odd_rc =0; addr_odd_rt =75; imm10_odd =0; imm16_odd =0; imm18_odd =0; imm7_odd =0;$fdisplay(filehandle, "\nODD INSTRUCTION || Rotate and mask Quadword by Bytes"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd); 

      @(posedge clk) opcode_even =11'b0101_1010_000; addr_even_ra =25; addr_even_rb =20; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Compare Logical Greater Than Byte"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      opcode_odd =11'b00111111101; addr_odd_ra =126; addr_odd_rb =126; addr_odd_rc =0; addr_odd_rt =75; imm10_odd =0; imm16_odd =0; imm18_odd =0; imm7_odd =0;$fdisplay(filehandle, "\nODD INSTRUCTION || Rotate and Mask Quadword by Bytes Immediate"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd); 
 
      @(posedge clk) opcode_even =11'b0101_1110; addr_even_ra =20; addr_even_rb =0; addr_even_rc =0; addr_even_rt =50; imm10_even =25; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Compare Logical Greater Than Byte Immediate"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      opcode_odd =11'b00111011111; addr_odd_ra =126; addr_odd_rb =126; addr_odd_rc =0; addr_odd_rt =75; imm10_odd =0; imm16_odd =0; imm18_odd =0; imm7_odd =0;$fdisplay(filehandle, "\nODD INSTRUCTION || Shift left quadword by bytes"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd); 
  
      @(posedge clk) opcode_even =11'b0100_0000_1; addr_even_ra =0; addr_even_rb =0; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =25; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Immediate Load Word"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      opcode_odd =11'b00111111111; addr_odd_ra =126; addr_odd_rb =126; addr_odd_rc =0; addr_odd_rt =75; imm10_odd =0; imm16_odd =0; imm18_odd =0; imm7_odd =0;$fdisplay(filehandle, "\nODD INSTRUCTION || Shift left quadword by bytes immediate"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd); 

      @(posedge clk) opcode_even =11'b0100_0001_1; addr_even_ra =0; addr_even_rb =0; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =25; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Immediate Load Halfword"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
	  	//Branch if Not Zero Word
	  	opcode_odd =11'b0010_0001_0; addr_odd_ra =0; addr_odd_rb =0; addr_odd_rc =127; addr_odd_rt =0; imm10_odd =0; imm16_odd =36; imm18_odd =0; imm7_odd =0;Pc_in = 323523; $fdisplay(filehandle, "\nODD INSTRUCTION || Branch if Not Zero Word"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Odd =\t\t      %d\n-> PC =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd,Pc_in);

      @(posedge clk) opcode_even =11'b0100_001; addr_even_ra =0; addr_even_rb =0; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =25; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Immediate Load Address"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
			//Branch if Zero Word 
			opcode_odd =11'b0010_0000_0; addr_odd_ra =0; addr_odd_rb =0; addr_odd_rc =0; addr_odd_rt =0; imm10_odd =0; imm16_odd =36; imm18_odd =0; imm7_odd =0;Pc_in = 328766; $fdisplay(filehandle, "\nODD INSTRUCTION || Branch if Zero Word"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Odd =\t\t      %d\n-> PC =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd,Pc_in);
      
      @(posedge clk) opcode_even =11'b0001_1001_001; addr_even_ra =25; addr_even_rb =20; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Nand"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
			//First No - Op - Odd Pipe
			opcode_odd =11'b0100_0000_001; addr_odd_ra =0; addr_odd_rb =0; addr_odd_rc =55; addr_odd_rt =0; imm10_odd =0; imm16_odd =0; imm18_odd =0; imm7_odd =0; $fdisplay(filehandle, "\nODD INSTRUCTION || No Operation (Execute)"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd);
      
      @(posedge clk) opcode_even =11'b0000_1001_001; addr_even_ra =25; addr_even_rb =20; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Nor"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
			// Test Instruction 1 - FLush 
			opcode_odd =11'b0011_0000_1; addr_odd_ra =0; addr_odd_rb =0; addr_odd_rc =0; addr_odd_rt =70; imm10_odd =0; imm16_odd =127; imm18_odd =0; imm7_odd =0; flush = 0;$fdisplay(filehandle, "\nODD INSTRUCTION || Load Quadword (a-form)"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd);

      @(posedge clk) opcode_even =11'b0000_1000_001; addr_even_ra =25; addr_even_rb =20; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Or"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      // Test Instruction 2 - FLush 
      opcode_odd =11'b0011_1000_100; addr_odd_ra =127; addr_odd_rb =127; addr_odd_rc =120; addr_odd_rt =80; imm10_odd =0; imm16_odd =0; imm18_odd =0; imm7_odd =0;$fdisplay(filehandle, "\nODD INSTRUCTION || Load Quadword (x-form)"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd);
    
      @(posedge clk) opcode_even =11'b0101_1001_001; addr_even_ra =25; addr_even_rb =20; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Or with Complement"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      // Test Instruction 3 - FLush 
      opcode_odd =11'b0011_0000_1; addr_odd_ra =0; addr_odd_rb =0; addr_odd_rc =0; addr_odd_rt =70; imm10_odd =0; imm16_odd =127; imm18_odd =0; imm7_odd =0;$fdisplay(filehandle, "\nODD INSTRUCTION || Load Quadword (a-form) - Flushed"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd);

      @(posedge clk) opcode_even =11'b0000_0100; addr_even_ra =25; addr_even_rb =0; addr_even_rc =0; addr_even_rt =50; imm10_even =25; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Or Word Immediate"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      // Test Instruction 4 - FLush 
      opcode_odd =11'b0011_1000_100; addr_odd_ra =127; addr_odd_rb =127; addr_odd_rc =120; addr_odd_rt =80; imm10_odd =0; imm16_odd =0; imm18_odd =0; imm7_odd =0;$fdisplay(filehandle, "\nODD INSTRUCTION || Load Quadword (x-form) - Flushed"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd);
      
      @(posedge clk) opcode_even =11'b0000_1000_000; addr_even_ra =25; addr_even_rb =20; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Subtract from Word"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      // Branch Flush Test
			opcode_odd =11'b0; addr_odd_ra =0; addr_odd_rb =0; addr_odd_rc =0; addr_odd_rt =0; imm10_odd =0; imm16_odd =0; imm18_odd =0; imm7_odd =0; flush = 1; $fdisplay(filehandle, "\nODD INSTRUCTION || Branch Flush Test"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Even =\t\t      %d\n-> Flush =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd, flush);
    
      @(posedge clk) opcode_even =11'b0000_1100; addr_even_ra =25; addr_even_rb =0; addr_even_rc =0; addr_even_rt =50; imm10_even =20; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Subtract from Word Immediate"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even);       
      //First No - Op - Odd Pipe
			opcode_odd =11'b0100_0000_001; addr_odd_ra =0; addr_odd_rb =0; addr_odd_rc =55; addr_odd_rt =0; imm10_odd =0; imm16_odd =0; imm18_odd =0; imm7_odd =0; flush = 0; $fdisplay(filehandle, "\nODD INSTRUCTION || No Operation (Execute)"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Odd  = \t %b \n-> Addr_Odd_Ra =\t\t %d \n-> Addr_Odd_Rb = \t\t %d \n-> Addr_Odd_Rc =\t\t %d \n-> Imm7_Odd  =\t\t\t %d \n-> Imm10_Odd =\t\t\t%d \n-> Imm16_Odd =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_odd, addr_odd_ra, addr_odd_rb, addr_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd);
     
      @(posedge clk) opcode_even =11'b01101000001; addr_even_ra =126; addr_even_rb =127; addr_even_rc =125; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Subtract from Extended"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even);
      @(posedge clk) opcode_even =11'b0100_1000_001; addr_even_ra =25; addr_even_rb =20; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Exclusive Or"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      @(posedge clk) opcode_even =11'b0100_0110; addr_even_ra =25; addr_even_rb =0; addr_even_rc =0; addr_even_rt =50; imm10_even =20; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Exclusive Or Byte Immediate"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      @(posedge clk) opcode_even =11'b0100_0100; addr_even_ra =25; addr_even_rb =0; addr_even_rc =0; addr_even_rt =50; imm10_even =20; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Exclusive Or Word Immediate"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even);
      @(posedge clk) opcode_even =11'b01010110110; addr_even_ra =127; addr_even_rb =0; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Extend Sign Byte to Halfword"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even);
      @(posedge clk) opcode_even =11'b01010101110; addr_even_ra =127; addr_even_rb =0; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Extend Sign Halfword to Word"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even);
      @(posedge clk) opcode_even =11'b0101_0100_110; addr_even_ra =127; addr_even_rb =0; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Extend Sign Word to Doubleword"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      @(posedge clk) opcode_even =11'b0000_1010_011; addr_even_ra =20; addr_even_rb =25; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Absolute Differences of Bytes"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      @(posedge clk) opcode_even =11'b0001_1010_011; addr_even_ra =20; addr_even_rb =20; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Average Bytes"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      @(posedge clk) opcode_even =11'b0101_0110_100; addr_even_ra =20; addr_even_rb =0; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Count Ones in Bytes"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      @(posedge clk) opcode_even =11'b00001011000; addr_even_ra =126; addr_even_rb =126; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Rotate word"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even);
      @(posedge clk) opcode_even =11'b00001011001; addr_even_ra =126; addr_even_rb =126; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Rotate and mask word"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even);
      @(posedge clk) opcode_even =11'b00001011011; addr_even_ra =126; addr_even_rb =126; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Shift left word"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even);
      @(posedge clk) opcode_even =11'b00001111011; addr_even_ra =126; addr_even_rb =0; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =7;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Shift left word immediate"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even);
      @(posedge clk) opcode_even =11'b0100_1010_011; addr_even_ra =20; addr_even_rb =25; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Sum Bytes into Halfwords"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      @(posedge clk) opcode_even =11'b0111_1000_100; addr_even_ra =20; addr_even_rb =25; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Multiply"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      @(posedge clk) opcode_even =11'b1100_; addr_even_ra =20; addr_even_rb =25; addr_even_rc =20; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Multiply and Add"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      @(posedge clk) opcode_even =11'b0111_0100; addr_even_ra =20; addr_even_rb =0; addr_even_rc =0; addr_even_rt =50; imm10_even =25; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Multiply Immediate"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      @(posedge clk) opcode_even =11'b0111_1000_111; addr_even_ra =20; addr_even_rb =25; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Multiply and Shift Right"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      @(posedge clk) opcode_even =11'b0111_1001_100; addr_even_ra =20; addr_even_rb =25; addr_even_rc =0; addr_even_rt =50; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Multiply Unsigned"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      @(posedge clk) opcode_even =11'b0111_0101; addr_even_ra =20; addr_even_rb =0; addr_even_rc =0; addr_even_rt =50; imm10_even =20; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Multiply Unsigned Immediate"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
      @(posedge clk) opcode_even =11'b0101_1000_100; addr_even_ra =124; addr_even_rb =124; addr_even_rc =0; addr_even_rt =75; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Floating Add"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
		  @(posedge clk) opcode_even =11'b0101_1000_110; addr_even_ra =124; addr_even_rb =124; addr_even_rc =0; addr_even_rt =94; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Floating Multiply"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
		  @(posedge clk) opcode_even =11'b1110_; addr_even_ra =124; addr_even_rb =124; addr_even_rc =124; addr_even_rt =75; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Floating Multiply and Add"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
		  @(posedge clk) opcode_even =11'b1111_; addr_even_ra =124; addr_even_rb =124; addr_even_rc =124; addr_even_rt =94; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Floating Multiply and Subtract"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
		  @(posedge clk) opcode_even =11'b0101_1000_101; addr_even_ra =124; addr_even_rb =124; addr_even_rc =0; addr_even_rt =75; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || Floating Subtract"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
		  @(posedge clk) opcode_even =11'b0100_0000_001; addr_even_ra =0; addr_even_rb =0; addr_even_rc =45; addr_even_rt =0; imm10_even =0; imm16_even =0; imm18_even =0; imm7_even =0;$fdisplay(filehandle, "\nEVEN INSTRUCTION || No Operation (Execute)"); $fdisplay(filehandle, ">> Input at  :",$time," \n>> Output at :",($time+80)); $fdisplay(filehandle, "-> Opcode_Even  = \t %b \n-> Addr_Even_Ra =\t\t %d \n-> Addr_Even_Rb = \t\t %d \n-> Addr_Even_Rc =\t\t %d \n-> Imm7_Even  =\t\t\t %d \n-> Imm10_Even =\t\t\t%d \n-> Imm16_Even =\t\t       %d \n-> Imm18_Even =\t\t      %d\n", opcode_even, addr_even_ra, addr_even_rb, addr_even_rc, imm7_even, imm10_even, imm16_even, imm18_even); 
		  
  #1000 $fclose(filehandle); $finish; end
  initial begin       
      repeat(1000) begin
         @(posedge clk);
      end
      $display("Warning: Output not produced within 1000 clock cycles; stopping simulation so it doens't run forever");
      $stop;
   end

endmodule


//==============================================================================================================================