`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2024 01:17:09
// Design Name: 
// Module Name: convolution_module
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


module convolution_edge_detection(
        input clk_40,en_blurr,
        input [17:0] wr_add,
        input [3:0] doutr_out,doutb_out,doutg_out,
        output [3:0] dinr_out,dinb_out,ding_out,
        output [17:0] rd_address
    );
    
    
    reg [17:0] rd_add;
    reg [3:0] doutr,doutg,doutb;
   reg [3:0] dinr,ding,dinb;
   reg [1:0] current_write_line;
   reg [8:0] pointer; 
   reg [17:0] change_addr;
   reg [17:0] total_counter;
    reg [3:0] linebuffer1 [0:399];
   reg [3:0] linebuffer2 [0:399];
   reg [3:0] linebuffer3 [0:399];
   reg [3:0] linebuffer4 [0:399];
      reg [3:0] linebuffer1g [0:399];
   reg [3:0] linebuffer2g [0:399];
   reg [3:0] linebuffer3g [0:399];
   reg [3:0] linebuffer4g [0:399];
      reg [3:0] linebuffer1b [0:399];
   reg [3:0] linebuffer2b [0:399];
   reg [3:0] linebuffer3b [0:399];
   reg [3:0] linebuffer4b [0:399];
   reg [8:0] linecounter;
   reg [3:0] linestore1 [0:399];
   reg [3:0] linestore2 [0:399];
   reg [3:0] linestore1g [0:399];
   reg [3:0] linestore2g [0:399];
   reg [3:0] linestore1b [0:399];
   reg [3:0] linestore2b [0:399];
   wire [3:0] out_pixel;
   wire [3:0] out_pixelg;
   wire [3:0] out_pixelb;
   reg [3:0] pix1,pix2,pix3,pix4,pix5,pix6,pix7,pix8,pix9;
   reg [3:0] pix1g,pix2g,pix3g,pix4g,pix5g,pix6g,pix7g,pix8g,pix9g;
   reg [3:0] pix1b,pix2b,pix3b,pix4b,pix5b,pix6b,pix7b,pix8b,pix9b;
   reg enable;
   reg en_mode;
   reg change_state;
   
   
   initial
   begin
        total_counter=0;
        change_state=0;
        change_addr=0;
        en_mode=0;
        enable=0;
        current_write_line=0;
        pointer=0;
        linecounter=0;
        rd_add=0;
   end
   
   
   
   assign en_mode_led=en_mode;
   always@(posedge clk_40)
   begin
        if(en_mode)
        begin
            pointer<=pointer+1;
            total_counter<=total_counter+1;
            if(pointer==399)
            begin
                pointer<=0;
                linecounter<=linecounter+1;
                if(linecounter==301)
                    linecounter<=301;
                current_write_line<=current_write_line+1;
            end
        end

        
   end
   
   always@(posedge clk_40)
   if(en_mode)
   begin
    begin
        case(current_write_line)
        0:
        begin
            linebuffer1[pointer]<=doutr;
            linebuffer1g[pointer]<=doutg;
            linebuffer1b[pointer]<=doutb;
        end           
        1:
        begin
            linebuffer2[pointer]<=doutr;
            linebuffer2g[pointer]<=doutg;
            linebuffer2b[pointer]<=doutb;
        end
        2:
        begin
            linebuffer3[pointer]<=doutr;
            linebuffer3g[pointer]<=doutg;
            linebuffer3b[pointer]<=doutb;
        end        
        3:
        begin
            linebuffer4[pointer]<=doutr;
            linebuffer4g[pointer]<=doutg;
            linebuffer4b[pointer]<=doutb;
        end        
        endcase
   end
   end
   
   
   
   always@(posedge clk_40)
   begin
    if(en_mode)
    begin
        linestore1[pointer]<=out_pixel;
        linestore2[pointer]<=linestore1[pointer];
        dinr<=linestore2[pointer];
        linestore1g[pointer]<=out_pixelg;
        linestore2g[pointer]<=linestore1g[pointer];
        ding<=linestore2g[pointer];
        linestore1b[pointer]<=out_pixelb;
        linestore2b[pointer]<=linestore1b[pointer];
        dinb<=linestore2b[pointer];
        rd_add<=pointer+(linecounter-2)*400;
        if(pointer+(linecounter-2)*400<0)
        begin
            rd_add<=0;
            enable<=1'b0;
            
        end
        if(linecounter>=2 && linecounter<=300)  // this is the crucial condition
            begin
                enable<=1'b1;
            end
            else
            begin
                if(linecounter==301)
                    begin
                        enable<=1'b0;
                    end
            end
    end

      //  convolved_pixel<=out_pixel;
        
   end
   
   
   
   edge_detection a0(
   .p1(pix1),
   .p2(pix2),
   .p3(pix3),
   .p4(pix4),
   .p5(pix5),
   .p6(pix6),
   .p7(pix7),
   .p8(pix8),
   .p9(pix9),
   .o1(out_pixel)
   );
   
    edge_detection a1(
   .p1(pix1g),
   .p2(pix2g),
   .p3(pix3g),
   .p4(pix4g),
   .p5(pix5g),
   .p6(pix6g),
   .p7(pix7g),
   .p8(pix8g),
   .p9(pix9g),
   .o1(out_pixelg)
   );
   
   edge_detection a2(
   .p1(pix1b),
   .p2(pix2b),
   .p3(pix3b),
   .p4(pix4b),
   .p5(pix5b),
   .p6(pix6b),
   .p7(pix7b),
   .p8(pix8b),
   .p9(pix9b),
   .o1(out_pixelb)
   );
  
   always@(*)
   begin
        case(current_write_line)
        0:
        begin
        pix5=linebuffer3[pointer];
        if((pointer-1<0) || (linecounter==0)) 
            pix1=0;
        else
            pix1=linebuffer2[pointer-1];
        if(pointer-1<0)
            pix4=0;
        else
            pix4=linebuffer3[pointer-1];
        if((pointer-1<0) || (linecounter==300)) 
            pix7=0;
        else
            pix7=linebuffer4[pointer-1];
        if(linecounter==0) 
            pix2=0;
        else
            pix2=linebuffer2[pointer];
        if(linecounter==299)
            pix8=0;
        else
            pix8=linebuffer4[pointer];
        if((pointer+1>400) || (linecounter==0)) 
            pix3=0;
        else
            pix3=linebuffer2[pointer+1];
        if(pointer+1>400)
            pix6=0;
        else
            pix6=linebuffer3[pointer+1];
        if((pointer+1>400) || (linecounter==300)) 
            pix9=0;
        else
            pix9=linebuffer4[pointer+1];


            
        end
        1:
        begin
        pix5=linebuffer4[pointer];
        if((pointer-1<0) || (linecounter==0)) 
            pix1=0;
        else
            pix1=linebuffer3[pointer-1];
        if(pointer-1<0)
            pix4=0;
        else
            pix4=linebuffer4[pointer-1];
        if((pointer-1<0) || (linecounter==299)) 
            pix7=0;
        else
            pix7=linebuffer1[pointer-1];
        if(linecounter==0) 
            pix2=0;
        else
            pix2=linebuffer3[pointer];
        if(linecounter==299)
            pix8=0;
        else
            pix8=linebuffer1[pointer];
        if((pointer+1>400) || (linecounter==0)) 
            pix3=0;
        else
            pix3=linebuffer3[pointer+1];
        if(pointer+1>400)
            pix6=0;
        else
            pix6=linebuffer4[pointer+1];
        if((pointer+1>400) || (linecounter==299)) 
            pix9=0;
        else
            pix9=linebuffer1[pointer+1];
        end
        2:
        begin
        pix5=linebuffer1[pointer];
        if((pointer-1<0) || (linecounter==0)) 
            pix1=0;
        else
            pix1=linebuffer4[pointer-1];
        if(pointer-1<0)
            pix4=0;
        else
            pix4=linebuffer1[pointer-1];
        if((pointer-1<0) || (linecounter==299)) 
            pix7=0;
        else
            pix7=linebuffer2[pointer-1];
        if(linecounter==0) 
            pix2=0;
        else
            pix2=linebuffer4[pointer];
        if(linecounter==299)
            pix8=0;
        else
            pix8=linebuffer2[pointer];
        if((pointer+1>400) || (linecounter==0)) 
            pix3=0;
        else
            pix3=linebuffer4[pointer+1];
        if(pointer+1>400)
            pix6=0;
        else
            pix6=linebuffer1[pointer+1];
        if((pointer+1>400) || (linecounter==299)) 
            pix9=0;
        else
            pix9=linebuffer2[pointer+1];
        end
        3:
        begin
        pix5=linebuffer2[pointer];
        if((pointer-1<0) || (linecounter==0)) 
            pix1=0;
        else
            pix1=linebuffer1[pointer-1];
        if(pointer-1<0)
            pix4=0;
        else
            pix4=linebuffer2[pointer-1];
        if((pointer-1<0) || (linecounter==299)) 
            pix7=0;
        else
            pix7=linebuffer3[pointer-1];
        if(linecounter==0) 
            pix2=0;
        else
            pix2=linebuffer1[pointer];
        if(linecounter==299)
            pix8=0;
        else
            pix8=linebuffer3[pointer];
        if((pointer+1>400) || (linecounter==0)) 
            pix3=0;
        else
            pix3=linebuffer1[pointer+1];
        if(pointer+1>400)
            pix6=0;
        else
            pix6=linebuffer2[pointer+1];
        if((pointer+1>400) || (linecounter==299)) 
            pix9=0;
        else
            pix9=linebuffer3[pointer+1];    
        end
        endcase
   end

   always@(*)
   begin
        case(current_write_line)
        0:
        begin
        pix5g=linebuffer3g[pointer];
        if((pointer-1<0) || (linecounter==0)) 
            pix1g=0;
        else
            pix1g=linebuffer2g[pointer-1];
        if(pointer-1<0)
            pix4g=0;
        else
            pix4g=linebuffer3g[pointer-1];
        if((pointer-1<0) || (linecounter==300)) 
            pix7g=0;
        else
            pix7g=linebuffer4g[pointer-1];
        if(linecounter==0) 
            pix2g=0;
        else
            pix2g=linebuffer2g[pointer];
        if(linecounter==299)
            pix8g=0;
        else
            pix8g=linebuffer4g[pointer];
        if((pointer+1>400) || (linecounter==0)) 
            pix3g=0;
        else
            pix3g=linebuffer2g[pointer+1];
        if(pointer+1>400)
            pix6g=0;
        else
            pix6g=linebuffer3g[pointer+1];
        if((pointer+1>400) || (linecounter==300)) 
            pix9g=0;
        else
            pix9g=linebuffer4g[pointer+1];


            
        end
        1:
        begin
        pix5g=linebuffer4g[pointer];
        if((pointer-1<0) || (linecounter==0)) 
            pix1g=0;
        else
            pix1g=linebuffer3g[pointer-1];
        if(pointer-1<0)
            pix4g=0;
        else
            pix4g=linebuffer4g[pointer-1];
        if((pointer-1<0) || (linecounter==299)) 
            pix7g=0;
        else
            pix7g=linebuffer1g[pointer-1];
        if(linecounter==0) 
            pix2g=0;
        else
            pix2g=linebuffer3g[pointer];
        if(linecounter==299)
            pix8g=0;
        else
            pix8g=linebuffer1g[pointer];
        if((pointer+1>400) || (linecounter==0)) 
            pix3g=0;
        else
            pix3g=linebuffer3g[pointer+1];
        if(pointer+1>400)
            pix6g=0;
        else
            pix6g=linebuffer4g[pointer+1];
        if((pointer+1>400) || (linecounter==299)) 
            pix9g=0;
        else
            pix9g=linebuffer1g[pointer+1];
        end
        2:
        begin
        pix5g=linebuffer1g[pointer];
        if((pointer-1<0) || (linecounter==0)) 
            pix1g=0;
        else
            pix1g=linebuffer4g[pointer-1];
        if(pointer-1<0)
            pix4g=0;
        else
            pix4g=linebuffer1g[pointer-1];
        if((pointer-1<0) || (linecounter==299)) 
            pix7g=0;
        else
            pix7g=linebuffer2g[pointer-1];
        if(linecounter==0) 
            pix2g=0;
        else
            pix2g=linebuffer4g[pointer];
        if(linecounter==299)
            pix8g=0;
        else
            pix8g=linebuffer2g[pointer];
        if((pointer+1>400) || (linecounter==0)) 
            pix3g=0;
        else
            pix3g=linebuffer4g[pointer+1];
        if(pointer+1>400)
            pix6g=0;
        else
            pix6g=linebuffer1g[pointer+1];
        if((pointer+1>400) || (linecounter==299)) 
            pix9g=0;
        else
            pix9g=linebuffer2g[pointer+1];
        end
        3:
        begin
        pix5g=linebuffer2g[pointer];
        if((pointer-1<0) || (linecounter==0)) 
            pix1g=0;
        else
            pix1g=linebuffer1g[pointer-1];
        if(pointer-1<0)
            pix4g=0;
        else
            pix4g=linebuffer2g[pointer-1];
        if((pointer-1<0) || (linecounter==299)) 
            pix7g=0;
        else
            pix7g=linebuffer3g[pointer-1];
        if(linecounter==0) 
            pix2g=0;
        else
            pix2g=linebuffer1g[pointer];
        if(linecounter==299)
            pix8g=0;
        else
            pix8g=linebuffer3g[pointer];
        if((pointer+1>400) || (linecounter==0)) 
            pix3g=0;
        else
            pix3g=linebuffer1g[pointer+1];
        if(pointer+1>400)
            pix6g=0;
        else
            pix6g=linebuffer2g[pointer+1];
        if((pointer+1>400) || (linecounter==299)) 
            pix9g=0;
        else
            pix9g=linebuffer3g[pointer+1];    
        end
        endcase
   end
   always@(*)
   begin
        case(current_write_line)
        0:
        begin
        pix5b=linebuffer3b[pointer];
        if((pointer-1<0) || (linecounter==0)) 
            pix1b=0;
        else
            pix1b=linebuffer2b[pointer-1];
        if(pointer-1<0)
            pix4b=0;
        else
            pix4b=linebuffer3b[pointer-1];
        if((pointer-1<0) || (linecounter==300)) 
            pix7b=0;
        else
            pix7b=linebuffer4b[pointer-1];
        if(linecounter==0) 
            pix2b=0;
        else
            pix2b=linebuffer2b[pointer];
        if(linecounter==299)
            pix8b=0;
        else
            pix8b=linebuffer4b[pointer];
        if((pointer+1>400) || (linecounter==0)) 
            pix3b=0;
        else
            pix3b=linebuffer2b[pointer+1];
        if(pointer+1>400)
            pix6b=0;
        else
            pix6b=linebuffer3b[pointer+1];
        if((pointer+1>400) || (linecounter==300)) 
            pix9b=0;
        else
            pix9b=linebuffer4b[pointer+1];


            
        end
        1:
        begin
        pix5b=linebuffer4b[pointer];
        if((pointer-1<0) || (linecounter==0)) 
            pix1b=0;
        else
            pix1b=linebuffer3b[pointer-1];
        if(pointer-1<0)
            pix4b=0;
        else
            pix4b=linebuffer4b[pointer-1];
        if((pointer-1<0) || (linecounter==299)) 
            pix7b=0;
        else
            pix7b=linebuffer1b[pointer-1];
        if(linecounter==0) 
            pix2b=0;
        else
            pix2b=linebuffer3b[pointer];
        if(linecounter==299)
            pix8b=0;
        else
            pix8b=linebuffer1b[pointer];
        if((pointer+1>400) || (linecounter==0)) 
            pix3b=0;
        else
            pix3b=linebuffer3b[pointer+1];
        if(pointer+1>400)
            pix6b=0;
        else
            pix6b=linebuffer4b[pointer+1];
        if((pointer+1>400) || (linecounter==299)) 
            pix9b=0;
        else
            pix9b=linebuffer1b[pointer+1];
        end
        2:
        begin
        pix5b=linebuffer1b[pointer];
        if((pointer-1<0) || (linecounter==0)) 
            pix1b=0;
        else
            pix1b=linebuffer4b[pointer-1];
        if(pointer-1<0)
            pix4b=0;
        else
            pix4b=linebuffer1b[pointer-1];
        if((pointer-1<0) || (linecounter==299)) 
            pix7b=0;
        else
            pix7b=linebuffer2b[pointer-1];
        if(linecounter==0) 
            pix2b=0;
        else
            pix2b=linebuffer4b[pointer];
        if(linecounter==299)
            pix8b=0;
        else
            pix8b=linebuffer2b[pointer];
        if((pointer+1>400) || (linecounter==0)) 
            pix3b=0;
        else
            pix3b=linebuffer4b[pointer+1];
        if(pointer+1>400)
            pix6b=0;
        else
            pix6b=linebuffer1b[pointer+1];
        if((pointer+1>400) || (linecounter==299)) 
            pix9b=0;
        else
            pix9b=linebuffer2b[pointer+1];
        end
        3:
        begin
        pix5b=linebuffer2b[pointer];
        if((pointer-1<0) || (linecounter==0)) 
            pix1b=0;
        else
            pix1b=linebuffer1b[pointer-1];
        if(pointer-1<0)
            pix4b=0;
        else
            pix4b=linebuffer2b[pointer-1];
        if((pointer-1<0) || (linecounter==299)) 
            pix7b=0;
        else
            pix7b=linebuffer3b[pointer-1];
        if(linecounter==0) 
            pix2b=0;
        else
            pix2b=linebuffer1b[pointer];
        if(linecounter==299)
            pix8b=0;
        else
            pix8b=linebuffer3b[pointer];
        if((pointer+1>400) || (linecounter==0)) 
            pix3b=0;
        else
            pix3b=linebuffer1b[pointer+1];
        if(pointer+1>400)
            pix6b=0;
        else
            pix6b=linebuffer2b[pointer+1];
        if((pointer+1>400) || (linecounter==299)) 
            pix9b=0;
        else
            pix9b=linebuffer3b[pointer+1];    
        end
        endcase
   end
   /*always@(change_state,linecounter)
   begin
       en_mode=1'b1;
       if(linecounter==301)
            en_mode=1'b0;
   end*/
   always@(*)
   begin
   if(en_blurr && total_counter!=120799)
      //change_state=~change_state; 
      begin 
      en_mode=1'b1;
      //stotal_counter=0;
      end
   else
   begin
      en_mode=1'b0;
   end
   end
    
    always@(*)
    begin   
        if(!en_mode)
        change_addr=wr_add;
        else
        begin
            change_addr=pointer+linecounter*400;        
        end
        
    end
    
    assign doutr_out = doutr;
    assign doutg_out = doutg;
    assign doutb_out = doutb;
    assign dinr_out = dinr;
    assign ding_out = ding;
    assign dinb_out = dinb;
    assign rd_add_out = rd_add;
    assign wr_add_out = wr_add;
    
endmodule
