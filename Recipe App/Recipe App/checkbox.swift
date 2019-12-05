import UIKit

class CheckBox: UIButton {

override func awakeFromNib() {
    self.isSelected = false
    self.setImage(UIImage(named:"Checkmark"), for: .selected)
    self.setImage(UIImage(named:"Checkmarkempty"), for: .normal)
    self.addTarget(self, action: #selector(CheckBox.buttonClicked(_:)), for: .touchUpInside)
}

@objc func buttonClicked(_ sender: UIButton) {
    //self.isSelected = !self.isSelected
    //print("Checkbox class' button clicked: \(self.isSelected)")
 }
}
