`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2024 02:37:09
// Design Name: 
// Module Name: convolution_brightness
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module convolution_brightness(
        input clk_40,en_blurr,
        input [10:0] h_loc,
        input [9:0] v_loc,
        input [17:0] wr_add,
        output [3:0] dinr_out,dinb_out,ding_out,
        output [17:0] rd_address
    );
    
    reg [17:0] change_addr;
    reg [17:0] total_counter;
    reg enable;
    wire [3:0] doutr,doutg,doutb;
    reg [3:0] dinr_3,ding_3,dinb_3;
    
    
    initial
    begin
        total_counter=0;
        enable=0;
    end 
    always@(posedge clk_40)
    begin
        if(en_blurr && total_counter<=119999 && h_loc>200 && h_loc<601 && v_loc>150 && v_loc<451)
        begin
            total_counter<=total_counter+1;
            enable<=1;
            /*dinr<=doutr+4'b0001;
            if(doutr==4'b1111)
                dinr<=4'b1111;
            ding<=doutg+4'b0001;
            if(doutg==4'b1111)
                ding<=4'b1111;
            dinb<=doutb+4'b0001;
            if(doutb==4'b1111)
                dinb<=4'b1111;*/
             dinr_3<=~doutr;
             ding_3<=~doutg;
             dinb_3<=~doutb;
        end
        else
        begin
            enable<=0;
        end
    end
    always@(*)
    begin
        change_addr=wr_add-1;
        if(wr_add==0)
            change_addr=0;
        
    end
    
    assign dinr_out = dinr_3;
    assign ding_out = ding_3;
    assign dinb_out = dinb_3;
    assign rd_address = change_addr;
    
endmodule
