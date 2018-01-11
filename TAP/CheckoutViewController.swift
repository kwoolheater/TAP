//
//  CheckoutViewController.swift
//  TAP
//
//  Created by Kiyoshi Woolheater on 11/15/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//

import Foundation
import UIKit
import Stripe

class CheckoutViewController: UIViewController {
    
    // stripe variables
    let stripePublishableKey = "pk_test_zXwdlOOuj7gAsRYuZux4NsaU"
    
    
    let paymentCurrency = "usd"
    let paymentContext: STPPaymentContext
    let theme: STPTheme
    let paymentRow: CheckoutRowView
    let shippingRow: CheckoutRowView
    let totalRow: CheckoutRowView
    let buyButton: BuyButton
    let rowHeight: CGFloat = 44
    let numberFormatter: NumberFormatter
    let shippingString: String
    var product = ""
    
    /*init(product: String, price: Int, settings: Settings) {
        
        let stripePublishableKey = self.stripePublishableKey
        let backendBaseURL = self.backendBaseURL
        
        assert(stripePublishableKey.hasPrefix("pk_"), "You must set your Stripe publishable key at the top of CheckoutViewController.swift to run this app.")
        assert(backendBaseURL != nil, "You must set your backend base url at the top of CheckoutViewController.swift to run this app.")
        
        self.product = product
        // self.productImage.text = product
        self.theme = settings.theme
        // MyAPIClient.sharedClient.baseURLString = self.backendBaseURL
        
        // This code is included here for the sake of readability, but in your application you should set up your configuration and theme earlier, preferably in your App Delegate.
        let config = STPPaymentConfiguration.shared()
        config.publishableKey = self.stripePublishableKey
        // config.appleMerchantIdentifier = self.appleMerchantID
        // config.companyName = self.companyName
        config.requiredBillingAddressFields = settings.requiredBillingAddressFields
        config.requiredShippingAddressFields = settings.requiredShippingAddressFields
        config.shippingType = settings.shippingType
        config.additionalPaymentMethods = settings.additionalPaymentMethods
        
        let customerContext = STPCustomerContext(keyProvider: MyAPIClient.sharedClient)
        let paymentContext = STPPaymentContext(customerContext: customerContext,
                                               configuration: config,
                                               theme: settings.theme)
        let userInformation = STPUserInformation()
        paymentContext.prefilledInformation = userInformation
        paymentContext.paymentAmount = price
        paymentContext.paymentCurrency = self.paymentCurrency
        
        let paymentSelectionFooter = PaymentContextFooterView(text: "You can add custom footer views to the payment selection screen.")
        paymentSelectionFooter.theme = settings.theme
        paymentContext.paymentMethodsViewControllerFooterView = paymentSelectionFooter
        
        let addCardFooter = PaymentContextFooterView(text: "You can add custom footer views to the add card screen.")
        addCardFooter.theme = settings.theme
        paymentContext.addCardViewControllerFooterView = addCardFooter
        
        self.paymentContext = paymentContext
        
        self.paymentRow = CheckoutRowView(title: "Payment", detail: "Select Payment",
                                          theme: settings.theme)
        var shippingString = "Contact"
        if config.requiredShippingAddressFields.contains(.postalAddress) {
            shippingString = config.shippingType == .shipping ? "Shipping" : "Delivery"
        }
        self.shippingString = shippingString
        self.shippingRow = CheckoutRowView(title: self.shippingString,
                                           detail: "Enter \(self.shippingString) Info",
            theme: settings.theme)
        self.totalRow = CheckoutRowView(title: "Total", detail: "", tappable: false,
                                        theme: settings.theme)
        self.buyButton = BuyButton(enabled: true, theme: settings.theme)
        var localeComponents: [String: String] = [
            NSLocale.Key.currencyCode.rawValue: self.paymentCurrency,
            ]
        localeComponents[NSLocale.Key.languageCode.rawValue] = NSLocale.preferredLanguages.first
        let localeID = NSLocale.localeIdentifier(fromComponents: localeComponents)
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: localeID)
        numberFormatter.numberStyle = .currency
        numberFormatter.usesGroupingSeparator = true
        self.numberFormatter = numberFormatter
        super.init(nibName: nil, bundle: nil)
        self.paymentContext.delegate = self
        paymentContext.hostViewController = self
    }*/
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*self.view.backgroundColor = self.theme.primaryBackgroundColor
        var red: CGFloat = 0
        self.theme.primaryBackgroundColor.getRed(&red, green: nil, blue: nil, alpha: nil)
        // self.activityIndicator.activityIndicatorViewStyle = red < 0.5 ? .white : .gray
        self.navigationItem.title = "Emoji Apparel"
        
        // self.productImage.font = UIFont.systemFont(ofSize: 70)
        self.view.addSubview(self.totalRow)
        self.view.addSubview(self.paymentRow)
        self.view.addSubview(self.shippingRow)
        // self.view.addSubview(self.productImage)
        self.view.addSubview(self.buyButton)
        // self.view.addSubview(self.activityIndicator)
        // self.activityIndicator.alpha = 0
        self.buyButton.addTarget(self, action: #selector(didTapBuy), for: .touchUpInside)
        self.totalRow.detail = self.numberFormatter.string(from: NSNumber(value: Float(self.paymentContext.paymentAmount)/100))!
        self.paymentRow.onTap = { [weak self] _ in
            self?.paymentContext.pushPaymentMethodsViewController()
        }
        self.shippingRow.onTap = { [weak self] _ in
            self?.paymentContext.pushShippingViewController()
        }*/
    }
    
    /*override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = self.view.bounds.width
        // self.productImage.sizeToFit()
        // self.productImage.center = CGPoint(x: width/2.0, y: self.productImage.bounds.height/2.0 + rowHeight)
        self.paymentRow.frame = CGRect(x: 0, y: self.productImage.frame.maxY + rowHeight,
                                       width: width, height: rowHeight)
        self.shippingRow.frame = CGRect(x: 0, y: self.paymentRow.frame.maxY,
                                        width: width, height: rowHeight)
        self.totalRow.frame = CGRect(x: 0, y: self.shippingRow.frame.maxY,
                                     width: width, height: rowHeight)
        self.buyButton.frame = CGRect(x: 0, y: 0, width: 88, height: 44)
        self.buyButton.center = CGPoint(x: width/2.0, y: self.totalRow.frame.maxY + rowHeight*1.5)
        // self.activityIndicator.center = self.buyButton.center
    }*/
    
    func didTapBuy() {
        // self.paymentInProgress = true
        self.paymentContext.requestPayment()
    }
    
    
}
