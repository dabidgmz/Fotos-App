//
//  ViewController.swift
//  Fotos-App
//
//  Created by david gomez herrera on 06/05/25.
//

import UIKit

class GaleriaViewController: UIViewController,UIImagePickerControllerDelegate,
                             UINavigationControllerDelegate

{
    @IBOutlet weak var SrcFoto: UIScrollView!
    
    @IBOutlet weak var ImbFoto: UIImageView!
    
    @IBOutlet weak var BtnAnterior: UIButton!
    
    
    @IBOutlet weak var BtnSiguiente: UIButton!
    
    @IBOutlet weak var LblContador: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    @IBAction func IrAnterior() {
    }
    
    
    @IBAction func IrSiguiente() {
    }
    
    
    @IBAction func mostrarMenu() {
        let menu  = UIAlertController(title: "Menu de Opciones", message: "Selecciona una opcion :", preferredStyle: .actionSheet)
        let camara = UIAlertAction(title: "Tomar Foto", style: .default) { accion in
            self.tomarFotoCamara()
        }
        let galeria = UIAlertAction(title:"Foto de la galeria", style: .default) {accion in
            self.seleccionarFotoGaleria()
        }
        let guardar = UIAlertAction(title: "Guardar Foto en galeria", style: .default){accion in
            self.guardarFotoGaleria()
        }
        
        let cancelar = UIAlertAction(title: "Cnacelar", style: .cancel)
        
        menu.addAction(camara)
        menu.addAction(galeria)
        menu.addAction(guardar)
        menu.addAction(cancelar)
        present(menu, animated: true)
        
    }
    
    func tomarFotoCamara(){
        let camara = UIImagePickerController()
        camara.sourceType = .photoLibrary
        //en caso de tener iphone poder usar .camara
        //camara.sourceType = .photoLibrary
        camara.delegate = self
        present(camara, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        print(info[.originalImage] as! UIImage)
    }
    func seleccionarFotoGaleria(){
        
    }
    
    func guardarFotoGaleria(){
        
    }
    
}

