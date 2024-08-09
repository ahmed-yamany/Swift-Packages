//
//  AudioPlayer.swift
//
//
//  Created by Ahmed Yamany on 23/04/2024.
//

import UIKit
import AVFoundation

open class AudioPlayer: NibUIView {
    // MARK: - IBOutlet
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var slider: UISlider!
    @IBOutlet private weak var timeLabel: UILabel!
    
    private var pauseImage = UIImage(systemName: "pause")
    private var playImage = UIImage(systemName: "play.fill")
    private var audioPlayer = AVAudioPlayer()
    private var isPlaying: Bool = false
    private var playTimer: Timer?
    
    @IBInspectable open var timeTintColor: UIColor = .black {
        didSet {
            timeLabel.textColor = timeTintColor
        }
    }
    
    @IBInspectable open var minimumTrackTintColor: UIColor = .blue {
        didSet {
            slider.minimumTrackTintColor = minimumTrackTintColor
        }
    }
    
    @IBInspectable open var maximumTrackTintColor: UIColor = .gray {
        didSet {
            slider.maximumTrackTintColor = maximumTrackTintColor
        }
    }
    
    @IBInspectable open var thumbTintColor: UIColor = .black {
        didSet {
            configureSliderThumb()
        }
    }
    
    @IBInspectable open var buttonTintColor: UIColor = .blue {
        didSet {
            playButton.tintColor = buttonTintColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureUI()
    }
    
    deinit {
        stop()
    }
    
    public func setAudio(_ url: URL) throws {
        try audioPlayer = AVAudioPlayer(contentsOf: url)
        slider.maximumValue = Float(audioPlayer.duration)
        audioPlayer.delegate = self
    }
}

// MARK: - Configurations
private extension AudioPlayer {
    func configureUI() {
        heightAnchor.constraint(equalToConstant: 22).isActive = true
        configurePlayButton()
        configureSlider()
        configureTimeLabel()
    }
    
    func configurePlayButton() {
        playButton.tintColor = buttonTintColor
        playButton.setImage(playImage, for: .normal)
        playButton.addAction(.init(handler: { [weak self] _ in
            self?.playButtonTapped()
        }), for: .touchUpInside)
    }
    
    func configureSlider() {
        slider.value = 0.0
        configureSliderThumb()
        
        // slider action
        slider.addAction(.init(handler: { [weak self] _ in
            self?.sliderValuedChanged()
        }), for: .valueChanged)
    }
    
    func configureSliderThumb() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 12)
        let image = UIImage(
            systemName: "circle.fill",
            withConfiguration: configuration
        )?.withTintColor(
            thumbTintColor,
            renderingMode: .alwaysOriginal
        )
        slider.setThumbImage(image, for: .normal)
    }
    
    func configureTimeLabel() {
        timeLabel.text = "00:00"
        timeLabel.textColor = timeTintColor
    }
    
    func play() {
        playButton.setImage(pauseImage, for: .normal)
        audioPlayer.play()
        playTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateTime),
            userInfo: nil,
            repeats: true
        )
    }
    
    func pause() {
        playButton.setImage(playImage, for: .normal)
        audioPlayer.pause()
        playTimer?.invalidate()
    }
    
    func stop() {
        pause()
        audioPlayer.stop()
        slider.value = 0.0
    }
    
    func updateTimeLabelBasedOnCurrentTime() {
        let currentTime = Int(audioPlayer.currentTime)
        let minutes = currentTime / 60
        let seconds = currentTime - (minutes * 60)
        timeLabel.text = String(format: "%02d:%02d", minutes, seconds) as String
    }
    
    func updateSliderTime() {
        slider.value = Float(audioPlayer.currentTime)
    }
    
    @objc 
    func updateTime() {
        updateTimeLabelBasedOnCurrentTime()
        updateSliderTime()
    }
}

// MARK: - Actions
private extension AudioPlayer {
    func playButtonTapped() {
        isPlaying.toggle()
        
        if isPlaying {
            play()
        } else {
            pause()
        }
    }
    
    func sliderValuedChanged() {
        updateTimeLabelBasedOnCurrentTime()
        audioPlayer.currentTime = TimeInterval(slider.value)
    }
}

// MARK: - AVAudioPlayerDelegate
extension AudioPlayer: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            stop()
        }
    }
}
