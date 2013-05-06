module ppu (
	    input logic 	clk,
	    input logic 	n_reset,
	    input logic 	r_nw,
	    input logic 	n_cs,
	    input logic 	n_sync,
	    input logic [2:0] 	cpu_a_in,
	    input logic [7:0] 	cpu_data_in,
	    input logic [7:0] 	vram_data_in,
	    output logic 	ale,
	    output logic [13:8] ppu_address_out,
	    output logic [7:0] 	cpu_data_out,
	    output logic [7:0] 	vram_data_address_out,
	    output logic 	n_r,
	    output logic 	n_w,
	    output logic 	n_vbl,
	    );


   logic 			ppuctrl_enable_wire;
   logic 			ppumask_enable_wire;
   logic 			ppustatus_enable_wire;
   logic 			oamaddr_enable_wire;
   logic 			oamdata_enable_wire;
   logic 			scroll_enable_wire;
   logic 			address_enable_wire;
   logic 			data_enable_wire;

   logic 			write_toggle;
   
   logic 			data_write_complete_wire;
   logic 			oamdata_write_complete_wire;
   
   logic [7:0] 			ppuctrl_out_wire;
   logic [7:0] 			ppumask_out_wire;
   logic [7:0] 			oamaddr_out_wire;
   logic [7:0] 			oamdata_out_wire;
   logic [15:0] 		scroll_out_wire;
   logic [15:0] 		address_out_wire;
   logic [7:0] 			data_out_wire;
   
   
   always_comb
     begin:address_resolution
	
	ppuctrl_enable_wire=0;
	ppumask_enable_wire=0;
	ppustatus_enable_wire=0;
	oamaddr_enable_wire=0;
	oamdata_enable_wire=0;
	scroll_enable_wire=0;
	address_enable_wire=0;
	data_enable_wire=0;
	
	unique case (cpu_a_in)
	  0:
	    ppuctrl_enable_wire = 1;
	  1:
	    ppumask_enable_wire = 1;
	  2:
	    ppustatus_enable_wire=1;
	  3:
	    oamaddr_enable_wire=1;
	  4:
	    oamdata_enable_wire=1;
	  5:
	    scroll_enable_wire=1;
	  6:
	    address_enable_wire=1;
	  7:
	    data_enable_wire=1;
	endcase // unique case (cpu_a_in)
	
     end
   
   assign write_toggle = (address_enable_wire | scroll_enable_wire)? 
			 !write_toggle:write_toggle;
   
   
   ppu_reg_ppuctrl ins_ppuctrl(
			       .clk(clk_wire),
			       .ppuctrl_write_en(ppuctrl_enable_wire),
			       .ppuctrl_in(cpu_data_in),
			       .ppuctrl_out(ppuctrl_out_wire)
			       );
   
   ppu_reg_ppumask ins_ppumask (
				.clk(clk_wire),
				.ppumask_write_en(ppumask_enable_wire),
				.ppumask_in(cpu_data_in),
				.ppumask_out(ppumask_out_wire)
				
   ppu_reg_oamaddr inst_oamaddr(
				.clk(clk_wire),
				.oamaddr_write_en(oamaddr_enable_wire),
				.oamdata_write_complete(oamdata_write_complete_wire),
				.oamaddr_in(cpu_data_in),
				.oam_addr_out(oam_addr_out_wire)
				);
				
   ppu_reg_oamdata inst_oamdata(
				.clk(clk_wire),
				.oamdata_write_en(oamdata_enable_wire),
				.oamdata_in(cpu_data_in),
				.oamdata_write_complete(oamdata_write_complete_wire),
				.oamdata_out(oamdata_out_wire)
				);
   
   ppu_reg_scroll inst_scroll(
			      .clk(clk_wire),
			      .scroll_write_en(scroll_enable_wire),
			      .write_toggle(write_toggle_wire),
			      .scroll_in(cpu_data_in),
			      .scroll_out(scroll_out_wire)
			      );
			       
   ppu_reg_address inst_address(
				.clk(clk_wire),
				.address_write_en(address_enable_wire),
				.write_toggle(write_toggle_wire),
				.reg_data_write_completed(data_write_complete_wire),
				.ppuctrl_2(ppuctrl_out_wire[2]), 
				.address_in(cpu_data_in),
				.address_out(address_out_wire)
				);
   
   ppu_reg_data inst_data(
			  .clk(clk_wire),
			  .data_write_en(data_enable_wire),
			  .data_in(cpu_data_in),
			  .data_write_complete(data_write_complete_wire),
			  .data_out(data_out_wire)
			  );
   
   oam inst_oam (
		 .clock(clk_wire),
		 .data(oamdata_out_wire),
		 .rdaddress(),
		 .rden(),
		 .wraddress(oamaddr_out_wire),
		 .wren(oamdata_write_complete_wire),
		 .q()
		 );
endmodule // ppu
