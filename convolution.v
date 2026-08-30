`timescale 1ns / 1ps

module convolution(
input clk,reset,
input [1:0] mode,
output v_sync,h_sync,
output [11:0] pixel,
output en_mode_led
    );
    wire [10:0] v_loc,h_loc;
   reg [17:0] wr_add; 
   reg [17:0] change_addr;
   wire clk_40;
   reg [8:0] pointer;
   wire [3:0] doutr,doutg,doutb;
   reg [3:0] dinr,ding,dinb;
   wire [3:0] dinr_convo,ding_convo,dinb_convo;
   wire [3:0] dinr_bright,ding_bright,dinb_bright;
   wire [17:0] rd_add;
   reg en_blurr;
   reg en_edge;
   reg en_identity,en_brightness;
   
   convolution_module m1(.clk_40(clk_40),.doutr_out(doutr),.doutg_out(doutg),.doutb_out(doutb),.dinr_out(dinr_convo),.ding_out(ding_convo),.dinb_out(dinb_convo),.wr_add(wr_add),.rd_address(rd_add),.en_blurr(en_blurr),.mode(mode));
   convolution_brightness m4(.en_blurr(en_brightness),.clk_40(clk_40),.h_loc(h_loc),.v_loc(v_loc),.wr_add(wr_add),.dinr_out(dinr_bright),.ding_out(ding_bright),.dinb_out(dinb_bright),.rd_address(rd_add));
   
   always @(*)
   begin
    case(mode)
        2'b11:
        begin
            en_blurr=0;
            en_brightness=1;
            dinr = dinr_bright;
            ding = ding_bright;
            dinb = dinb_bright;
        end
        default:
        begin
            en_blurr=1;
            en_brightness=0;
            dinr = dinr_convo;
            ding = ding_convo;
            dinb = dinb_convo;
        end
    endcase
   end
    
blk_mem_gen_0 R_channel (
  .clka(clk_40),    // input wire clka
  .ena(1'b1),      // input wire ena
  .wea(enable),      // input wire [0 : 0] wea
  .addra(rd_add),  // input wire [16 : 0] addra
  .dina(dinr),    // input wire [3 : 0] dina
  .clkb(clk_40),    // input wire clkb
  .enb(1'b1),      // input wire enb
  .addrb(change_addr),  // input wire [16 : 0] addrb
  .doutb(doutr)  // output wire [3 : 0] doutb
);
   
   
blk_mem_gen_1 G_channel (
  .clka(clk_40),    // input wire clka
  .ena(1'b1),      // input wire ena
  .wea(enable),      // input wire [0 : 0] wea
  .addra(rd_add),  // input wire [16 : 0] addra
  .dina(ding),    // input wire [3 : 0] dina
  .clkb(clk_40),    // input wire clkb
  .enb(1'b1),      // input wire enb
  .addrb(change_addr),  // input wire [16 : 0] addrb
  .doutb(doutg)  // output wire [3 : 0] doutb
);

blk_mem_gen_2 B_channel (
  .clka(clk_40),    // input wire clka
  .ena(1'b1),      // input wire ena
  .wea(enable),      // input wire [0 : 0] wea
  .addra(rd_add),  // input wire [16 : 0] addra
  .dina(dinb),    // input wire [3 : 0] dina
  .clkb(clk_40),    // input wire clkb
  .enb(1'b1),      // input wire enb
  .addrb(change_addr),  // input wire [16 : 0] addrb
  .doutb(doutb)  // output wire [3 : 0] doutb
);
  /* blk_mem_gen_0 R_channel (
  .clka(clk_var),    // input wire clka
  .ena(1'b1),      // input wire ena
  .wea(1'b0),      // input wire [0 : 0] wea
  .addra(wr_add),  // input wire [16 : 0] addra
  .dina(dinr),    // input wire [3 : 0] dina
  .douta(doutr)  // output wire [3 : 0] douta
);


   blk_mem_gen_1 G_channel (
  .clka(clk_var),    // input wire clka
  .ena(1'b1),      // input wire ena
  .wea(1'b0),      // input wire [0 : 0] wea
  .addra(wr_add),  // input wire [16 : 0] addra
  .dina(),    // input wire [3 : 0] dina
  .douta(doutg)  // output wire [3 : 0] douta
);

blk_mem_gen_3 B_channel (
  .clka(clk_var),    // input wire clka
  .ena(1'b1),      // input wire ena
  .wea(1'b0),      // input wire [0 : 0] wea
  .addra(wr_add),  // input wire [16 : 0] addra
  .dina(),    // input wire [3 : 0] dina
  .douta(doutb)  // output wire [3 : 0] douta
);
*/
  clk_wiz_0 instance_name
   (
    // Clock out ports
    .clk_out1(clk_40),     // output clk_out1
    // Status and control signals
    .reset(reset), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(clk)      // input clk_in1
);

//////////MATTTTT CHHHHUNNNNNAAAAAAA////////////
wire v_disp,h_disp;
disp_sync D0(.clk(clk_40),.rst(reset),.v_sync(v_sync),.h_sync(h_sync),.v_disp(v_disp),.h_disp(h_disp),.h_loc(h_loc),.v_loc(v_loc));

reg [11:0] pixel_reg;
always@(*)
begin
if(v_disp && h_disp)
begin
    
    
    if(h_loc>200 && h_loc<601 && v_loc>150 && v_loc<451)
    begin
      //  read_en=1'b1;
        pixel_reg={doutr,doutg,doutb};

    end
    else
        pixel_reg={4'b0000,4'b0000,4'b0000};
        
end

end

always@(posedge clk_40)
begin
        
        
        
            if(h_loc>200 && h_loc<601 && v_loc>150 && v_loc<451)
            begin
                wr_add<=wr_add+1;
            if(wr_add==119999)
                wr_add<=0;
            end
            if(h_loc>600 && v_loc>450)
                wr_add<=0;
        
     
       

end

assign pixel=pixel_reg;
endmodule