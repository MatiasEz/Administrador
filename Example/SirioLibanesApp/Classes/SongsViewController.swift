//
//  SongsViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import PKHUD

class SongsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    typealias CompletionHandler = ( (_ success:Bool) -> Void )?

    public var information : [AnyHashable: Any] = [:]
    public var pageName : String = ""
    var songs : [[AnyHashable:Any]] = [];
    var ref: DatabaseReference! = Database.database().reference()
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton.backgroundColor = .clear
        actionButton.layer.cornerRadius = 20
        actionButton.layer.borderWidth = 1
        actionButton.layer.borderColor = UIColor.white.cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.alpha = 0
        self.descriptionLabel.alpha = 0
        getUserDataAndContinue()
    }
    @IBAction func deletePressed(_ sender: Any) {
        let button = sender as! UIButton
        let map = self.songs [button.tag]
        let songTitle = map ["tema"] as! String
        changeCounter(for: songTitle, increasing: false, deleting: true)
    }
    
    @IBAction func minusPressed(_ sender: Any) {
        let button = sender as! UIButton
        let map = self.songs [button.tag]
        let songTitle = map ["tema"] as! String
        changeCounter(for: songTitle, increasing: false, deleting: false)
    }
    
    @IBAction func plusPressed(_ sender: Any) {
        let button = sender as! UIButton
        let map = self.songs [button.tag]
        let songTitle = map ["tema"] as! String
      changeCounter(for: songTitle, increasing: true, deleting:  false)
    }
    
    func changeCounter(for song : String, increasing increase : Bool, deleting delete : Bool) {
         var currentMap : [AnyHashable:Any]?
         for map in self.songs {
             let title = map ["tema"] as! String
             if (title == song) {
                 currentMap = map
             }
         }

         if (currentMap == nil) {
             self.displayError(message: "No pudimos registrar tu voto")
             return
         }
      
      
         self.songs = self.songs.filter { $0 ["tema"] as! String != song}
      
         if (delete == false) {
            var counter = currentMap! ["votos"] as! Int
            if (increase) {
               counter += 1
            } else {
               counter -= 1
            }
            
            
            let artist = (currentMap! ["artista"] as! String?) ?? "Desconocido"
            let newMap = ["tema":song,"votos":counter, "artista":artist] as [AnyHashable : Any]
            self.songs.append(newMap)
         }
         self.songs = self.songs.sorted(by: self.sorterForSong)
         self.ref.child("Musica").child(self.pageName).setValue(self.songs)
      
         self.descriptionLabel.text = "Estas son las canciones más votadas"
         self.tableView.reloadData()
         if (self.tableView.alpha == 0) {
             UIView.animate(withDuration: 0.3, animations: {
                 self.tableView.alpha = 1
                 self.descriptionLabel.alpha = 1
             })
         }
    }
    
    func sorterForSong(this:[AnyHashable:Any], that:[AnyHashable:Any]) -> Bool {
        let monto1 = this ["votos"] as! Int
        let monto2 = that ["votos"] as! Int
        if (monto1 > monto2) {
            return true;
        } else {
            return false;
        }
    }
    
    func getUserDataAndContinue () {
        let userEmail = Auth.auth().currentUser?.email;
        
        if (userEmail == nil) {
            self.displayError()
            return;
        }
        
        ref.child("Musica").child(pageName).observe( .value, with: { (snapshot) in
            // Get user value
            self.songs = [];
            let allInvites = snapshot.value as? [[AnyHashable:Any]] ?? []
            self.songs = allInvites;
            
            if (self.songs.count == 0) {
                self.descriptionLabel.text = "No encontramos canciones propuestas aun"
                UIView.animate(withDuration: 0.3, animations: {
                    self.descriptionLabel.alpha = 1
                })
            } else {
                self.descriptionLabel.text = "Estas son las canciones más votadas"
                self.tableView.reloadData()
                UIView.animate(withDuration: 0.3, animations: {
                    self.tableView.alpha = 1
                    self.descriptionLabel.alpha = 1
                })
            }
         
            PKHUD.sharedHUD.hide()
            
            
        }) { (error) in
            self.displayError()
        }
    }    
    
   
   @IBAction func proposeNewSong(_ sender: Any) {
      
      let alertController = UIAlertController(title: "¿Qué canción quieres proponer?", message: "", preferredStyle: .alert)
      
      let saveAction = UIAlertAction(title: "OK", style: .default, handler: {
         alert -> Void in
         
         let firstTextField = alertController.textFields![0] as UITextField?
         if ((firstTextField?.text)!.isEmpty) {
            self.displayError(message: "Debes ingresar el nombre de la canción")
            return
         }
         self.chooseArtist((firstTextField?.text)!);
         
      })
      
      let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
         (action : UIAlertAction!) -> Void in
         
      })
      
      alertController.addTextField { (textField : UITextField!) -> Void in
         textField.placeholder = "Nombre del tema"
      }
      
      alertController.addAction(cancelAction)
      alertController.addAction(saveAction)
      
      self.present(alertController, animated: true, completion: nil)
   }
   
   func chooseArtist (_ song : String){
      
      let alertController = UIAlertController(title: "¿Quien es el autor de esta canción?", message: "", preferredStyle: .alert)
      
      let saveAction = UIAlertAction(title: "OK", style: .default, handler: {
         alert -> Void in
         
         let firstTextField = alertController.textFields![0] as UITextField?
         
         if ((firstTextField?.text)!.isEmpty) {
            self.displayError(message: "Debes ingresar el nombre del artista")
            return
         }
         
         self.sendSong(song: song, artist: (firstTextField?.text)!);
         
      })
      
      let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
         (action : UIAlertAction!) -> Void in
         
      })
      
      alertController.addTextField { (textField : UITextField!) -> Void in
         textField.placeholder = "Nombre del artista"
      }
      
      alertController.addAction(cancelAction)
      alertController.addAction(saveAction)
      
      self.present(alertController, animated: true, completion: nil)
   }
   
   func sendSong (song : String, artist : String)
   {
      if (song.isEmpty) {
         self.displayError(message:"El campo de ingreso esta vacio");
         return
      }
      let map = ["tema":song,"artista":artist,"votos":1] as [AnyHashable : Any]
      self.songs.append(map)
      self.songs = self.songs.sorted(by: self.sorterForSong)
      self.ref.child("Musica").child(self.pageName).setValue(self.songs)
      self.descriptionLabel.text = "Estas son las canciones más votadas"
      self.tableView.reloadData()
      if (self.tableView.alpha == 0) {
         UIView.animate(withDuration: 0.3, animations: {
            self.tableView.alpha = 1
            self.descriptionLabel.alpha = 1
         })
      }
   }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let song = self.songs [indexPath.row]
      let cell = tableView.dequeueReusableCell(withIdentifier: "songCell") as! SongTableViewCell
      cell.tag = indexPath.row
      cell.songLabel.text = song ["tema"] as! String?
      let artist = (song ["artista"] as! String?) ?? "Desconocido"
      cell.artistLabel.text = artist
      let number = song ["votos"] as! Int
      cell.counterLabel.text = "\(number)"
        return cell
    }
    
    func displayError (message: String = "No pudimos obtener las canciones, intenta mas tarde.") {
        PKHUD.sharedHUD.hide()
        let alert = UIAlertController(title: "¡Hubo un error!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
