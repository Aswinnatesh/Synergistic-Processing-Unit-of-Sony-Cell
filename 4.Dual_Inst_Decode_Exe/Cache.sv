
//=====================================================  LOCAL STORE  =========================================================== (0 CYCLE LAT)

module Local_Store (clk, reset, data_in, data_out, addr, wr_en, pc, imiss);

  input clk, reset, wr_en, imiss;
  input [0:14] pc;
  input [0:31] data_in [0:127];
  input [0:14] addr;
  output logic [0:1023] data_out;

  integer i; 

  logic [0:7] local_st [0:32768]; // 32 KB Local Store
  logic [0:31] data_in_tmp;
  
  always_comb begin 
  if (wr_en) begin
    for(i=0;i<127;i=i+1) begin
      data_in_tmp = data_in[i];
      for(int k=0; k<4; k=k+1) begin
      local_st[(4*i)+k]   = data_in_tmp[(k*8)+:8]; end
    end
  end

  if  (imiss == 1) begin
    for (int j=0; j<128;j=j+1) begin
        data_out[j*8+:8] = local_st[j+pc];   
  end end
  //$display("Local_St Addr: %b, Data Out:%b",addr, data_out); 
end
  
endmodule

//$display("Cache 01:%b_%b_%b_%b",Cache[0],Cache[1],Cache[2],Cache[3]);
//=======================================================  PRG CTR  ============================================================== (0 CYCLE LAT)
module PC(clk, reset, pc, imiss, decode_stall_1, Dependency_stall);
 
 input clk, reset, imiss, decode_stall_1, Dependency_stall;
 output logic [0:14] pc; logic [0:14] pc_old; 


  always_ff @(posedge clk) begin
    if (reset) pc = 0; end

  always_ff @(posedge clk) begin

    if(imiss || decode_stall_1 || Dependency_stall) pc<=pc;
    //else if (Dependency_stall) pc = pc_old; 

    else begin
      pc <= pc +8;
      pc_old <= pc; end
  end 

 // always_comb begin 
 //   if(reset)
 //      pc = 0;
 //    else if(imiss)
 //      pc = pc;
 //    else if (decode_stall_1) pc = pc;
 //    else if(Dependency_stall) pc = pc;// - 8;
 //    else 
 //      pc = pc + 8;
 //      pc_NonBlock <= pc;   
 //   $display("Program Counter:%d", pc_NonBlock); 
 // end


endmodule

//================================================= CACHE ILB =========================================================== (1 CYCLE LAT)

module Cache (clk, reset, Cache_load_addr, Cache_load_data, pc, Inst_out, imiss);

integer i, j;
input clk, reset;
input [0:14] pc;
output logic [0:14] Cache_load_addr;
output logic [0:63] Inst_out;
input [0:1023] Cache_load_data;
output logic imiss;

logic [0:31] Inst_Fetch_1, Inst_Fetch_2; 
logic [0:7] Cache [0:511]; 
logic Cache_valid_B1, Cache_valid_B2, Cache_valid_B3, Cache_valid_B4; // 4 Valid Bits 
logic [0:7] Cache_tag_B1,Cache_tag_B2,Cache_tag_B3,Cache_tag_B4; // 4 Valid Bits 

always_comb begin 
// $display("imiss:%b",imiss);
if((imiss==1)&&(pc[0:14] >=0)) begin Cache_valid_B1 = 1'b1; end//$display("Cache_valid_B1:%b", Cache_valid_B1); end
if((imiss==1)&&(pc[0:14] >=128))begin Cache_valid_B2 = 1'b1;end//$display("Cache_valid_B2:%b", Cache_valid_B2); end
if((imiss==1)&&(pc[0:14] >=256))begin Cache_valid_B2 = 1'b1; end//$display("Cache_valid_B3:%b", Cache_valid_B3); end
if((imiss==1)&&(pc[0:14] >=384))begin Cache_valid_B3 = 1'b1; end//$display("Cache_valid_B4:%b", Cache_valid_B4); end
if((imiss==1)&&(pc[7]==0 & pc[8]==0))begin Cache_tag_B1=pc[0:7]; end//$display("Cache_tag_B1:%b", Cache_tag_B1); end
if((imiss==1)&&(pc[7]==0 & pc[8]==1))begin Cache_tag_B2=pc[0:7]; end//$display("Cache_tag_B2:%b", Cache_tag_B2); end
if((imiss==1)&&(pc[7]==1 & pc[8]==0))begin Cache_tag_B3=pc[0:7]; end//$display("Cache_tag_B3:%b", Cache_tag_B3); end
if((imiss==1)&&(pc[7]==1 & pc[8]==1))begin Cache_tag_B4=pc[0:7]; end//$display("Cache_tag_B4:%b", Cache_tag_B4); end
end

assign Inst_Fetch_1 = Inst_out[0:10];
assign Inst_Fetch_2 = Inst_out[32:42];

always_ff @(posedge clk) begin // Cache Hit - Passing - Output
  if((Cache_valid_B1 == 1)&&(pc[0:7]==Cache_tag_B1)) begin //$display ("Hit 01");
    for(j=0;j<64;j=j+8) begin
      imiss = 0;
      Inst_out[j+:8] = Cache[j/8+pc[9:14]]; 
    end 
      //$display("Program Counter_ Block Offset: %d",pc[8:14]);
      //$display("Cache Hit Instruction Block 1:%b, -- %b",Inst_out[0:31], Inst_out[32:63]);
    end
  
  else if ((Cache_valid_B2 == 1)&&(pc[0:7]==Cache_tag_B2)) begin //$display ("Hit 02");
    for(j=0;j<64;j=j+8) begin
      imiss = 0;
      Inst_out[j+:8] = Cache[j/8+pc[9:14]+128]; 
    end end 
  
  else if ((Cache_valid_B3 == 1)&&(pc[0:7]==Cache_tag_B3)) begin //$display ("Hit 03");
    for(j=0;j<64;j=j+8) begin 
      imiss = 0;
      Inst_out[j+:8] = Cache[j/8+pc[9:14]+256]; 
    end end
  
  else if ((Cache_valid_B4 == 1)&&(pc[0:7]==Cache_tag_B4)) begin //$display ("Hit 04");
    for(j=0;j<64;j=j+8) begin
      imiss = 0;
      Inst_out[j+:8] = Cache[j/8+pc[9:14]+384]; 
    end end

  else begin
      imiss=1; //$display ("-----------Default of Else");
      Inst_out[0:10] <= 11'b0100_0000_001; Inst_out[32:42] <= 11'b0100_0000_010; end // Pass Imiss Later
end

always_comb begin // Cache Miss - Loading - Input
if(imiss == 1) begin
  if(pc[7]==0 & pc[8]==0)begin
    //$display("Cache Miss Loading Block 1");
    for (i=0;i<128;i=i+1) begin
      Cache[i]= Cache_load_data[i*8+:8];end
     // $display("Cache Block 1 Instruction 1:%b_%b_%b_%b",Cache[0], Cache[1], Cache[2], Cache[3]);
     // $display("Cache Block 1 Instruction 2:%b_%b_%b_%b",Cache[4], Cache[5], Cache[6], Cache[7]);
     // $display("Cache Block 1 Instruction 3:%b_%b_%b_%b",Cache[8], Cache[9], Cache[10], Cache[11]);
     // $display("Cache Block 1 Instruction 4:%b_%b_%b_%b",Cache[12], Cache[13], Cache[14], Cache[15]);
     // $display("Cache Block 1 Instruction 5:%b_%b_%b_%b",Cache[16], Cache[17], Cache[18], Cache[19]);
     // $display("Cache Block 1 Instruction 6:%b_%b_%b_%b",Cache[20], Cache[21], Cache[22], Cache[23]);
     // $display("Cache Block 1 Instruction 7:%b_%b_%b_%b",Cache[24], Cache[25], Cache[26], Cache[27]);
      //$display("Cache Block 1 Data Received:%b",Cache_load_data); end
      //$display("Instruction 1 in Cache:%b_%b_%b_%b",Cache[0],Cache[1],Cache[2], Cache[3]);
  end end
  else if(pc[7]==0 & pc[8]==1)begin
    //$display("Cache Miss Loading Block 2");
    for (i=0;i<128;i=i+1) begin
      Cache[i]= Cache_load_data[i*8+:8];end
  end
  else if(pc[7]==1 & pc[8]==0)begin
    //$display("Cache Miss Loading Block 3");
    for (i=0;i<128;i=i+1) begin
      Cache[i]= Cache_load_data[i*8+:8];end
  end
  else if(pc[7]==1 & pc[8]==1)begin
    //$display("Cache Miss Loading Block 4");
    for (i=0;i<128;i=i+1) begin
      Cache[i]= Cache_load_data[i*8+:8];end
  end 
end

endmodule

