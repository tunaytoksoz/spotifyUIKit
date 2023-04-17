//
//  MenuBar.swift
//  SpotifyUIKit
//
//  Created by Tunay Toksöz on 14.04.2023.
//

import UIKit

protocol MenuBarDelegate : AnyObject {
    func didSelectItemAt(index : Int)
}

class MenuBar: UIView {
    
    let playlistButton : UIButton!
    let artistButton : UIButton!
    let albumsButton : UIButton!
    var buttons : [UIButton]!
    
    var indicator = UIView()
    
    var indicatorLeading : NSLayoutConstraint?
    var indicatorTrailing : NSLayoutConstraint?
    
    weak var delegate : MenuBarDelegate?
    
    var leadPadding : CGFloat = 16
    var buttonSpace : CGFloat = 36
    
    override init(frame: CGRect) {
        
        
        playlistButton = makeButton(withText: "Playlists")
        artistButton = makeButton(withText: "Artista")
        albumsButton = makeButton(withText: "Albums")
        
        buttons = [playlistButton,artistButton,albumsButton ]
        
        super.init(frame: .zero)
        
        playlistButton.addTarget(self, action: #selector(didTappedPlaylistButton), for: .primaryActionTriggered)
        artistButton.addTarget(self, action: #selector(didTappedArtistButton), for: .primaryActionTriggered)
        albumsButton.addTarget(self, action: #selector(didTappedAlbumsButton), for: .primaryActionTriggered)
        
        styleIndicator()
        setAlpha(for: playlistButton)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func styleIndicator(){
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.backgroundColor = .spotifyGreen
    }
    
    func layout(){
        addSubview(playlistButton)
        addSubview(artistButton)
        addSubview(albumsButton)
        addSubview(indicator)
        
        NSLayoutConstraint.activate([
            playlistButton.topAnchor.constraint(equalTo: topAnchor),
            playlistButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadPadding),
            artistButton.topAnchor.constraint(equalTo: topAnchor),
            artistButton.leadingAnchor.constraint(equalTo: playlistButton.trailingAnchor, constant: CGFloat(buttonSpace)),
            albumsButton.topAnchor.constraint(equalTo: topAnchor),
            albumsButton.leadingAnchor.constraint(equalTo: artistButton.trailingAnchor, constant: buttonSpace),
            
            indicator.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 3)
        ])
        
        indicatorLeading = indicator.leadingAnchor.constraint(equalTo: playlistButton.leadingAnchor)
        indicatorTrailing = indicator.trailingAnchor.constraint(equalTo: playlistButton.trailingAnchor)
        
        indicatorLeading?.isActive = true
        indicatorTrailing?.isActive = true
        
        
        }
}

extension MenuBar{
    @objc func didTappedPlaylistButton(){
        delegate?.didSelectItemAt(index: 0)
    }
    @objc func didTappedArtistButton(){
        delegate?.didSelectItemAt(index: 1)
    }
    @objc func didTappedAlbumsButton(){
        delegate?.didSelectItemAt(index: 2)
    }
}

func makeButton(withText text: String) -> UIButton {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(text, for: .normal)
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    button.titleLabel?.adjustsFontSizeToFitWidth = true
    return button
}

extension MenuBar {
    
    func selectItem(at index: Int) {
        animateIndicator(to : index)
    }
    private func animateIndicator(to index: Int){
        var button : UIButton
        switch index{
        case 0:
            button = playlistButton
        case 1:
            button = artistButton
        case 2:
            button = albumsButton
        default:
            button = playlistButton
        }
        
        setAlpha(for: button)
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func scrollIndicator(to contentOffset: CGPoint) {
        
        let index = Int(contentOffset.x / frame.width)
        let atScrollStart = Int(contentOffset.x) % Int(frame.width) == 0
        
        if atScrollStart {
            return
        }
        
        // determine percent scrolled relative to index
        let percentScrolled: CGFloat
        switch index {
        case 0:
             percentScrolled = contentOffset.x / frame.width - 0
        case 1:
            percentScrolled = contentOffset.x / frame.width - 1
        case 2:
            percentScrolled = contentOffset.x / frame.width - 2
        default:
            percentScrolled = contentOffset.x / frame.width
        }
        
        // determine buttons
        var fromButton: UIButton
        var toButton: UIButton
        
        switch index {
        case 2:
            fromButton = buttons[index]
            toButton = buttons[index - 1]
        default:
            fromButton = buttons[index]
            toButton = buttons[index + 1]
        }
        
        // animate alpha of buttons
        switch index {
        case 2:
            break
        default:
            fromButton.alpha = fmax(0.5, (1 - percentScrolled))
            toButton.alpha = fmax(0.5, percentScrolled)
        }
        
        let fromWidth = fromButton.frame.width
        let toWidth = toButton.frame.width
        
        // determine width
        let sectionWidth: CGFloat
        switch index {
        case 0:
            sectionWidth = leadPadding + fromWidth + buttonSpace
        default:
            sectionWidth = fromWidth + buttonSpace
        }

        // normalize x scroll
        let sectionFraction = sectionWidth / frame.width
        let x = contentOffset.x * sectionFraction
        
        let buttonWidthDiff = fromWidth - toWidth
        let widthOffset = buttonWidthDiff * percentScrolled

        // determine leading y
        let y:CGFloat
        switch index {
        case 0:
            if x < leadPadding {
                y = x
            } else {
                y = x - leadPadding * percentScrolled
            }
        case 1:
            y = x + 13
        case 2:
            y = x
        default:
            y = x
        }
        
        // Note: 13 is button width difference between Playlists and Artists button
        // from previous index. Hard coded for now.
        
        indicatorLeading?.constant = y

        // determine trailing y
        let yTrailing: CGFloat
        switch index {
        case 0:
            yTrailing = y - widthOffset
        case 1:
            yTrailing = y - widthOffset - leadPadding
        case 2:
            yTrailing = y - widthOffset - leadPadding / 2
        default:
            yTrailing = y - widthOffset - leadPadding
        }
        
        indicatorTrailing?.constant = yTrailing
        
       // print("\(index) percentScrolled=\(percentScrolled)")
    }
    
    
    private func setAlpha(for button : UIButton){
        playlistButton.alpha = 0.5
        artistButton.alpha = 0.5
        albumsButton.alpha = 0.5
        
        button.alpha = 1.0
    }
    
    
}





