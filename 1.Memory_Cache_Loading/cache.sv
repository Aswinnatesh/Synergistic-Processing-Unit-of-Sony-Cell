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
module SPU_Cell(clk, reset, inst_feed, Instruction_1_2, wr_en);

input clk, reset, wr_en;
input  [0:31] inst_feed [0:127];
output [0:63] Instruction_1_2; // Output Instructions after Cache

logic imiss;
logic [0:14] pc;
logic  [0:14] Cache_load_addr;
logic  [0:1023] Cache_load_data;

Local_Store ls( .clk(clk),
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

PC pgr_ctr    (.clk(clk),
               .reset(reset),
               .pc(pc),
               .imiss(imiss));

endmodule

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
  end

  always_ff @(posedge clk) begin
  if (reset) begin
      $display($time, " Local Store Memory Instruction 1:%b_%b_%b_%b",local_st[0], local_st[1], local_st[2], local_st[3]);
      $display($time, " Local Store Memory Instruction 2:%b_%b_%b_%b",local_st[4], local_st[5], local_st[6], local_st[7]);
      $display($time, " Local Store Memory Instruction 3:%b_%b_%b_%b",local_st[8], local_st[9], local_st[10], local_st[11]);
      $display($time, " Local Store Memory Instruction 4:%b_%b_%b_%b",local_st[12], local_st[13], local_st[14], local_st[15]);
      $display($time, " Local Store Memory Instruction 5:%b_%b_%b_%b",local_st[16], local_st[17], local_st[18], local_st[19]);
      $display($time, " Local Store Memory Instruction 6:%b_%b_%b_%b",local_st[20], local_st[21], local_st[22], local_st[23]);
      $display($time, " Local Store Memory Instruction 7:%b_%b_%b_%b",local_st[24], local_st[25], local_st[26], local_st[27]);
end end
  
endmodule

//$display("Cache 01:%b_%b_%b_%b",Cache[0],Cache[1],Cache[2],Cache[3]);
//=======================================================  PRG CTR  ============================================================== (0 CYCLE LAT)
module PC(clk, reset, pc, imiss);
 
 input clk, reset, imiss;
 output logic [0:14] pc;

 always_ff @(posedge clk) begin 
 //$display("Program Counter:%d", pc); 
   if(reset)
      pc = 0;
    else if(imiss)
      pc = pc;
   else 
      pc = pc + 8;
 end

endmodule

//================================================= CACHE ILB & PGR CTR =========================================================== (1 CYCLE LAT)

module Cache (clk, reset, Cache_load_addr, Cache_load_data, pc, Inst_out, imiss);

integer i, j;
input clk, reset;
input [0:14] pc;
output logic [0:14] Cache_load_addr;
output logic [0:63] Inst_out;
input [0:1023] Cache_load_data;
output logic imiss;

logic [0:7] Cache [0:511]; 
logic Cache_valid_B1, Cache_valid_B2, Cache_valid_B3, Cache_valid_B4; // 4 Valid Bits 
logic [0:7] Cache_tag_B1,Cache_tag_B2,Cache_tag_B3,Cache_tag_B4; // 4 Valid Bits 

always_comb begin 
// $display("imiss:%b",imiss);
if((imiss==1)&&(pc[0:14] >=0)) begin Cache_valid_B1 = 1'b1; $display("Cache_valid_B1:%b", Cache_valid_B1); end
if((imiss==1)&&(pc[0:14] >=128))begin Cache_valid_B2 = 1'b1; $display("Cache_valid_B2:%b", Cache_valid_B2); end
if((imiss==1)&&(pc[0:14] >=256))begin Cache_valid_B2 = 1'b1; $display("Cache_valid_B3:%b", Cache_valid_B3); end
if((imiss==1)&&(pc[0:14] >=384))begin Cache_valid_B3 = 1'b1; $display("Cache_valid_B4:%b", Cache_valid_B4); end
if((imiss==1)&&(pc[7]==0 & pc[8]==0))begin Cache_tag_B1=pc[0:7]; $display("Cache_tag_B1:%b", Cache_tag_B1); end
if((imiss==1)&&(pc[7]==0 & pc[8]==1))begin Cache_tag_B2=pc[0:7]; $display("Cache_tag_B2:%b", Cache_tag_B2); end
if((imiss==1)&&(pc[7]==1 & pc[8]==0))begin Cache_tag_B3=pc[0:7]; $display("Cache_tag_B3:%b", Cache_tag_B3); end
if((imiss==1)&&(pc[7]==1 & pc[8]==1))begin Cache_tag_B4=pc[0:7]; $display("Cache_tag_B4:%b", Cache_tag_B4); end
end

always_ff @(posedge clk) begin // Cache Hit - Passing - Output
  if((Cache_valid_B1 == 1)&&(pc[0:7]==Cache_tag_B1)) begin $display ("Hit 01");
    for(j=0;j<64;j=j+8) begin
      imiss = 0;
      Inst_out[j+:8] = Cache[j/8+pc[9:14]]; 
    end 
      //$display("Program Counter_ Block Offset: %d",pc[8:14]);
      //$display("Cache Hit Instruction Block 1:%b, -- %b",Inst_out[0:31], Inst_out[32:63]);
    end
  
  else if ((Cache_valid_B2 == 1)&&(pc[0:7]==Cache_tag_B2)) begin $display ("Hit 02");
    for(j=0;j<64;j=j+8) begin
      imiss = 0;
      Inst_out[j+:8] = Cache[j/8+pc[9:14]+128]; 
    end end 
  
  else if ((Cache_valid_B3 == 1)&&(pc[0:7]==Cache_tag_B3)) begin $display ("Hit 03");
    for(j=0;j<64;j=j+8) begin 
      imiss = 0;
      Inst_out[j+:8] = Cache[j/8+pc[9:14]+256]; 
    end end
  
  else if ((Cache_valid_B4 == 1)&&(pc[0:7]==Cache_tag_B4)) begin $display ("Hit 04");
    for(j=0;j<64;j=j+8) begin
      imiss = 0;
      Inst_out[j+:8] = Cache[j/8+pc[9:14]+384]; 
    end end

  else begin
      imiss=1; //$display ("-----------Default of Else");
      Inst_out[0:10] <= 11'b0100_0000_001; Inst_out[32:42] <= 11'b0000_0000_111; end
end

always_comb begin // Cache Miss - Loading - Input
if(imiss == 1 & reset!=1) begin
  if(pc[7]==0 & pc[8]==0)begin
    $display("Cache Miss Loading Block 1");
    for (i=0;i<128;i=i+1) begin
      Cache[i]= Cache_load_data[i*8+:8];end
      $display($time, " Cache Block 1 Instruction 1:%b_%b_%b_%b",Cache[0], Cache[1], Cache[2], Cache[3]);
      $display($time, " Cache Block 1 Instruction 2:%b_%b_%b_%b",Cache[4], Cache[5], Cache[6], Cache[7]);
      $display($time, " Cache Block 1 Instruction 3:%b_%b_%b_%b",Cache[8], Cache[9], Cache[10], Cache[11]);
      $display($time, " Cache Block 1 Instruction 4:%b_%b_%b_%b",Cache[12], Cache[13], Cache[14], Cache[15]);
      $display($time, " Cache Block 1 Instruction 5:%b_%b_%b_%b",Cache[16], Cache[17], Cache[18], Cache[19]);
      $display($time, " Cache Block 1 Instruction 6:%b_%b_%b_%b",Cache[20], Cache[21], Cache[22], Cache[23]);
      $display($time, " Cache Block 1 Instruction 7:%b_%b_%b_%b",Cache[24], Cache[25], Cache[26], Cache[27]);
      //$display("Cache Block 1 Data Received:%b",Cache_load_data); end
      //$display("Instruction 1 in Cache:%b_%b_%b_%b",Cache[0],Cache[1],Cache[2], Cache[3]);
  end end
  else if(pc[7]==0 & pc[8]==1)begin
    $display("Cache Miss Loading Block 2");
    for (i=0;i<128;i=i+1) begin
      Cache[i]= Cache_load_data[i*8+:8];end
  end
  else if(pc[7]==1 & pc[8]==0)begin
    $display("Cache Miss Loading Block 3");
    for (i=0;i<128;i=i+1) begin
      Cache[i]= Cache_load_data[i*8+:8];end
  end
  else if(pc[7]==1 & pc[8]==1)begin
    $display("Cache Miss Loading Block 4");
    for (i=0;i<128;i=i+1) begin
      Cache[i]= Cache_load_data[i*8+:8];end
  end 
end

endmodule


//==================================================Test Bench for Cache==========================================================

module tbench();

logic clk, reset, wr_en;
logic [0:63] Instruction_1_2; // Output Instructions after Cache
logic [0:31] inst_feed [0:127];

SPU_Cell dut(.clk(clk), 
      .reset(reset),
      .inst_feed(inst_feed),
      .Instruction_1_2(Instruction_1_2),
      .wr_en(wr_en));

initial begin clk = 0; wr_en = 1; end
always #5 clk = ~clk;

initial begin
  //$monitor($time,,"Instruction_1=%b, Instruction_2=%b", Instruction_1_2[0:31], Instruction_1_2[32:63]);
  $readmemb("Instruction.txt", inst_feed); 

  // for(int l=0; l<127; l=l+1) // Check if Data is read Properly from File
  // $display("inst_feed:%b",inst_feed[l]);

  @(posedge clk) 
  #1 reset = 1;
  @(posedge clk) 
  #1 reset = 0;
// end

// initial begin
  @(posedge clk);
  @(posedge clk);
  @(posedge clk);

#60 $finish; 

end
 initial begin       
        repeat(1000) begin
         @(posedge clk);
       end
       $display("Warning: Output not produced within 1000 clock cycles; stopping simulation so it doens't run forever");
       $stop;
     end

endmodule