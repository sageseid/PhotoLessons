//
//  LessonDetailViewController.swift
//  PhotoLessons
//
//  Created by Noel Obaseki on 18/05/2023.
//

import Foundation
import SwiftUI
import AVKit
import AVFoundation

struct LessonDetailViewControllerWrapper: UIViewControllerRepresentable{
    var index: Int
    var lessons: [Lesson]
    typealias UIViewControllerType = LessonDetailViewController
    func makeUIViewController(context: Context) -> LessonDetailViewController {
        let lessonDetailViewController = LessonDetailViewController()
        lessonDetailViewController.index = index
        lessonDetailViewController.lessons = lessons
        return lessonDetailViewController
    }
    
    func updateUIViewController(_ uiViewController: LessonDetailViewController, context: Context) { }
    

}

class LessonDetailViewController: UIViewController{
    // Data
    var index: Int = 0
    var lessons: [Lesson]?
    var lesson: Lesson?
    
    // Design
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 26)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let nextLessonButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next Lesson >", for: .normal)
        button.setTitleColor(UIColor(red: 41/255, green: 114/255, blue: 217/255, alpha: 1.0), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Download variables
    private var downloadVideoSesson: URLSession?
    private var downloadTask: URLSessionDownloadTask?
    
    private let downloadProgressView = UIProgressView()
    private var downloadAlertView: UIAlertController?
    
    private var destinationUrl: URL?
    
    // MARK: View Controller life cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(customView: DownloadButton(target: self, selector: #selector(self.downloadVideo(_:))))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lesson = lessons![index]
        downloadVideoSesson = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue())
        destinationUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("lessonVideo\(index).mp4")
        setupScrollView()
        setupChildViews()
    }
    
    // MARK: Button Events
    
    @objc func nextLesson(sender : UIButton) {
        index += 1
        if (index < lessons!.count){
            lesson = lessons![index]
            setLesson()
        }else{
            nextLessonButton.removeFromSuperview()
        }
    }
    
    @objc func playMovie(sender : UIButton) {
        if Reachability.isConnectedToNetwork(){
            if let url = URL(string: lesson!.video_url){
                let player = AVPlayer(url: url)
                        
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                
                self.present(playerViewController, animated: true) { playerViewController.player?.play() }
            }
        }else{
            if(FileManager().fileExists(atPath: destinationUrl!.path)){
                let player = AVPlayer(playerItem: AVPlayerItem(asset: AVAsset(url: destinationUrl!)))

                let playerViewController = AVPlayerViewController()
                playerViewController.player = player

                self.present(playerViewController, animated: true) { playerViewController.player?.play() }
            }else{
                let alert = UIAlertController(title: "Alert", message: "You can't play the video", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func downloadVideo(_ sender: Any?) {
        
        if(FileManager().fileExists(atPath: destinationUrl!.path)){
            print("file already exists")
            let alert = UIAlertController(title: "Alert", message: "You already downloaded", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else{
            if Reachability.isConnectedToNetwork(){
                let videoUrl = lesson!.video_url

                downloadTask = downloadVideoSesson!.downloadTask(with: URL(string: videoUrl)!)
                downloadTask!.resume()
                downloadAlertView = UIAlertController(title: "Download Video\n", message: nil, preferredStyle: .alert)
                downloadAlertView!.addAction(UIAlertAction(title: "Cancel download", style: .cancel, handler: { [self] action in
                    print("Cancel download")
                    downloadTask!.cancel()
                }))

                present(downloadAlertView!, animated: true, completion: { [self] in
                    //  Add your progressbar after alert is shown (and measured)
                    let margin:CGFloat = 8.0
                    let rect = CGRect(x: margin, y: 60.0, width: downloadAlertView!.view.frame.width - margin * 2.0 , height: 22.0)
                    downloadProgressView.frame = rect
                    downloadProgressView.progress = 0.0
                    downloadProgressView.tintColor =  UIColor(red: 41/255, green: 114/255, blue: 217/255, alpha: 1.0)
                    downloadAlertView!.view.addSubview(downloadProgressView)
                })
            }else{
                let alert = UIAlertController(title: "Alert", message: "You can't download. Please check your network.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Modify Views
    
    private func setLesson() {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: URL(string: self!.lesson!.thumbnail)!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self!.thumbnailView.image = image
                    }
                }
            }
        }
        nameLabel.text = lesson!.name
        descriptionLabel.text = lesson!.description
        if(index == lessons!.count - 1){
            nextLessonButton.removeFromSuperview()
        }
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    private func setupChildViews(){
        contentView.addSubview(thumbnailView)
        thumbnailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        thumbnailView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        thumbnailView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1).isActive = true
        thumbnailView.heightAnchor.constraint(equalToConstant: 210).isActive = true

        let playButton = UIButton()
        playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 45, weight: .medium, scale: .default)), for: .normal)
        playButton.tintColor = UIColor.white
        playButton.addTarget(self, action: #selector(self.playMovie), for: .touchUpInside)
        self.view.addSubview(playButton)

        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.centerXAnchor.constraint(equalTo: thumbnailView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: thumbnailView.centerYAnchor).isActive = true

        contentView.addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14).isActive = true
        nameLabel.topAnchor.constraint(equalTo: thumbnailView.bottomAnchor, constant: 20).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true

        contentView.addSubview(descriptionLabel)
        descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true

        setLesson()

        if(index < lessons!.count - 1){
            nextLessonButton.addTarget(self, action: #selector(self.nextLesson), for: .touchUpInside)
            contentView.addSubview(nextLessonButton)
            nextLessonButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10).isActive = true
            nextLessonButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10).isActive = true
            nextLessonButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
            nextLessonButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        }else{
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            nextLessonButton.removeFromSuperview()
        }
    }
}


extension LessonDetailViewController: URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do{
            try FileManager().moveItem(at: location, to: destinationUrl!)
            print("finish download")
            DispatchQueue.main.async { [self] in
                downloadAlertView!.dismiss(animated: true)
                let alert = UIAlertController(title: "Alert", message: "Download Completed", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } catch{
            fatalError("Couldn't load \(destinationUrl!.absoluteString) from main bundle:\n\(error)")
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentDownloaded = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        print("percentage is \(percentDownloaded)")
        DispatchQueue.main.async { [self] in
            downloadProgressView.progress = Float(percentDownloaded)
        }
    }
}
