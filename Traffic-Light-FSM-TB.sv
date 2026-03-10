//Bu test benchi yapay zekadan hazir aldim

`timescale 1ns/1ps

module traffic_fsm_tb();
    // 1. Sinyal Tan?mlamalar? (Giri?ler logic, ç?k??lar tel/logic olabilir)
    logic clk;
    logic rst;
    logic TAORB;
    logic [5:0] led;

    // 2. Tasar?m? (DUT - Device Under Test) Ba?lama
    traffic_fsm dut (
        .clk(clk),
        .rst(rst),
        .TAORB(TAORB),
        .led(led)
    );

    // 3. Saat Sinyali (Clock) Üretimi
    // Her 5ns'de bir yön de?i?tirir, toplam periyot 10ns olur (100MHz).
    always #5 clk = ~clk;

    // 4. Test Senaryosu
    initial begin
        // Ba?lang?ç de?erleri
        clk = 0;
        rst = 1;
        TAORB = 1;

        // Reset i?lemi (20ns boyunca reset bas?l? tutulur)
        #20 rst = 0;
        
        // --- Senaryo 1: GREENRED'de bekleme ---
        #50; // Biraz zaman geçsin, TAORB=1 oldu?u için GREENRED'de kalmal?.

        // --- Senaryo 2: YELLOWRED'e geçi? ve 5 Birim Bekleme ---
        TAORB = 0; // Bu sinyal GREENRED -> YELLOWRED geçi?ini tetikler
        // Burada sistem YELLOWRED'e geçecek ve timer saymaya ba?layacak.
        
        #150; // Timer'?n 5'e kadar saymas? ve REDGREEN'e geçmesi için yeterli süre.

        // --- Senaryo 3: REDGREEN'den REDYELLOW'a geçi? ---
        TAORB = 1; // Bu sinyal REDGREEN -> REDYELLOW geçi?ini tetikler
        
        #150; // REDYELLOW'da 5 birim bekleyip GREENRED'e dönmesini bekliyoruz.

        // Testi Bitir
        $display("Simulasyon tamamlandi.");
        $stop; 
    end
endmodule
