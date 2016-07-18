import UIKit

// extending the UITextField as described here:
// http://purelywebdesign.co.uk/tutorial/swift-underlined-text-field-tutorial/

extension UITextField {
    
    func setTextFieldLeftIcon(imageString: String!){
        
        let imageView = UIImageView();
        let image = UIImage(named: imageString);
        
        imageView.image = image;
        imageView.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        self.leftView = imageView;
        self.leftViewMode = UITextFieldViewMode.Always
    }
    
    func setBottomBorderTextField(){
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(x: 0,
                              y: self.frame.size.height - width,
                              width:  self.frame.size.width,
                              height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}
