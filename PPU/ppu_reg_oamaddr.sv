/*
 OAMADDR Register - Write Only
 Address : 0x2003
 
 
 OAM Address is set to 0 during each tick between 257-320 of the pre-render and visible scanlines.
 The value of OAMADDR at tick 65 determines where in OAM sprite eval begins and so which is sprite 0.
*/

module ppu_reg_oamaddr(
		       input logic 	  clk,	  
		       input logic 	  oamaddr_write_en,
		       input logic        oamdata_write_complete,
		       input logic [7:0]  oamaddr_in,
		       output logic [7:0] oamaddr_out
		       );
   logic [7:0] 				 oamaddr_reg;

   //Sequential Write of the OAMAddr
   always_ff@(posedge clk)
     begin
	if (oamaddr_write_en==1)
	  oamaddr_reg<=oamaddr_in;
	else if (oamdata_write_en)
	  oamaddr_reg<=oamaddr_reg+1;
	
     end

   //This exposes the Mask Register to the PPU
   assign oamaddr_out=oamaddr_reg;
   
   
endmodule // ppu_reg_oamaddr


   
