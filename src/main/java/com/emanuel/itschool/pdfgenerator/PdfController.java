package com.emanuel.itschool.pdfgenerator;

import org.springframework.context.annotation.Profile;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Profile("pdfgenerator")
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