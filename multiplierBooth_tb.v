//MELIKA RAJABI 99101608 LAB_Booth
//-----------------------------Initializing the time unit
`timescale 1ns/1ns
//------------------------------------------------------

module multiplierBooth_tb ();

   parameter nb = 12; //Declaring a parameter 
   parameter no_of_tests = 1000;

//------------------Generating clock signal in 100MHz
   reg clk = 1'b1;
   always @(clk)
      clk <= #5 ~clk;
//---------------------------------------------------
 
//-------------------------------------Reg declaration 
   reg start;
   reg signed [nb - 1:0] A, B, C, D;
   reg [2 * nb - 1:0] expected_product;
//---------------------------------------------------- 

//---------------------------------------------------- 
   integer i, j;
   
   initial begin

      start = 0;

      @(posedge clk);
      @(posedge clk);
      @(posedge clk);
      #1;

//----------------------------------------------------Repeat the test no_of_tests times with different random numbers
      for(i = 0; i < no_of_tests; i = i + 1) begin

         A = $random();    
         B = $random();
         expected_product = A * B;
         C = A;
         D = B;

      //----------------------------------------------Generating start signal 
         start = 1;

         @(posedge clk);
         #1;

         start = 0;

         A = 'bx; //When start became "1" we register A & B and their changes is not important after start became "0"
         B = 'bx; //When start became "1" we register A & B and their changes is not important after start became "0"
            
      //----------------------------------------------Wait until multiplication become complete
         for(j = 0; j <= nb; j = j + 1)        
            @(posedge clk);
         @(posedge clk);

      //---------------------------------------------- 

         $write(" %x (%0d) x %x (%0d) = %x (%0d) ", {C}, C, {D}, D, uut.Product, $signed(uut.Product));

         if (expected_product === uut.Product)
            $display(", OK");
         else 
            $display (", ERROR: expected %x, got %x", expected_product, $signed(uut.Product)); 

      end

      $stop;

   end
   //-----------------------------------------------

   //Booth algorithm unit
    multiplierBooth #(.nb(nb)) uut (
        .clk(clk),
        .start(start),
        .A(A),
        .B(B),
        .Product()
      );

endmodule

