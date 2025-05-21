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
    
    
    
    @IBAction func hacerZoom(_ sender: UITapGestureRecognizer) {
        let nvEscala = SrcFoto.zoomScale * 2
        let w = SrcFoto.frame.width / nvEscala
        let h = SrcFoto.frame.width / nvEscala
        let punto = sender.location(in: ImbFoto)
        let x = punto.x - w/2
        let y = punto.y - h/2
        SrcFoto.zoom(to: CGRect(x: x, y: y, width: w, height: h), animated: true)
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
        config.selectionLimit = 3
        config.filter = .images
        
        let galeria = PHPickerViewController(configuration: config)
        galeria.delegate = self
        present(galeria, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        var contador = 0
        let limite = results.count
        
        for resultado in results {
            resultado.itemProvider.loadObject(ofClass: UIImage.self) {
                objeto, error in
                if let dato = objeto as? UIImage{
                    self.foto.append(dato)
                    contador += 1
                }
                else
                {
                    contador += 1
                }
                if contador == limite {
                    self.indice = self.foto.count - 1
                    DispatchQueue.main.async {
                        self.setFotos()
                    }
                }
            }
        }
        
    }

    
    func guardarFotoGaleria(){
        if indice > -1 {
            UIImageWriteToSavedPhotosAlbum(foto[indice], self, #selector(resGuardado), nil)
        }
    }
    
    @objc func resGuardado(_ img:UIImage?, _ error:NSError? , _ contexto:UnsafeMutableRawPointer?){
        var msg  = ""
        let er = error
        if  (er != nil)  {
            msg = "Ocurrio un error al guardar una imagen"
        }
        else {
            msg = "Se guardo la imagen"
        }
        let alerta = UIAlertController(title: "aviso", message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        present(alerta, animated: true)
    }
    
}
