import UIKit

class CheckBox: UIButton {

override func awakeFromNib() {
    print("???")
    self.setImage(UIImage(named:"Checkmark"), for: .normal)
    self.setImage(UIImage(named:"Checkmarkempty"), for: .selected)
    self.addTarget(self, action: #selector(CheckBox.buttonClicked(_:)), for: .touchUpInside)
}

@objc func buttonClicked(_ sender: UIButton) {
    self.isSelected = !self.isSelected
 }
}
