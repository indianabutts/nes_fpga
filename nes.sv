module nes(
	   );


   //Parameters
   //IO Memory Map
   parameter ppu_address_mask_result = 16'h2000;
   parameter dma_address = 16'h4014;
   parameter sound_channel_switch = 16'h4015;
   parameter joystick1 = 16'h4016;
   parameter joystick2 = 16'h4017;
   //CPU memory map
   parameter zero_page_start = 16'h0000;
   parameter zero_page_end = 16'h00FF;
   parameter stack_start = 16'h0100;
   parameter stack_end = 16'h01FF;
   parameter ram_start = 16'h0200;
   parameter ram_end = 16'h07FF;
   parameter expansion_start = 16'h4020;
   parameter expansion_end = 16'h5FFF;
   parameter sram_start = 16'h7FFF;
   parameter prg_rom_start = 16'h8000;
   parameter prg_rom_end = 16'hFFFF;
   //PPU VRAM Memory Map
   parameter pattern_table_0_mask_result = 16'h0000;//Lower CHR
   parameter pattern_table_1_mask_result = 16'h1000;//Upper CHR
   
$2000-$23FF	 $0400	 Name Table #0
$2400-$27FF	 $0400	 Name Table #1
$2800-$2BFF	 $0400	 Name Table #2
$2C00-$2FFF	 $0400	 Name Table #3
$3000-$3EFF	 $0F00	 Mirrors of $2000-$2FFF
$3F00-$3F1F	 $0020	 Palette RAM indexes [not RGB values]
$3F20-$3FFF	 $0080	 Mirrors of $3F00-$3F1F
   
   
   //Global Logic
   logic clk_wire;
   logic n_reset_wire;
   //PPU Logic 
   logic ppu_r_nw_wire;
   logic ppu_n_sync_wire;
   logic ppu_n_cs_wire;
   logic ppu_n_ale_wire;
   logic ppu_data_address_out_wire;
   logic [5:0] ppu_address_out_wire;
   //CPU Logic Wire
   logic       cpu_r_wire;
   logic       cpu_nmi_wire;
   logic       cpu_w_wire;
   logic [15:0] cpu_address_wire;
   logic [7:0] 	cpu_data_in_wire;
   logic [7:0] 	cpu_data_out_wire;
   logic 	cpu_sync_wire;
   
   //ppu address resolution
   assign ppu_n_cs_wire = ((16'hF000&cpu_address_wire)
			   == ppu_address_mask_result)?
			  ppu_n_cs_wire=0:ppu_n_cs_wire=1;
   
   ppu inst_ppu (
		 .clk(clk_wire),
		 .n_reset(n_reset_wire),
		 .r_nw(ppu_r_nw_wire),
		 .n_cs(ppu_n_cs_wire),
		 .n_sync(ppu_n_sync_wire),
		 .cpu_a_in(cpu_address_wire[2:0]), //3 bits
		 .cpu_data_in(cpu_data_out_wire), //8-bits
		 .vram_data_in(), //8-bits
		 .ale(ppu_ale_wire),
		 .ppu_address_out(ppu_address_out_wire), //6-bits
		 .cpu_data_out(cpu_data_in_wire),//8-bits
		 .vram_data_address_out(),//8-bits
		 .n_r(!cpu_r_wire),
		 .n_w(!cpu_w_wire),
		 .n_vbl(cpu_nmi_wire)
		 );
   
   
   core_6502 inst_6502(
		       .clk(clk_wire),
		       .reset(n_reset_wire),
		       .irq_in(),
		       .nmi_in(!cpu_n_nmi_wire),
		       .addr_pin(cpu_address_wire),//16 bits
		       .din(cpu_address_in_wire), //8-bits
		       .dout(cpu_address_out_wire), //8-bits
		       .dout_oe(),
		       .we_pin(cpu_w_wire),
		       .rd_pin(cpu_r_wire),
		       .sync()
		       );

   name_table inst_name (
			 .clock(clk_wire),
			 .data(oamdata_out_wire),
			 .rdaddress(),
			 .rden(),
			 .wraddress(oamaddr_out_wire),
			 .wren(oamdata_write_complete_wire),
			 .q()
			 );
   
   
endmodule // nes
