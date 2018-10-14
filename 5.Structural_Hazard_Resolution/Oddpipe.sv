
//=================================================== PARAMETERIZATION  =========================================================

parameter SIMPLE_FIXED1_UNIT      =1;     parameter SIMPLE_FIXED1_LATENCY      =2;
parameter SIMPLE_FIXED2_UNIT      =2;     parameter SIMPLE_FIXED2_LATENCY      =4;
parameter SINGLE_PRECISION1_UNIT  =3;     parameter SINGLE_PRECISION1_LATENCY  =6;
parameter SINGLE_PRECISION2_UNIT  =3;     parameter SINGLE_PRECISION2_LATENCY  =7;
parameter BYTE_UNIT               =4;     parameter BYTE_LATENCY               =4;
parameter PERMUTE_UNIT            =5;     parameter PERMUTE_LATENCY            =4; 
parameter LOCALSTORE_UNIT         =6;     parameter LOCALSTORE_LATENCY         =6; 
parameter BRANCH_UNIT             =7;     parameter BRANCH_LATENCY             =4;

//================================================  ODD PIPE  ==============================================================
module oddpipe(clk, reset, opcode_odd, addr_odd_rt, data_odd_ra, data_odd_rb, data_odd_rc, imm7_odd, imm10_odd, imm16_odd, imm18_odd, addr_odd_rt2, data_odd_rt, wr_en_odd,Pc_in, Pc_out_2, flush, Rt_Temp0_fwd, Rt_Temp1, Rt_Temp2, Rt_Temp3, Rt_Temp4, Rt_Temp5, Rt_Temp6);

    parameter WIDTH=8, SIZE=32768;

    input clk, reset, flush;
    input [0:6] addr_odd_rt;
    input [0:10] opcode_odd;
    input [0:6] imm7_odd;          // logic from TB
    input [0:9] imm10_odd;         // logic from TB
    input [0:15] imm16_odd;        // logic from TB
    input [0:17] imm18_odd;        // logic from TB
    input [0:14] Pc_in;           
    input signed [0:127] data_odd_ra, data_odd_rb, data_odd_rc;

    output [0:6] addr_odd_rt2;
    output logic signed [0:127] data_odd_rt;
    output logic wr_en_odd;
    output [0:14] Pc_out_2;
    output logic [0:175]Rt_Temp0_fwd, Rt_Temp1, Rt_Temp2, Rt_Temp3, Rt_Temp4, Rt_Temp5, Rt_Temp6;

    logic [0:14] Pc_out;
    logic [0:175] Rt_Temp7,Rt_Temp ;
    logic signed [0:31] addr_ls_temp, addr_ls;
    logic [0:13] LSA_val; 
    logic [0:127] Rt;   
    logic [0:2] latency_temp, unit_temp, latency, unit; 
    logic signed [0:127] data_in, data_out;
    logic [0:31] imm16_ext;
    logic [0:3] rb_bits;
    logic [0:31] shift_count;
    logic [0:4] rb_bits_2;
    logic wr_en, wr_en_ls, Br_Flag, Br_Flag_2, stop;
    integer i;


    //logic [0:16843008][0:31] mem;
    logic [0:127]mem[0:4096];

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
        Br_Flag = 1; end                                 // Branch Flush Signal
      else begin 
        Pc_out = (Pc_in + 4); 
        Br_Flag = 0; end                    // Branch Flush Signal
        Rt[0:127] = 128'd0;                // Optional
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
        Br_Flag = 1; end                                 // Branch Flush Signal
      else begin 
        Pc_out = (Pc_in + 4); 
        Br_Flag = 0;   end                  // Branch Flush Signal
        Rt[0:127] = 128'd0;                // Optional
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

      if(addr_odd_rt == 12) Rt=mem[169];
      else if(addr_odd_rt == 13) Rt=mem[170];
      else if(addr_odd_rt == 13) Rt=mem[171];
      else  begin
      for(int i=0; i<16; i=i+1)begin
            if(rb_bits_2==5'b0)
            Rt[(i*8)+: 8]=(data_odd_ra[(i*8)+: 8]);
            else if(rb_bits_2>15)
            Rt=128'b0;
            else 
            Rt=((data_odd_ra)<<(8*rb_bits_2));
      end  end
        $display("======={}{}{}}}{}{}{}{}{}{}}}{}=========> Ra: %b, ||| %d",data_odd_ra, rb_bits_2);
        $display("======={}{}{}}}{}{}{}{}{}{}}}{}=========> Shift Value Calculated: %b , %b, %b, %b", Rt[0:31], Rt[32:63], Rt[64:95], Rt[96:127]);
      wr_en = 1;  unit_temp = PERMUTE_UNIT; latency_temp = PERMUTE_LATENCY;
      end

    //58. Load Quadword (a-form)
    11'b0000_1100_001: begin
        for(i=0;i<14;i=i+1)
        imm16_ext[i]=imm16_odd[0]; 
        imm16_ext[14:29]=imm16_odd; imm16_ext[30:31]=2'b00;
        addr_ls = imm16_ext & 32'hfffffff0;
        Rt = data_out;
        wr_en = 1; wr_en_ls=0; unit_temp = LOCALSTORE_UNIT; latency_temp = LOCALSTORE_LATENCY;
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

      //70. No Operation_odd (Execute)
      11'b0100_0000_010:begin 
        Rt=128'b0; Pc_out = 128'b0; 
        wr_en = 0; 
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
     //Rt_Temp = {unit_temp, latency_temp, wr_en, addr_odd_rt, Rt, Pc_out, Br_Flag}; end
      begin
        Rt_Temp[0:2] = unit_temp;
        Rt_Temp[3:5] = latency_temp;
        Rt_Temp[6] = wr_en;
        Rt_Temp[7:14] = addr_odd_rt;
        Rt_Temp[15:142] = Rt;
        Rt_Temp[143:174] = Pc_out;
        Rt_Temp[175] = Br_Flag; end end
  
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
            Rt_Temp0_fwd = Rt_Temp;
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
       mem[80] = 128'b0;
       mem[96] = 128'b0;
       mem[112] = 128'b00111111100000000000000000000000_01000000000000000000000000000000_01000000010000000000000000000000_01000000100000000000000000000000; // A Reg Matrix 1 (1,2,3,4)
       //mem[112] = 128'h3F800000400000004040000040800000; // A Reg Matrix 1 (1,2,3,4)
       mem[128] = 128'b01000000101000000000000000000000_01000000111000000000000000000000_01000000101000000000000000000000_01000000111000000000000000000000; // B1 Reg Matrix (5 7 5 7)
       mem[160] = 128'b01000000110000000000000000000000_01000001000000000000000000000000_01000000110000000000000000000000_01000001000000000000000000000000; // B2 Reg Matrix (6 8 6 8)
      
       mem[169] = 128'b01000000000000000000000000000000_01000000010000000000000000000000_01000000100000000000000000000000_00000000000000000000000000000000;
       mem[170] = 128'b01000000111000000000000000000000_01000000101000000000000000000000_01000000111000000000000000000000_00000000000000000000000000000000; // B1 Reg Matrix (5 7 5 7)
       mem[171] = 128'b01000001000000000000000000000000_01000000110000000000000000000000_01000001000000000000000000000000_00000000000000000000000000000000; // B2 Reg Matrix (6 8 6 8)
      
      if (wr_en_ls==1) begin
       mem[addr_ls] = data_in; 
       mem[80] = 128'b0;
       mem[96] = 128'b0;
       mem[112] = 128'b00111111100000000000000000000000_01000000000000000000000000000000_01000000010000000000000000000000_01000000100000000000000000000000; // A Reg Matrix 1 (1,2,3,4)
       //mem[112] = 128'h3F800000400000004040000040800000; // A Reg Matrix 1 (1,2,3,4)
       mem[128] = 128'b01000000101000000000000000000000_01000000111000000000000000000000_01000000101000000000000000000000_01000000111000000000000000000000; // B1 Reg Matrix (5 7 5 7)
       mem[160] = 128'b01000000110000000000000000000000_01000001000000000000000000000000_01000000110000000000000000000000_01000001000000000000000000000000; // B2 Reg Matrix (6 8 6 8)
     end end
       
     always_comb begin
      if (wr_en_ls==0) begin
      data_out = mem[addr_ls]; end end

endmodule 