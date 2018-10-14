
//=================================================== PARAMETERIZATION  =========================================================

parameter SIMPLE_FIXED1_UNIT      =1;     parameter SIMPLE_FIXED1_LATENCY      =2;
parameter SIMPLE_FIXED2_UNIT      =2;     parameter SIMPLE_FIXED2_LATENCY      =4;
parameter SINGLE_PRECISION1_UNIT  =3;     parameter SINGLE_PRECISION1_LATENCY  =6;
parameter SINGLE_PRECISION2_UNIT  =3;     parameter SINGLE_PRECISION2_LATENCY  =7;
parameter BYTE_UNIT               =4;     parameter BYTE_LATENCY               =4;
parameter PERMUTE_UNIT            =5;     parameter PERMUTE_LATENCY            =4; 
parameter LOCALSTORE_UNIT         =6;     parameter LOCALSTORE_LATENCY         =6; 
parameter BRANCH_UNIT             =7;     parameter BRANCH_LATENCY             =4;
//====================================================    EVEN PIPE    ========================================================

module evenpipe(clk, reset, opcode_even, data_even_ra, data_even_rb, data_even_rc, imm7_even, imm10_even, imm16_even, imm18_even, addr_even_rt, data_even_rt, addr_even_rt2, wr_en_even, Rt_Temp, Rt_Temp1, Rt_Temp2, Rt_Temp3, Rt_Temp4, Rt_Temp5, Rt_Temp6); 

input clk, reset;
input [0:6] addr_even_rt;
input [0:10] opcode_even;
input signed [0:6] imm7_even;          // logic from TB
input signed [0:9] imm10_even;         // logic from TB
input signed [0:15] imm16_even;        // logic from TB
input signed [0:17] imm18_even;        // logic from TB
input signed [0:127] data_even_ra, data_even_rb, data_even_rc;
output logic signed [0:127] data_even_rt;
output logic [0:6] addr_even_rt2;
output logic wr_en_even;

logic firstbit, wr_en, stop;
output logic [0:142] Rt_Temp,Rt_Temp1, Rt_Temp2, Rt_Temp3, Rt_Temp4, Rt_Temp5, Rt_Temp6;

logic [0:142]  Rt_Temp7,Rt_Temp0_fwd;
logic signed [0:31]temp_imm10, temp_imm;
logic signed [0:127] Rt; 
logic [0:2] count;
logic [0:2] latency_temp, unit_temp, latency, unit;
logic [0:7] b, ra_byte;
logic [0:31] bbbb, rb_word;
logic [0:63] shift_count;
logic [0:127] rt_temp;

logic [0:142] Rt_test_even;

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
        $display("=======|||||||||||||||||=========> Rb: %b",data_even_rb);
        $display("=======|||||||||||||||||=========> 2x2 Value 1 Calculated: %b , %b, %b, %b", Rt[0:31], Rt[32:63], Rt[64:95], Rt[96:127]);

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

      //71. No Operation Even(Execute)
      11'b0100_0000_001:begin 
        Rt=128'b0;
        wr_en = 0; 
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
      Rt_Temp = 143'b0;
    else 
      //Rt_Temp = {unit_temp, latency_temp, wr_en, addr_even_rt, Rt}; 
      Rt_Temp[0:2] =  unit_temp;
      Rt_Temp[3:5] =  latency_temp;
      Rt_Temp[6] =  wr_en;
      Rt_Temp[7:14] =  addr_even_rt;
      Rt_Temp[15:142] =  Rt;

      Rt_test_even = Rt_Temp;
      //$display ("=====REG======>>> unit_temp:%d , latency_temp:%d , wr_en:%d , addr_even_rt:%d , Rt:%d", Rt_Temp[0:2], latency_temp, wr_en, addr_even_rt, Rt);
      //$display ("Whole Word:%b", stop);
    end

    always_ff @(posedge clk) begin
        Rt_Temp0_fwd = Rt_Temp;
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
