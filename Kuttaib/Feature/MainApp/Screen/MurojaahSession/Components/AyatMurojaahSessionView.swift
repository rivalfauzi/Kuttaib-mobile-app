//
//  AyatMurojaahSessionView.swift
//  Kuttaib
//
//  Created by mco on 10/11/26.
//

import UIKit

final class AyatMurojaahSessionView: UIView {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let title = UILabel()
    private let topSpacer = UIView()
    private let arabicLabel = UILabel()
    private let bottomSpacer = UIView()
    private let contentVStack = UIStackView()
    private let countHiddenLabel = UILabel()
    
    private var originalText: String = ""
    private var hideText: NSAttributedString?
    
    struct GenerateAyahResult {
        let attributeText: NSAttributedString
        let count: Int
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        layer.cornerRadius = 24
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
        backgroundColor = .white
        
        title.font = .systemFont(ofSize: 12, weight: .bold)
        title.textColor = .primaryGreen
        title.text = "PETUNJUK AWAL AYAT"
        title.textAlignment = .center
        
        arabicLabel.font = UIFont(name: "KFGQPCUthmanicScriptHAFS", size: 32)
        arabicLabel.textColor = .black
        arabicLabel.semanticContentAttribute = .forceRightToLeft
        arabicLabel.textAlignment = .center
        arabicLabel.numberOfLines = 0
        
        countHiddenLabel.font = .systemFont(ofSize: 12)
        countHiddenLabel.textColor = .systemGray2
        countHiddenLabel.textAlignment = .center
        
        [topSpacer, arabicLabel, bottomSpacer].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentVStack.addArrangedSubview($0)
        }
        
        contentVStack.axis = .vertical
        contentVStack.alignment = .fill
        contentVStack.distribution = .fill
        contentVStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(contentVStack)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        [title, scrollView, countHiddenLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            scrollView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            countHiddenLabel.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 16),
            countHiddenLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            countHiddenLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            countHiddenLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            contentVStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentVStack.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor),
            
            topSpacer.heightAnchor.constraint(
                equalTo: bottomSpacer.heightAnchor
            )
        ])
    }
    
    func configure(_ text: String, repetition: Int = 0) {
        var percentage: Double = 0
        
        if repetition > 5 {
            percentage = 1
        } else if repetition > 4 {
            percentage = 0.9
        } else if repetition > 2 {
            percentage = 0.8
        } else {
            percentage = 0.7
        }
        
        let generateHiddenAyah = generateHiddenAyah(from: text, hiddenPercentage: percentage)
        
        originalText = text
        hideText = generateHiddenAyah.attributeText
        
        arabicLabel.attributedText = generateHiddenAyah.attributeText
        countHiddenLabel.text = "\(generateHiddenAyah.count) kata disembunyikan"
    }
    
    func showAyah() {
        arabicLabel.text = originalText
    }
    
    func hideAyah() {
        arabicLabel.attributedText = hideText
    }
    
    private func generateHiddenAyah(from text: String, hiddenPercentage: Double) -> GenerateAyahResult {

        let words = text
            .split(whereSeparator: \.isWhitespace)
            .map(String.init)

        guard !words.isEmpty else {
            return GenerateAyahResult(
                attributeText: NSAttributedString(string: ""),
                count: 0
            )
        }

        let wordCount = words.count

        let hiddenCount = min(
            wordCount,
            Int((Double(wordCount) * hiddenPercentage).rounded(.down))
        )

        let visibleCount = max(0, wordCount - hiddenCount)

        var visibleIndexes = Set<Int>()

        // Jika belum 100%, prioritaskan kata yang ditampilkan
        if visibleCount > 0 {

            // Prioritas 1: kata pertama
            visibleIndexes.insert(0)

            // Prioritas 2: kata terakhir
            if visibleCount > 1 && wordCount > 1 {
                visibleIndexes.insert(wordCount - 1)
            }

            // Sisanya acak dari tengah
            let remainingVisibleCount = visibleCount - visibleIndexes.count

            if remainingVisibleCount > 0 {

                let middleIndexes = Array(
                    1..<max(wordCount - 1, 1)
                )

                let randomIndexes = middleIndexes
                    .shuffled()
                    .prefix(remainingVisibleCount)

                visibleIndexes.formUnion(randomIndexes)
            }
        }

        let hiddenIndexes = Set(
            (0..<wordCount).filter {
                !visibleIndexes.contains($0)
            }
        )

        var actualHiddenCount = 0

        let resultWords = words.enumerated().map { index, word -> String in

            if hiddenIndexes.contains(index) {
                actualHiddenCount += 1

                return String(
                    repeating: "_",
                    count: max(word.count, 3)
                )
            }

            return word
        }

        let finalText = resultWords.joined(separator: " ")

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.baseWritingDirection = .rightToLeft
        paragraphStyle.lineSpacing = 12

        let attributedText = NSAttributedString(
            string: finalText,
            attributes: [
                .font: UIFont(
                    name: "KFGQPCUthmanicScriptHAFS",
                    size: 32
                ) ?? .systemFont(ofSize: 32),
                .paragraphStyle: paragraphStyle
            ]
        )

        return GenerateAyahResult(
            attributeText: attributedText,
            count: actualHiddenCount
        )
    }
}
