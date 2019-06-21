//
//  PreviewViewController.swift
//  Print2PDF
//
//  Created by Gabriel Theodoropoulos on 14/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit
import MessageUI
import Alamofire


class PreviewViewController: UIViewController {
    
    let url = Server.init().url
    lazy var URL_ORDER = url + "order/"
    

    @IBOutlet weak var webPreview: UIWebView!
    
    var invoiceInfo: [String: AnyObject]!
    
    var invoiceComposer: InvoiceComposer!
    
    var HTMLContent: String!
    
    var cart: [Cart] = []
    var desk:Desk!
    var orderId = ""
    var timeOn = ""
    var fee = 0.0
    
    @IBAction func btnReturn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HOME")
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(desk.deskId)
        print(timeOn)
        getOrder(deskId: desk.deskId, timeOn: timeOn)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: IBAction Methods
    
    
    @IBAction func exportToPDF(_ sender: AnyObject) {
        invoiceComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
        showOptionsAlert()
    }
    
    
    // MARK: Custom Methods
    
    func createInvoiceAsHTML(orderId: String, startTime: String) {
        let time = Date()
        let minute = (time.minute < 10) ? "0\(time.minute)" : "\(time.minute)"
        invoiceComposer = InvoiceComposer()
        if let invoiceHTML = invoiceComposer.renderInvoice(invoiceNumber: "#" + orderId ,
                                                           start: startTime,
                                                           end: "\(time.hour):\(minute)",
                                                           deskInfo: desk.deskName, userInfo: "Nguyễn Xuân An",
                                                           items: cart,
                                                           totalAmount: getTotalAmount(), fee: "\(fee)%", total: getTotal()) {
            
            webPreview.loadHTMLString(invoiceHTML, baseURL: NSURL(string: invoiceComposer.pathToInvoiceHTMLTemplate!)! as URL)
            HTMLContent = invoiceHTML
        }
    }
    
    func getOrder(deskId: Int, timeOn: String) {
        print(self.URL_ORDER + "print/\(deskId)/\(timeOn)")
        Alamofire.request(self.URL_ORDER + "print/\(deskId)/\(timeOn)", method: .get, encoding: JSONEncoding.default).responseJSON
            { (response) in
                if let responseValue = response.result.value as! [String: Any]? {
                    if let responseOrder = responseValue["recordset"] as! [[String: Any]]? {
                        print(responseOrder)
                        for item in responseOrder {
                            self.createInvoiceAsHTML(orderId: item["SOHOADON"] as! String, startTime: item["GIOVAO"] as! String)
                            
                        }
                    }
                }
        }
    }
    
    func getTotalAmount() -> String {
        var total = 0.0
        for item in cart {
            total += item.price * Double(item.quantity)
        }
        return addCommaNumber(string: forTrailingZero(temp: total))!
    }
    
    func getTotal() -> String {
        var total = 0.0
        for item in cart {
            total += item.price * Double(item.quantity)
        }
        if(fee > 0) {
            total = total + (total * fee / 100)
        }
        return addCommaNumber(string: forTrailingZero(temp: total))!
    }
    
    
    func showOptionsAlert() {
        let alertController = UIAlertController(title: "Yeah!", message: "Your invoice has been successfully printed to a PDF file.\n\nWhat do you want to do now?", preferredStyle: UIAlertController.Style.alert)
        
        let actionPreview = UIAlertAction(title: "Preview it", style: UIAlertAction.Style.default) { (action) in
            if let filename = self.invoiceComposer.pdfFilename, let url = URL(string: filename) {
                let request = URLRequest(url: url)
                self.webPreview.loadRequest(request)
            }
        }
        
        let actionEmail = UIAlertAction(title: "Send by Email", style: UIAlertAction.Style.default) { (action) in
            DispatchQueue.main.async {
                self.sendEmail()
            }
        }
        
        let actionNothing = UIAlertAction(title: "Nothing", style: UIAlertAction.Style.default) { (action) in
            
        }
        
        alertController.addAction(actionPreview)
        alertController.addAction(actionEmail)
        alertController.addAction(actionNothing)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.setSubject("Invoice")
            mailComposeViewController.addAttachmentData(NSData(contentsOfFile: invoiceComposer.pdfFilename)! as Data, mimeType: "application/pdf", fileName: "Invoice")
            present(mailComposeViewController, animated: true, completion: nil)
        }
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
    
}
