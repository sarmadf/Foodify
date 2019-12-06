import UIKit

// This is a custom button class that looks like a checkbox. 
class CheckBox: UIButton {
    override func awakeFromNib() {
        self.isSelected = false
        self.setImage(UIImage(named:"Checkmark"), for: .selected)
        self.setImage(UIImage(named:"Checkmarkempty"), for: .normal)
        self.addTarget(self, action: #selector(CheckBox.buttonClicked(_:)), for: .touchUpInside)
    }

    @objc func buttonClicked(_ sender: UIButton) {}
}
