package com.emanuel.itschool;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType0Font;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.apache.pdfbox.pdmodel.font.Standard14Fonts;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.IOException;

@Service
public class PdfGeneratorServiceImpl implements PdfGeneratorService {

    @Override
    public void createPdf(String filePath) {
        try (PDDocument document = new PDDocument()) {
            PDPage page = new PDPage();
            document.addPage(page);

            try (PDPageContentStream contentStream = new PDPageContentStream(document, page)) {
                contentStream.beginText();
                contentStream.setFont(new PDType1Font(Standard14Fonts.FontName.HELVETICA), 18);
                contentStream.newLineAtOffset(100, 700);
                contentStream.showText("The initial name of java was “Oak”. It was changed to Java by Sun’s marketing" +
                        " department changed it to “java” when they found that name " +
                        "was already registered for some computer company.");
                contentStream.endText();
            }

            document.save(filePath);
            System.out.println("PDF successfully created at: " + filePath);
        } catch (IOException e) {
            System.err.println("Error generating PDF: " + e.getMessage());
        }
    }
}