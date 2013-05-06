/*
 PPUMASK Register - Write Only
 Address : 0x2001
 Controls screen enable, masking and intensity
 
 7 - Intensifies Blues (darkens other colors) 
 6 - Intensifies Greens (Darkens other colors)
 5 - Intensifies Reds (Darkens other colors)
 4 - Show Sprites
 3 - Show Background
 2 - Show sprites in leftmost 8 pixels (0 to hide)
 1 - Show background in leftmost 8 pixels
 0 - Grayscale (0: Normal Color, 1: Monochrome)
 
*/

module ppu_reg_ppumask(
		       input logic clk,
		       input logic ppumask_write_en,
		       input logic[7:0] ppumask_in,
		       output logic[7:0] ppumask_out
		       );
   logic [7:0] 				 ppumask_reg;

   //Sequential Write of the PPUMask
   always_ff@(posedge clk)
     begin
	if (ppumask_write_en==1)
	  ppumask_reg<=ppumask_in;
     end

   //This exposes the Mask Register to the PPU
   assign ppumask_out=ppumask_reg;
   
   
endmodule // ppu_reg_ppumask


   
