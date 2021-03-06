import UIKit

// extending the UITextField as described here:
// http://purelywebdesign.co.uk/tutorial/swift-underlined-text-field-tutorial/

extension UITextField {
    
    func textFieldAsStandard(imageString: String, bootomBorder: Bool){
        
        let imageView = UIImageView();
        let image = UIImage(named: imageString);
        
        imageView.image = image;
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.frame = CGRect(x: 10, y: 10, width: 45 , height: 45)
        
        self.leftView = imageView;
        self.leftViewMode = UITextFieldViewMode.Always
        
        if bootomBorder{
            setBottomBorderTextField(image)
        }
        
    }
    
    private func setBottomBorderTextField(image: UIImage!){
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(x: 0,
                              y: self.frame.size.height - width,
                              width:  self.frame.size.width + image.size.width ,
                              height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}
