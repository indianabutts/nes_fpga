/*
 PPUCTRL Register - Write Only
 Address : 0x2000
 Various Flags control the PPU Operation
 
 7 - Generates an NMI at the start of VBlank (0: off, 1: on)  
 6 - PPU Master/Slave Select
 5 - Sprite Size (0: 8x8, 1:8x16)
 4 - Background Pattern Table Address (0:0x0000, 1:0x1000)
 3 - Sprite Patter Table Address (0:0x0000, 1:0x1000) ignored in 8x16 mode
 2 - VRAM Address Increment per CPU Read/Write of PPUDATA (0:1,1:32)
 1 - | Base Nametable address 
 0 - | 0:0x2000, 1:0x2400, 2:0x2800, 3:0x2C000
 
 */


//Add 3000 cycle delay before accepting writes, check
//if operations works without it
module ppu_reg_ppuctrl(
		       input logic clk,
		       input logic ppuctrl_write_en,
		       input logic[7:0] ppuctrl_in,
		       output logic[7:0] ppuctrl_out
		       );
   logic [7:0] 				 ppuctrl_reg;

   //Sequential Write of the PPUCtrl
   always_ff@(posedge clk)
     begin
	if (ppuctrl_write_en==1)
	  ppuctrl_reg<=ppuctrl_in;
     end

   //This exposes the control register bits to the PPU to allow for
   //Controls to occur.
   assign ppuctrl_out=ppuctrl_reg;
   
   
endmodule // ppu_reg_ppuctrl


   
