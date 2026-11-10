//
//  RecordMurojaahSessionView.swift
//  Kuttaib
//
//  Created by mco on 10/11/26.
//

import UIKit

final class RecordMurojaahSessionView: UIView {
    private let recordHideTitle = UILabel()
    private let recordHideSubtitle = UILabel()
    private let micButton = RecordMicButton()
    
    private var recordingTimer: Timer?
    private var recordingSeconds = 0
    
    var onSaveRecord: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        recordHideTitle.font = .systemFont(ofSize: 18, weight: .bold)
        recordHideTitle.textColor = .primaryRed
        recordHideTitle.textAlignment = .center
        recordHideTitle.numberOfLines = 0
        recordHideTitle.text = "Sedang Merekam"
        recordHideTitle.isHidden = true
        
        recordHideSubtitle.font = .systemFont(ofSize: 14)
        recordHideSubtitle.textColor = .systemGray
        recordHideSubtitle.textAlignment = .center
        recordHideSubtitle.numberOfLines = 0
        recordHideSubtitle.text = "Tekan tombol untuk mulai merekam."
        
        [recordHideTitle, recordHideSubtitle, micButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            recordHideTitle.topAnchor.constraint(equalTo: topAnchor),
            recordHideTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            recordHideTitle.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            recordHideSubtitle.topAnchor.constraint(equalTo: recordHideTitle.bottomAnchor, constant: 12),
            recordHideSubtitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            recordHideSubtitle.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            micButton.topAnchor.constraint(equalTo: recordHideSubtitle.bottomAnchor, constant: 24),
            micButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            micButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            micButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        micButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
    }
    
    @objc private func recordTapped() {
        if micButton.isRecording {
            recordHideTitle.isHidden = false
            recordHideSubtitle.text = "00:00"
            startRecordingTimer()
            
            print("Start Recording")
        } else {
            stopRecordingTimer()
            recordHideTitle.isHidden = true
            recordHideSubtitle.text = "Tekan tombol untuk mulai merekam."
            
            onSaveRecord?()
            
            print("Stop Recording")
        }
    }
    
    private func startRecordingTimer() {
        recordingSeconds = 0
        updateTimerLabel()

        recordingTimer?.invalidate()

        recordingTimer = Timer.scheduledTimer( withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }

            self.recordingSeconds += 1
            self.updateTimerLabel()
        }
    }
    
    private func stopRecordingTimer() {
        recordingTimer?.invalidate()
        recordingTimer = nil
    }
    
    private func updateTimerLabel() {
        let minutes = recordingSeconds / 60
        let seconds = recordingSeconds % 60
        recordHideSubtitle.text = String(format: "%02d:%02d", minutes, seconds)
    }
}
