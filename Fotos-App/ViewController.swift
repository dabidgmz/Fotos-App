//
//  ViewController.swift
//  Fotos-App
//
//  Created by david gomez herrera on 06/05/25.
//

import UIKit
import PhotosUI

class GaleriaViewController: UIViewController,UIImagePickerControllerDelegate,
                             UINavigationControllerDelegate,UIScrollViewDelegate, PHPickerViewControllerDelegate

{
    
    
    @IBOutlet weak var SrcFoto: UIScrollView!
    
    @IBOutlet weak var ImbFoto: UIImageView!
    
    @IBOutlet weak var BtnAnterior: UIButton!
    
    
    @IBOutlet weak var BtnSiguiente: UIButton!
    
    @IBOutlet weak var LblContador: UILabel!
    
    
    var foto: [UIImage] = []
    var indice = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return ImbFoto
    }
    
    @IBAction func IrAnterior() {
        indice -= 1
        setFotos()
    }
    
    
    @IBAction func IrSiguiente() {
        indice += 1
        setFotos()
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
        foto.append(info[.originalImage] as! UIImage)
        if !foto.isEmpty{
            indice = foto.count - 1;
        }
        setFotos();
        
    }
    
    func setFotos(){
        ImbFoto.image = foto[indice]
        LblContador.text = "\(indice+1)/\(foto.count)"
        
        if indice == 0{
            BtnAnterior.isHidden = true;
        }
        else{
            BtnAnterior.isHidden = false;
        }
        
        if indice+1 == foto.count{
            
            BtnSiguiente.isHidden = true;
        }
        else{
            BtnSiguiente.isHidden = false;
        }
        let escalaW = SrcFoto.frame.width / foto[indice].size.width
        let escalaH = SrcFoto.frame.height / foto[indice].size.height
        let escala = min(escalaH, escalaW)
        SrcFoto.minimumZoomScale = escala
        SrcFoto.maximumZoomScale = escala * 20
        SrcFoto.zoomScale = escala
        
    }
    
    func seleccionarFotoGaleria(){
        
        var config = PHPickerConfiguration()
        config.selectionLimit = 2
        config.filter = .images
        
        let galeria = PHPickerViewController(configuration: config)
        galeria.delegate = self
        present(galeria, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for resultado in results {
            resultado.itemProvider.loadObject(ofClass: UIImage.self) { objeto, error in
                print("Error al cargar imagen: \(String(describing: error?.localizedDescription))")
            }
        }
        dismiss(animated: true)
    }

    
    func guardarFotoGaleria(){
        
    }
    
}
