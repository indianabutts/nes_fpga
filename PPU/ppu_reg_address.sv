/*
 ADDRESS Register - Write Only
 Address : 0x2005
 
 Allows CPU to address VRAM Memory. Then Uses PPU DATA Register to fill the VRAM.
 
 Write Toggle Shared with PPU SCROLL Register.
 
 
 */

module ppu_reg_address(
		       input logic 	   clk,
		       input logic 	   address_write_en,
		       input logic 	   write_toggle,
		       input logic 	   reg_data_write_completed,
		       input logic         ppuctrl_2, 	   
		       input logic [7:0]   address_in,
		       output logic [15:0] address_out
		       );
   logic [15:0] 			   address_reg;
   //Sequential Write of the Address
   always_ff@(posedge clk)
     begin
	if (address_write_en==1)
	  if (write_toggle==0)
	    address_reg[15:8]<=address_in;
	  else
	    address_reg[7:0]<=address_in;
	else if (reg_data_write_comepleted==1)
	  //Bit 2 from control register determines size of increment
	  //Unique case to infer parallel resolution.
	  unique case(ppuctrl_2)
	    0:
	      begin
		 address_reg<=address_reg+1;
	      end
	    1:
	      begin
		 address_reg<=address_reg+32;
	      end
	  endcase // unique case (ppuctrl_2)
     end
   
   //This exposes the Address Register to the PPU
   assign address_out=address_reg;
   
   
endmodule // ppu_reg_address


   
