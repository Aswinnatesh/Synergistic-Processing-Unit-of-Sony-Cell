onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbench/clk
add wave -noupdate -divider {Test Bench}
add wave -noupdate /tbench/clk
add wave -noupdate -divider {Fetch Stage}
add wave -noupdate -radix decimal /tbench/dut/PC/pc
add wave -noupdate -divider {Decode Stage}
add wave -noupdate -radix binary /tbench/dut/Cache/Inst_out
add wave -noupdate -radix binary /tbench/dut/Decode/Even_inst1
add wave -noupdate -radix binary /tbench/dut/Decode/Even_inst2
add wave -noupdate -radix binary /tbench/dut/Decode/decode_stall_1
add wave -noupdate -divider Dependency
add wave -noupdate -radix binary -childformat {{{/tbench/dut/Decode/opcode_even[0]} -radix binary} {{/tbench/dut/Decode/opcode_even[1]} -radix binary} {{/tbench/dut/Decode/opcode_even[2]} -radix binary} {{/tbench/dut/Decode/opcode_even[3]} -radix binary} {{/tbench/dut/Decode/opcode_even[4]} -radix binary} {{/tbench/dut/Decode/opcode_even[5]} -radix binary} {{/tbench/dut/Decode/opcode_even[6]} -radix binary} {{/tbench/dut/Decode/opcode_even[7]} -radix binary} {{/tbench/dut/Decode/opcode_even[8]} -radix binary} {{/tbench/dut/Decode/opcode_even[9]} -radix binary} {{/tbench/dut/Decode/opcode_even[10]} -radix binary}} -subitemconfig {{/tbench/dut/Decode/opcode_even[0]} {-height 16 -radix binary} {/tbench/dut/Decode/opcode_even[1]} {-height 16 -radix binary} {/tbench/dut/Decode/opcode_even[2]} {-height 16 -radix binary} {/tbench/dut/Decode/opcode_even[3]} {-height 16 -radix binary} {/tbench/dut/Decode/opcode_even[4]} {-height 16 -radix binary} {/tbench/dut/Decode/opcode_even[5]} {-height 16 -radix binary} {/tbench/dut/Decode/opcode_even[6]} {-height 16 -radix binary} {/tbench/dut/Decode/opcode_even[7]} {-height 16 -radix binary} {/tbench/dut/Decode/opcode_even[8]} {-height 16 -radix binary} {/tbench/dut/Decode/opcode_even[9]} {-height 16 -radix binary} {/tbench/dut/Decode/opcode_even[10]} {-height 16 -radix binary}} /tbench/dut/Decode/opcode_even
add wave -noupdate -radix binary /tbench/dut/Decode/opcode_odd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 12} {25 ns} 0} {{Cursor 13} {165 ns} 0} {{Cursor 14} {35 ns} 0} {{Cursor 15} {45 ns} 0} {{Cursor 16} {55 ns} 0} {{Cursor 17} {65 ns} 0} {{Cursor 18} {75 ns} 0} {{Cursor 19} {85 ns} 0} {{Cursor 20} {115 ns} 0}
quietly wave cursor active 9
configure wave -namecolwidth 400
configure wave -valuecolwidth 238
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
WaveRestoreZoom {0 ns} {161 ns}
