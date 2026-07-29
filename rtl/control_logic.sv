// control_logic.sv
// Module Name: control_logic
// Who builds this: Member C (Software/Decision Teammate)
// What it does: Decides when to trigger the alarm based on AI results

module control_logic (
    // Clock and reset
    input  logic        clk,
    input  logic        rst_n,
    
    // Input: AI result from the neural_network_accelerator
    input  logic [7:0]  ai_result,     // 0 = alert, 1 = drowsy, 2 = distracted
    input  logic        ai_done,       // "AI finished processing!" signal
    
    // Output: Alarm and status signals
    output logic        alarm_trigger,  // "SOUND THE ALARM!"
    output logic [1:0]  status_leds     // Status lights: 00=idle, 01=alert, 10=drowsy, 11=alarm
);

    // ============================================================
    // MEMBER C: THIS IS YOUR WORKSPACE
    // Replace the code below with your actual decision logic.
    //
    // What you need to build:
    // 1. A counter that tracks how long the driver has been drowsy
    // 2. A threshold: if eyes closed > 2 seconds, trigger alarm
    // 3. Logic for different warning levels (warning beep -> loud alarm)
    //
    // Example logic:
    // - ai_result == 1 (drowsy) for more than 50 clock cycles = ALARM
    // - ai_result == 2 (distracted) = warning LED
    // ============================================================

    // Internal counter (counts how long driver is drowsy)
    int drowsy_counter;

    // TEMPORARY PLACEHOLDER - Member C will replace this
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            alarm_trigger <= 1'b0;
            status_leds <= 2'b00;
            drowsy_counter <= 0;
        end
        else if (ai_done) begin
            if (ai_result == 8'd1) begin
                // Driver is drowsy - start counting
                drowsy_counter <= drowsy_counter + 1;
                status_leds <= 2'b10;  // Yellow LED = warning
                
                // If drowsy for too long, trigger alarm!
                if (drowsy_counter > 50) begin
                    alarm_trigger <= 1'b1;
                    status_leds <= 2'b11;  // Red LED = ALARM
                end
            end else begin
                // Driver is alert - reset everything
                drowsy_counter <= 0;
                alarm_trigger <= 1'b0;
                status_leds <= 2'b01;  // Green LED = all good
            end
        end
    end

endmodule