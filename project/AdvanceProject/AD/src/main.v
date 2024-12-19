
module Twelve_bit_register_in( 
    input [11:0] D_in,  // 12-bit data input
    input CLK,           // Clock input
    output reg [11:0] Q_in // 12-bit data output
);

    // Using an always block triggered on the rising edge of the clock
    always @(posedge CLK) begin
        Q_in <= D_in; // Transfer input to output on clock edge
    end

endmodule 

module Three_bit_register_out( 
    input [2:0] D_in,  // 3 bit data input
    input CLK,           // Clock input
    output reg [2:0] Q_out // 3 bit data output
);

    // Using an always block triggered on the rising edge of the clock
    always @(negedge CLK) begin
        Q_out <= D_in; // Transfer input to output on clock edge
    end

endmodule

module Signed_Unsigned_Comparator (A,B,S,CLK,Equal,Greater,Smaller);
    input [5:0] A ,B;       // First 6-bit input
    reg [11:0] Q_in;
	input S ,CLK;           // Selection: 0 = Unsigned, 1 = Signed
    output reg Equal;       // A == B
    output reg Greater;   // A > B
    output reg Smaller;   // A < B   
	wire Gr, Le, Eq;
	wire UnGr, UnLe, UnEq;
	
  	Twelve_bit_register_in IN( {A,B} , CLK , Q_in );
	Unsigned_comparator sign_cmp({0,Q_in[10:6]},{0,Q_in[4:0]},CLK,Gr, Le, Eq);	 
	Unsigned_comparator Unsign_cmp(Q_in[11:6],Q_in[5:0],CLK,UnGr, UnLe, UnEq);
      
always @(*)begin
	 Equal = 0;
     Greater = 0;
     Smaller = 0;
	 
	  if (S) begin
	    if (A[5] == 1'b1 && B[5] == 1'b0) begin
	         Greater = 0;
	         Smaller = 1'b1; 
	         Equal = 0;
	   end
	   else if (B[5] > A[5]) begin
	        Greater = 0;
	        Smaller = 1; 
	        Equal = 0;
	    end
	   else begin     
	     Greater = Gr;
		 Smaller = Le;
		 Equal = Eq;
	 	end
	    
	end
	
	   else begin
	     Greater = UnGr;
		 Smaller = UnLe;
		 Equal = UnEq;
	   end
end
  
endmodule


module Unsigned_comparator (A,B,CLK,A_greater,B_greater,Equal);
  
  input [5:0] A,B; 
  input CLK;
  reg [2:0] Q_out;
  reg [2:0] D_out;
  output A_greater,B_greater,Equal;
  
  wire[5:0] Transfer_Level_A1,Transfer_Level_B1,Transfer_Level2,Transfer_Level_G3,Transfer_Level_L3,Transfer_INV_A,Transfer_INV_B;
  
 // bit[5]_level1 
  not #2 INV_bit_A5(Transfer_INV_A[5],A[5]); 
  not #2 INV_bit_B5(Transfer_INV_B[5],B[5]); 
  
  and #8 bit5_A(Transfer_Level_A1[5], Transfer_INV_A[5], B[5]);
  and #8 bit5_b(Transfer_Level_B1[5], A[5], Transfer_INV_B[5]);
  
  // bit[5]_level2
  nor #7 bit5_level2(Transfer_Level2[5], Transfer_Level_A1[5], Transfer_Level_B1[5]);
  
  // bit[4]_level1
  not #2 INV_bit_A4(Transfer_INV_A[4],A[4]); 
  not #2 INV_bit_B4(Transfer_INV_B[4],B[4]); 
  
  and #8 bit4_A(Transfer_Level_A1[4], Transfer_INV_A[4], B[4]);
  and #8 bit4_b(Transfer_Level_B1[4], A[4], Transfer_INV_B[4]);
  
  // bit[4]_level2
  nor #7 bit4_level2(Transfer_Level2[4], Transfer_Level_A1[4], Transfer_Level_B1[4]);
  
  // bit[3]_level1 
  not #2 INV_bit_A3(Transfer_INV_A[3],A[3]); 
  not #2 INV_bit_B3(Transfer_INV_B[3],B[3]);
  
  and #8 bit3_A(Transfer_Level_A1[3], Transfer_INV_A[3], B[3]);
  and #8 bit3_b(Transfer_Level_B1[3], A[3], Transfer_INV_B[3]);
  
  // bit[3]_level2
  nor #7 bit3_level2(Transfer_Level2[3], Transfer_Level_A1[3], Transfer_Level_B1[3]);
  
  // bit[2]_level1
  not #2 INV_bit_A2(Transfer_INV_A[2],A[2]); 
  not #2 INV_bit_B2(Transfer_INV_B[2],B[2]);
  
  and #8 bit2_A(Transfer_Level_A1[2], Transfer_INV_A[2], B[2]);
  and #8 bit2_b(Transfer_Level_B1[2], A[2], Transfer_INV_B[2]);
  
  // bit[2]_level2
  nor #7 bit2_level2(Transfer_Level2[2], Transfer_Level_A1[2], Transfer_Level_B1[2]);
  
  // bit[1]_level1
  not #2 INV_bit_A1(Transfer_INV_A[1],A[1]); 
  not #2 INV_bit_B1(Transfer_INV_B[1],B[1]);
  
  and #8 bit1_A(Transfer_Level_A1[1], Transfer_INV_A[1], B[1]);
  and #8 bit1_b(Transfer_Level_B1[1], A[1], Transfer_INV_B[1]);
  
  // bit[1]_level2
  nor #7 bit1_level2(Transfer_Level2[1], Transfer_Level_A1[1], Transfer_Level_B1[1]);
  
  // bit[0]_level1
  not #2 INV_bit_A0(Transfer_INV_A[0],A[0]); 
  not #2 INV_bit_B0(Transfer_INV_B[0],B[0]);
  
  and #8 bit0_A(Transfer_Level_A1[0], Transfer_INV_A[0], B[0]);
  and #8 bit0_b(Transfer_Level_B1[0], A[0], Transfer_INV_B[0]);
  
  // bit[0]_level2
  nor #7 bit0_level2(Transfer_Level2[0], Transfer_Level_A1[0], Transfer_Level_B1[0]);
  
  // level 3 L (A < B)
  and #8 level3_L5(Transfer_Level_L3[5], Transfer_Level2[5], Transfer_Level_A1[4]);
  and #8 level3_L4(Transfer_Level_L3[4], Transfer_Level2[5], Transfer_Level2[4], Transfer_Level_A1[3]);
  and #8 level3_L3(Transfer_Level_L3[3], Transfer_Level2[5], Transfer_Level2[4], Transfer_Level2[3], Transfer_Level_A1[2]);
  and #8 level3_L2(Transfer_Level_L3[2], Transfer_Level2[5], Transfer_Level2[4], Transfer_Level2[3], Transfer_Level2[2], Transfer_Level_A1[1]);
  and #8 level3_L1(Transfer_Level_L3[1], Transfer_Level2[5], Transfer_Level2[4], Transfer_Level2[3], Transfer_Level2[2], Transfer_Level2[1], Transfer_Level_A1[0]);
  
  // level 4 L (A < B)
  or #8 A_Less_B(D_out[0], Transfer_Level_A1[5], Transfer_Level_L3[5], Transfer_Level_L3[4], Transfer_Level_L3[3], Transfer_Level_L3[2], Transfer_Level_L3[1]);
  
  // level 3 G (A > B)
  and #8 level3_G5(Transfer_Level_G3[5], Transfer_Level2[5], Transfer_Level_B1[4]);
  and #8 level3_G4(Transfer_Level_G3[4], Transfer_Level2[5], Transfer_Level2[4], Transfer_Level_B1[3]);
  and #8 level3_G3(Transfer_Level_G3[3], Transfer_Level2[5], Transfer_Level2[4], Transfer_Level2[3], Transfer_Level_B1[2]);
  and #8 level3_G2(Transfer_Level_G3[2], Transfer_Level2[5], Transfer_Level2[4], Transfer_Level2[3], Transfer_Level2[2], Transfer_Level_B1[1]);
  and #8 level3_G1(Transfer_Level_G3[1], Transfer_Level2[5], Transfer_Level2[4], Transfer_Level2[3], Transfer_Level2[2], Transfer_Level2[1], Transfer_Level_B1[0]);
  
  // level 4 G (A > B)
  or #8 A_Greater_B(D_out[1], Transfer_Level_B1[5], Transfer_Level_G3[5], Transfer_Level_G3[4], Transfer_Level_G3[3], Transfer_Level_G3[2], Transfer_Level_G3[1]);

  // level 4 E (A == B)
  and #8 equal(D_out[2], Transfer_Level2[5], Transfer_Level2[4], Transfer_Level2[3], Transfer_Level2[2], Transfer_Level2[1], Transfer_Level2[0]);
  
  Three_bit_register_out out( {D_out[2],D_out[1],D_out[0]} , CLK , Q_out );   
  
   assign Equal =	Q_out[2];
   assign A_greater = Q_out[1];
   assign B_greater = Q_out[0];
   
endmodule


module Signed_Unsigned_Comparator_tb;

    // Inputs
    reg [5:0] A;
    reg [5:0] B;
    reg S;
    reg CLK; 
	reg Pass;
    
    // Outputs
    wire Equal;
    wire Greater;
    wire Smaller;

    // Instantiate the Unit Under Test (UUT)
    Signed_Unsigned_Comparator uut (A, B, S, CLK, Equal, Greater, Smaller);
	
	always #40 CLK = ~CLK; // Toggle clock every 40 time units
		
    // Test Procedure
    initial begin
        CLK = 1 ;
        S = 0;
        A = 6'b000000;
        B = 6'b000000;
     	Pass=1;
		$display("Testing unsigned comparison (S = 0):");
        #80 $display("Time = %0t   A = %b, B = %b , Equal = %b, Greater = %b, Smaller = %b", $time, A, B, Equal, Greater, Smaller);
		
		#80 $display("Behavioral Test");
				if (A > B && Greater == 1)
    			#80 $display("A is greater than B\n\n");
				
				else if (A < B && Smaller == 1)
    			#80 $display("A is less than B\n\n");
				
				else if (A == B && Equal == 1)
    			#80 $display("A is equal to B\n\n");
				else begin
					Pass=0;
					#80 $display("\n\nThe Test Faill\n\n");
					$stop;
				end
		
        // Loop through all 6-bit binary values for A and B (0 to 63)
        for (A = 6'b000000; A < 6'b111111; A = A + 1) begin  // 6'b111111 is 63 in decimal
            for (B = 6'b000001; B < 6'b111111; B = B + 1) begin
                #80 $display("Time = %0t   A = %b , B = %b , Equal = %b, Greater = %b, Smaller = %b", $time, A, B, Equal, Greater, Smaller); 
				
				#80 $display("Behavioral Test");
			if (A > B && Greater == 1)
    			#80 $display("A is greater than B\n\n");
				
				else if (A < B && Smaller == 1)
    			#80 $display("A is less than B\n\n");
				
				else if (A == B && Equal == 1)
    			#80 $display("A is equal to B\n\n");
				else begin
					Pass=0;
					#80 $display("\n\nThe Test Faill\n\n");
					$stop;
				end	
			end	
        end
           
         //Test signed comparison (S = 1)
        $display("\n\nTesting signed comparison (S = 1):");
        S = 1;  // Set signed comparison
        
         //Loop through signed 6-bit values for A and B (-32 to 31)
        for (A = 6'b100000; A >= 6'b011111; A = A + 1) begin  // -32 to 31
            for (B = 6'b100000; B >= 6'b011111; B = B + 1) begin  // -32 to 31
                // Wait clock cycles before printing the result
                #80 $display("Time = %0t   A = %b , B = %b , Equal = %b, Greater = %b, Smaller = %b", $time, A, B, Equal, Greater, Smaller);  
				
				#80 $display("Behavioral Test");
				if (A > B && Greater == 1)
    			#80 $display("A is greater than B\n\n");
				
				else if (A < B && Smaller == 1)
    			#80 $display("A is less than B\n\n");
				
				else if (A == B && Equal == 1)
    			#80 $display("A is equal to B\n\n");
				else begin
					Pass=0;
					#80 $display("\n\nThe Test Faill\n\n");
					$stop;
				end
            end
        end	
		if(Pass)
		 $display("\n\nThe Test Pass\n\n");
        $finish;
    end

   

endmodule  








