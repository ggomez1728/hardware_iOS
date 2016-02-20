//
//  ViewController.swift
//  Reproductor
//
//  Created by Pollinion User on 19/02/16.
//  Copyright © 2016 Pollinion INC. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    var counter = 0
    var player = AVAudioPlayer()
    var index : Int = 0
    var randor_play :Bool = false
    
    @IBOutlet weak var random_button: UIButton!
    @IBOutlet weak var title_layer: UILabel!
    
    var songs: [(song:String, exten: String, title: String, img: String)] = []
    
    @IBOutlet weak var image_song: UIImageView!
    @IBOutlet weak var volumen: UISlider!
    
    private var reproductor: AVAudioPlayer!
    
    @IBOutlet weak var play_list: UITextView!
 
    @IBAction func volume(sender: AnyObject) {
        reproductor.volume = volumen.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        songs.append(("Robotic_Bang", "aif", "Robotic Bang","robot.png"))
        songs.append(("Rummage", "aif","Rummage","swift.png"))
        songs.append(("Siren", "aif","Sirena","logotm.png"))
        play_list.selectable = false
        music()
        
    }
    
    @IBAction func last_song(sender: AnyObject) {
        if index == 0{
            index = songs.count - 1
        }
        else{
            --index
        }
        music()
        reproductor.play()
    }
    
    @IBAction func random_action(sender: AnyObject) {
        randor_play = !randor_play
        if randor_play == true {
            random_button.setTitle("shuffle( on)", forState: UIControlState.Normal)
        }else{
            random_button.setTitle("shuffle(off)", forState: UIControlState.Normal)
        }
        
    }

    @IBAction func next_song(sender: AnyObject) {
        if index < (songs.count - 1){
            index++
        }
        else{
            index = 0
        }
        music()
        reproductor.play()
    }
    
    func music(){
        let sonidoURL = NSBundle.mainBundle().URLForResource(String(songs[index].song), withExtension: String(songs[index].exten))
        do{
            try reproductor = AVAudioPlayer(contentsOfURL: sonidoURL!)
            reproductor.delegate = self
            reproductor.prepareToPlay()
            reproductor.volume = volumen.value
            showPlayList()
        }
        catch{
            print("Error al cargar el archivo de sonido")
        }
    }
    
    func showPlayList(){
        var txtShow: String = ""
        for song in songs{
            if songs[index].title == song.title {
                txtShow = txtShow + "->\(song.title) \n"
                title_layer.text = song.title
                let imageName = song.img
                let image = UIImage(named: imageName)
                let imageview = UIImageView(image: image!)
                imageview.frame = CGRect(x: 0, y: 0, width: 150, height: 200)
                image_song.addSubview(imageview)
            }
            else{
                txtShow = txtShow + "  \(song.title) \n"
            }
        }
        play_list.text = txtShow
    }
  
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if randor_play == false {
            if index < (songs.count - 1){
                index++
            }
            else{
                index = 0
            }

        }
        else{
            index = Int(arc4random_uniform(UInt32(songs.count)))
        }
        music()
        reproductor.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stop(sender: AnyObject) {
        if reproductor.playing{
            reproductor.stop()
            reproductor.currentTime = 0.0
        }
    }
    
    @IBAction func pause(sender: AnyObject) {
        if reproductor.playing{
            reproductor.pause()
        }
    }

    @IBAction func play(sender: AnyObject) {
        if !reproductor.playing{
            reproductor.play()
        }

    }

}

