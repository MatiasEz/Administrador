import UIKit
import QRCode

class InformationViewController: UIViewController {
    
    
    @IBOutlet weak var copyURLTextView: UITextView!
    @IBOutlet weak var copyLinkTextView: UITextView!
    @IBOutlet weak var confirmationButton: UIButton!
    @IBOutlet weak var qrImageView: UIImageView!
    var currentImage: UIImage?
    var currentEvent: String?
    
    @IBOutlet weak var eventCodeButton: UIButton!
    
    override func viewDidLoad() {
      
      super.viewDidLoad()
        self.eventCodeButton.backgroundColor = .clear
        self.eventCodeButton.layer.cornerRadius = 20
        self.eventCodeButton.layer.borderWidth = 1
        self.eventCodeButton.layer.borderColor = UIColor.white.cgColor

        self.confirmationButton.backgroundColor = .clear
        self.confirmationButton.layer.cornerRadius = 20
        self.confirmationButton.layer.borderWidth = 1
        self.confirmationButton.layer.borderColor = UIColor.white.cgColor

      
      let url = URL(string: "http://www.eventossiriolibanes.com/app/index.html?evento=\(self.currentEvent!)")!
      let qrCode = QRCode(url)
      self.copyLinkTextView.text = self.currentEvent!
      self.currentImage = qrCode?.image
      self.qrImageView.image = self.currentImage
    }
    @IBAction func copyURLButtonAction(_ sender: Any) {
      let pasteBoard = UIPasteboard.general
      pasteBoard.string = self.copyURLTextView.text
      let alert = UIAlertController(title: "Copiado", message: "Se ha copiado este texto en tu portapapeles", preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func copyLinkButtonAction(_ sender: Any) {
      let pasteBoard = UIPasteboard.general
      pasteBoard.string = self.copyLinkTextView.text
      let alert = UIAlertController(title: "Copiado", message: "Se ha copiado este texto en tu portapapeles", preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
   
   public func setUpCode (code : String) {
      self.currentEvent = code
   }
    
    @IBAction func downloadQRCodeImage(_ sender: Any) {
     
      
      // image to share
      let image = self.currentImage
      
      // set up activity view controller
      let imageToShare = [ image! ]
      let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
      activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
      
      // exclude some activity types from the list (optional)
      activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
      
      // present the view controller
      self.present(activityViewController, animated: true, completion: nil)
   }
   
   func getDocumentsDirectory() -> URL {
      let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      return paths[0]
   }
    
    @IBAction func confirmButton(_ sender: Any) {
      self.navigationController?.popToRootViewController(animated: true)
    }
    
}
