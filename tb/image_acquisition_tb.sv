// image_acquisition_tb.sv
// This is the TESTBENCH - it tests the image_acquisition module
// It acts like a fake camera, sending pretend data to check if our module works

`timescale 1ns / 1ps

module image_acquisition_tb;

    // === STEP 1: Create fake inputs (like pretending to be a camera) ===
    
    logic        clk;              // Our fake clock
    logic        rst_n;            // Our fake reset button
    
    logic [7:0]  cam_data;         // Fake pixel data we'll send
    logic        cam_vsync;        // Fake "new frame!" signal
    logic        cam_href;         // Fake "valid data!" signal
    logic        cam_pclk;         // Fake pixel clock
    
    // === STEP 2: Create wires to see what the module outputs ===
    
    logic [7:0]  img_data_out;     // What comes out of the module
    logic        img_valid;        // Whether the module says "I have data!"

    // === STEP 3: Create the actual module we're testing ===
    // This is like plugging the real module into our test setup
    
    image_acquisition u_test (
        .clk(clk),
        .rst_n(rst_n),
        .cam_data(cam_data),
        .cam_vsync(cam_vsync),
        .cam_href(cam_href),
        .cam_pclk(cam_pclk),
        .img_data_out(img_data_out),
        .img_valid(img_valid)
    );

    // === STEP 4: Create a clock that ticks every 10 nanoseconds ===
    
    // This line says: flip clk every 5ns (so full cycle = 10ns)
    // Think of it like a heartbeat: tick...tick...tick...
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Flip clock every 5ns
    end

    // === STEP 5: The actual TEST — send fake camera signals ===
    
    initial begin
        // Start with everything off (like turning on a new system)
        rst_n = 0;
        cam_data = 8'h00;
        cam_vsync = 0;
        cam_href = 0;
        cam_pclk = 0;

        // Wait a little bit, then press the "reset" button
        #20;
        rst_n = 1;  // Release reset - system is now alive!
        
        // Wait a bit for system to settle
        #20;
        
        // === TEST: Send a fake camera frame ===
        
        // Tell the module: "A new frame is starting!" (vsync = 1)
        cam_vsync = 1;
        #10;
        cam_vsync = 0;  // Done announcing, now start sending data
        
        // Send 10 fake pixels (one by one)
        // Each pixel is a number from 0 to 255 (8 bits)
        // href = 1 means "this is real pixel data"
        
        repeat(10) begin  // Repeat 10 times (10 fake pixels)
            cam_href = 1;         // "This is valid data!"
            cam_data = cam_data + 8'd10;  // Pixel value increases: 0, 10, 20, 30...
            cam_pclk = 1;
            #5;
            cam_pclk = 0;
            #5;
        end
        
        // Tell the module: "I'm done sending!"
        cam_href = 0;
        
        // Wait and watch the output
        #200;
        
        // Print a message to see what happened
        $display("--- TEST RESULTS ---");
        $display("img_data_out = %d", img_data_out);
        $display("img_valid = %b", img_valid);
        
        // Stop the test
        $finish;
    end

endmodule