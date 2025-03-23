package com.emanuel.itschool;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType0Font;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.IOException;

@Service
public class PdfGeneratorService {

    public void createPdf(String filePath) {
        try (PDDocument document = new PDDocument()) {
            // Create a new page
            PDPage page = new PDPage();
            document.addPage(page);

            // Load a custom Helvetica Bold font file
            File fontFile = new File("src/main/resources/fonts/Helvetica-Bold.ttf");
            PDType0Font customFont = PDType0Font.load(document, fontFile);

            // Write content to the page
            try (PDPageContentStream contentStream = new PDPageContentStream(document, page)) {
                contentStream.beginText();
                contentStream.setFont(customFont, 18);
                contentStream.newLineAtOffset(100, 700); // Position text
                contentStream.showText("PdfGenratorTest,This is a test");
                contentStream.endText();
            }

            // Save the PDF
            document.save(filePath);
            System.out.println("PDF successfully created at: " + filePath);
        } catch (IOException e) {
            System.err.println("Error generating PDF: " + e.getMessage());
        }
    }
}
