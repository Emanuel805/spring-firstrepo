package com.emanuel.itschool;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PdfController {

    private final PdfGeneratorService pdfGeneratorService;

    public PdfController(PdfGeneratorService pdfGeneratorService) {
        this.pdfGeneratorService = pdfGeneratorService;
    }

    @GetMapping("/generate-pdf/{filePath}")
    public String generatePdf(@PathVariable String filePath){
        pdfGeneratorService.createPdf(filePath);
        return "PDF generated at: " + filePath;
    }
}