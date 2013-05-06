/*
SCROLL Register - Write Only
Address : 0x2005
 
 Used to change the scroll position.
 Tells PPU Which pixel of the nametable should be in the topleft.
 
 Write Toggle Shared with PPU ADDRESS Register.
 
 15:8 = Y Cordinate
 7:0  = X Cordinate
*/

module ppu_reg_scroll(
		       input logic 	  clk,
		       input logic 	  scroll_write_en,
		       input logic 	  write_toggle, 
		       input logic [7:0]  scroll_in,
		       output logic [15:0] scroll_out
		       );
   logic [15:0] 			  scroll_reg;
   //Sequential Write of the Scroll
   always_ff@(posedge clk)
     begin
	if (scroll_write_en==1)
	  if (write_toggle==0)
	    scroll_reg[15:8]<=scroll_in;
	  else
	    scroll_reg[7:0]<=scroll_in;
     end
   
   //This exposes the Scroll Register to the PPU
   assign scroll_out=scroll_reg;
   
   
endmodule // ppu_reg_scroll


   
