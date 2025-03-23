package com.emanuel.itschool;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PdfController {

    @Autowired
    private PdfGeneratorService pdfGeneratorService; // Dependency injection using @Autowired

    @GetMapping("/generate-pdf")
    public String generatePdf(@RequestParam String filePath) {
        pdfGeneratorService.createPdf(filePath);
        return "PDF generated at: " + filePath;
    }
}