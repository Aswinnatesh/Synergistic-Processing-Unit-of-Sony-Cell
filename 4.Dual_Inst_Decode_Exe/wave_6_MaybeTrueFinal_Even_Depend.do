onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbench/clk
add wave -noupdate /tbench/clk
add wave -noupdate -divider {Test Bench}
add wave -noupdate /tbench/clk
add wave -noupdate -divider {Fetch Stage}
add wave -noupdate -radix decimal /tbench/dut/PC/pc
add wave -noupdate -radix binary /tbench/dut/Decode/decode_stall_1
add wave -noupdate -radix binary /tbench/dut/Dependency/Dependency_stall
add wave -noupdate /tbench/dut/Cache/imiss
add wave -noupdate -divider {Decode Stage}
add wave -noupdate -radix binary /tbench/dut/Cache/Inst_out
add wave -noupdate -radix binary /tbench/dut/Decode/Even_inst1
add wave -noupdate -radix binary /tbench/dut/Decode/Even_inst2
add wave -noupdate -radix binary /tbench/dut/Decode/opcode_even_tmp
add wave -noupdate -radix binary /tbench/dut/Decode/opcode_even_bck
add wave -noupdate -radix binary /tbench/dut/Decode/opcode_odd_tmp
add wave -noupdate -radix binary /tbench/dut/Decode/opcode_odd_bck
add wave -noupdate -divider Dependency
add wave -noupdate -radix binary -childformat {{{/tbench/dut/Decode/opcode_even[0]} -radix binary} {{/tbench/dut/Decode/opcode_even[1]} -radix binary} {{/tbench/dut/Decode/opcode_even[2]} -radix binary} {{/tbench/dut/Decode/opcode_even[3]} -radix binary} {{/tbench/dut/Decode/opcode_even[4]} -radix binary} {{/tbench/dut/Decode/opcode_even[5]} -radix binary} {{/tbench/dut/Decode/opcode_even[6]} -radix binary} {{/tbench/dut/Decode/opcode_even[7]} -radix binary} {{/tbench/dut/Decode/opcode_even[8]} -radix binary} {{/tbench/dut/Decode/opcode_even[9]} -radix binary} {{/tbench/dut/Decode/opcode_even[10]} -radix binary}} -subitemconfig {{/tbench/dut/Decode/opcode_even[0]} {-height 16 -radix binary} {/tbench/dut/Decode/opcode_even[1]} {-height 16 -radix binary} {/tbench/dut/Decode/opcode_even[2]} {-height 16 -radix binary} {/tbench/dut/Decode/opcode_even[3]} {-height 16 -radix binary} {/tbench/dut/Decode/opcode_even[4]} {-height 16 -radix binary} {/tbench/dut/Decode/opcode_even[5]} {-height 16 -radix binary} {/tbench/dut/Decode/opcode_even[6]} {-height 16 -radix binary} {/tbench/dut/Decode/opcode_even[7]} {-height 16 -radix binary} {/tbench/dut/Decode/opcode_even[8]} {-height 16 -radix binary} {/tbench/dut/Decode/opcode_even[9]} {-height 16 -radix binary} {/tbench/dut/Decode/opcode_even[10]} {-height 16 -radix binary}} /tbench/dut/Decode/opcode_even
add wave -noupdate -radix binary /tbench/dut/Decode/opcode_odd
add wave -noupdate -radix decimal /tbench/dut/Dependency/count
add wave -noupdate -radix decimal /tbench/dut/Dependency/counter
add wave -noupdate -radix binary /tbench/dut/Dependency/Prev_Stall
add wave -noupdate -radix binary /tbench/dut/Dependency/opcode_even_depend2
add wave -noupdate -radix binary /tbench/dut/Dependency/opcode_even_depend_bck
add wave -noupdate -radix binary /tbench/dut/Dependency/opcode_odd_depend_bck
add wave -noupdate -radix binary /tbench/dut/Dependency/opcode_odd_depend2
add wave -noupdate -divider {Reg File}
add wave -noupdate -radix binary /tbench/dut/reg_file/opcode_even
add wave -noupdate -radix binary /tbench/dut/reg_file/opcode_odd
add wave -noupdate -divider {Even Pipe Packet}
add wave -noupdate -radix binary /tbench/dut/reg_file/evenp/opcode_even
add wave -noupdate -radix decimal /tbench/dut/reg_file/evenp/Rt
add wave -noupdate -radix decimal /tbench/dut/reg_file/evenp/wr_en
add wave -noupdate -radix decimal /tbench/dut/reg_file/evenp/addr_even_rt
add wave -noupdate -divider {Odd Pipe Packet}
add wave -noupdate -radix binary /tbench/dut/reg_file/oddp/opcode_odd
add wave -noupdate -radix binary /tbench/dut/reg_file/oddp/Rt
add wave -noupdate -radix decimal /tbench/dut/reg_file/oddp/wr_en
add wave -noupdate -radix decimal /tbench/dut/reg_file/oddp/addr_odd_rt
add wave -noupdate -radix decimal /tbench/dut/reg_file/oddp/addr_ls
add wave -noupdate -divider {Data in Even Pipe Stage 1}
add wave -noupdate -radix decimal /tbench/dut/reg_file/evenp/imm7_even
add wave -noupdate -radix decimal /tbench/dut/reg_file/evenp/imm10_even
add wave -noupdate -radix decimal /tbench/dut/reg_file/evenp/imm16_even
add wave -noupdate -radix decimal /tbench/dut/reg_file/evenp/imm18_even
add wave -noupdate -radix decimal /tbench/dut/reg_file/evenp/data_even_ra
add wave -noupdate -radix decimal /tbench/dut/reg_file/evenp/data_even_rb
add wave -noupdate -radix decimal /tbench/dut/reg_file/evenp/data_even_rc
add wave -noupdate -radix decimal /tbench/dut/reg_file/evenp/data_even_rt
add wave -noupdate -divider {Data in Odd Pipe Stage 1}
add wave -noupdate -radix decimal /tbench/dut/reg_file/oddp/imm7_odd
add wave -noupdate -radix decimal /tbench/dut/reg_file/oddp/imm10_odd
add wave -noupdate -radix decimal /tbench/dut/reg_file/oddp/imm16_odd
add wave -noupdate -radix decimal /tbench/dut/reg_file/oddp/imm18_odd
add wave -noupdate -radix decimal /tbench/dut/reg_file/oddp/data_odd_ra
add wave -noupdate -radix decimal /tbench/dut/reg_file/oddp/data_odd_rb
add wave -noupdate -radix decimal /tbench/dut/reg_file/oddp/data_odd_rc
add wave -noupdate -radix decimal /tbench/dut/reg_file/oddp/data_odd_rt
add wave -noupdate -radix decimal /tbench/dut/Decode/addr_odd_rt
add wave -noupdate -radix decimal /tbench/dut/Dependency/addr_odd_rt_depend
add wave -noupdate -radix decimal /tbench/dut/reg_file/addr_odd_rt
add wave -noupdate /tbench/dut/reg_file/evenp/data_even_ra
add wave -noupdate /tbench/dut/reg_file/evenp/data_even_rb
add wave -noupdate /tbench/dut/reg_file/evenp/data_even_rc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 11} {15 ns} 0} {{Cursor 12} {25 ns} 0} {{Cursor 13} {35 ns} 0} {{Cursor 14} {43 ns} 0} {{Cursor 15} {55 ns} 0} {{Cursor 16} {75 ns} 0} {{Cursor 17} {90 ns} 0} {{Cursor 18} {105 ns} 0} {{Cursor 19} {145 ns} 0}
quietly wave cursor active 4
configure wave -namecolwidth 387
configure wave -valuecolwidth 80
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {800 ns}
