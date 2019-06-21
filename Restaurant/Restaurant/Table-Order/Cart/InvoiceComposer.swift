//
//  InvoiceComposer.swift
//  Print2PDF
//
//  Created by Gabriel Theodoropoulos on 23/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit

class InvoiceComposer: NSObject {

    let pathToInvoiceHTMLTemplate = Bundle.main.path(forResource: "invoice", ofType: "html")
    
    let pathToSingleItemHTMLTemplate = Bundle.main.path(forResource: "single_item", ofType: "html")
    
    let pathToLastItemHTMLTemplate = Bundle.main.path(forResource: "last_item", ofType: "html")
    
    let senderInfo = ""
    
    let dueDate = ""
    
    let paymentMethod = "Wire Transfer"
    
    let logoImageURL = "http://www.appcoda.com/wp-content/uploads/2015/12/blog-logo-dark-400.png"
    
    var invoiceNumber: String!
    
    var pdfFilename: String!
    
    
    override init() {
        super.init()
    }
    
    
    func renderInvoice(invoiceNumber: String, start: String, end: String, deskInfo: String, userInfo: String, items: [Cart], totalAmount: String, fee: String, total: String) -> String! {
        // Store the invoice number for future use.
        self.invoiceNumber = invoiceNumber
        
        do {
            // Load the invoice HTML template code into a String variable.
            var HTMLContent = try String(contentsOfFile: pathToInvoiceHTMLTemplate!)
            
            // Replace all the placeholders with real values except for the items.
            // The logo image.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#LOGO_IMAGE#", with: logoImageURL)
            
            // Invoice number.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#INVOICE_NUMBER#", with: invoiceNumber)
            
            // Invoice date.
            //HTMLContent = HTMLContent.replacingOccurrences(of: "#INVOICE_DATE#", with: invoiceDate)
            
            // Due date (we leave it blank by default).
            HTMLContent = HTMLContent.replacingOccurrences(of: "#DUE_DATE#", with: dueDate)
            
            // Due date (we leave it blank by default).
            HTMLContent = HTMLContent.replacingOccurrences(of: "#START#", with: start)
            
            // Due date (we leave it blank by default).
            HTMLContent = HTMLContent.replacingOccurrences(of: "#END#", with: end)
            
            // Sender info.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#DESK_INFO#", with: deskInfo)
            
            // Recipient info.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#USER_INFO#", with: userInfo)
            
            // Payment method.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#PAYMENT_METHOD#", with: paymentMethod)
            
            // Total amount.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#TOTAL_AMOUNT#", with: totalAmount)
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#FEE#", with: fee)
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#TOTAL#", with: total)
            
            // The invoice items will be added by using a loop.
            var allItems = ""
            
            // For all the items except for the last one we'll use the "single_item.html" template.
            // For the last one we'll use the "last_item.html" template.
            for i in 0..<items.count {
                var itemHTMLContent: String!
                
                // Determine the proper template file.
                if i != items.count - 1 {
                    itemHTMLContent = try String(contentsOfFile: pathToSingleItemHTMLTemplate!)
                }
                else {
                    itemHTMLContent = try String(contentsOfFile: pathToLastItemHTMLTemplate!)
                }
                
                // Replace the description and price placeholders with the actual values.
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#ITEM_DESC#",
                                   with: items[i].name + " x " + String(items[i].quantity))
                
                // Format each item's price as a currency value.
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#PRICE#", with: addCommaNumber(string: forTrailingZero(temp: items[i].price))!)
                
                // Add the item's HTML code to the general items string.
                allItems += itemHTMLContent
            }
            
            // Set the items.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ITEMS#", with: allItems)
            
            // The HTML code is ready.
            return HTMLContent
            
        }
        catch {
            print("Unable to open and use HTML template files.")
        }
        
        return nil
    }
    
    func forTrailingZero(temp: Double) -> String {
        let tempVar = String(format: "%g", temp)
        return tempVar
    }
    
    func addCommaNumber(string: String) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.groupingSize = 3
        let formattedNumber = numberFormatter.string(from: NSNumber(value: Double(string)!))
        return formattedNumber
    }
    
    func removeCommaNumber(string: String) -> String? {
        return string.replacingOccurrences(of: ",", with: "")
    }
    
    
    func exportHTMLContentToPDF(HTMLContent: String) {
        let printPageRenderer = UIPrintPageRenderer()
        
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
        
        pdfFilename = "\(AppDelegate.getAppDelegate().getDocDir())/Invoice\(invoiceNumber!).pdf"
        pdfData?.write(toFile: pdfFilename, atomically: true)
        
        print(pdfFilename)
    }
    
    
    func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        for i in 0..<printPageRenderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            printPageRenderer.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        
        UIGraphicsEndPDFContext()
        
        return data
    }
    
}
