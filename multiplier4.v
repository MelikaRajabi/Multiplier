//MELIKA RAJABI 99101608 LAB_3
//-----------------------------Initializing the time unit
`timescale 1ns/1ns
//------------------------------------------------------

module multiplier4 #(parameter nb)( //Declaring a parameter 
//----------------------Port directions and deceleration
   input clk,  
   input start,
   input [nb - 1:0] A, 
   input [nb - 1:0] B, 
   output reg signed [2 * nb - 1:0] Product
   );
//------------------------------------------------------

//---------------------------------Register deceleration
   reg [nb:0] Multiplicand ;
   reg [nb:0] adder_output;
//------------------------------------------------------

//-------------------------------------Wire deceleration
   wire product_write_enable;
//------------------------------------------------------

//-----------------------------------Integer declaration
   integer counter;
//------------------------------------------------------

//-----------------------------------Combinational logic
   assign product_write_enable = Product[0];
//------------------------------------------------------

//--------------------------------------Sequential Logic
   always @ (posedge clk) 

      if(start) begin

         counter <= 0;
         Product[nb - 1:0] <= B;
         Product[2 * nb - 1:nb] <= (nb)'('b0);
         Multiplicand <= {A[nb - 1], A};
         adder_output <= (nb + 1)'('b0);
      
      end

      else if(counter != nb) begin

         counter = counter + 1;

         if(counter == nb) 
            Multiplicand = -Multiplicand;
         
         adder_output = {Product[2 * nb - 1], Product[2 * nb - 1:nb]} + Multiplicand;

         Product = Product >>> 1;

         if(product_write_enable)
            Product[2 * nb - 1:nb - 1] = adder_output;

      end 

endmodule
