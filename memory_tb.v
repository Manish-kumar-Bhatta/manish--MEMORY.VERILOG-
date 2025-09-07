`include "memory.v"
module tb;
	parameter WIDTH=8;
	parameter DEPTH=16;
	parameter ADDR_WIDTH=$clog2(DEPTH);
	
	reg clk,res,wr_rd,valid;
	reg[WIDTH-1:0]wdata;
	reg[ADDR_WIDTH-1:0]addr;
	wire [WIDTH-1:0]rdata;
    wire ready;
	integer i;
	reg[20*8-1:0]testcase;

	memory dut(clk,res,addr,wr_rd,wdata,rdata,valid,ready);
	
	always #5 clk=~clk;
	initial begin
		clk=0;
		res=1;
		wr_rd=0;
		valid=0;
		wdata=0;
		addr=0;
		repeat(2)@(posedge clk);
		res=0;

		$value$plusargs("testcase=%0s",testcase);

		case(testcase)
			"fw_fr":begin
				write(0,DEPTH);
				read(0,DEPTH);
			end
			"fw_br":begin
				write(0,DEPTH);
				b_read();
			end
			"bw_fr":begin
				b_write();
				read(0,DEPTH);
			end
			"bw_br":begin
				b_write();
				b_read();
			end
		endcase
	end

	//front door write
	//sl=starting location
	//num_loc=number of location
	task write(input reg[ADDR_WIDTH-1:0]sl,input reg[ADDR_WIDTH:0]num_loc);
		begin
			for(i=sl;i<sl+num_loc;i=i+1) begin
				@(posedge clk);
					wr_rd=1;
					addr=i;
					wdata=$random;
					valid=1;
					wait(ready==1);
			end
			@(posedge clk);
				wr_rd=0;
				addr=0;
				wdata=0;
				valid=0;
		end
	endtask

	//front door read
	//sl=starting location
	//num_loc=number of location
	task read(input reg[ADDR_WIDTH-1:0]sl,input reg[ADDR_WIDTH:0]num_loc);
		begin
			for(i=sl;i<sl+num_loc;i=i+1) begin
				@(posedge clk);
					wr_rd=0;
					addr=i;
					valid=1;
					wait(ready==1);
			end
			@(posedge clk);
				wr_rd=0;
				addr=0;
				valid=0;
		end
	endtask

	//back door write
	task b_write();
		begin
			$readmemh("input.hex",dut.mem);
		end
	endtask

	//back door read
	task b_read();
		begin
			$writememh("output.hex",dut.mem);
		end
	endtask

	initial begin
		#500;
		$finish;
	end
endmodule


				
