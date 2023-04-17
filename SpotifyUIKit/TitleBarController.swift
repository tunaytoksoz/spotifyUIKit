//
//  ViewController.swift
//  SpotifyUIKit
//
//  Created by Tunay Toksöz on 13.04.2023.
//

import UIKit

class MusicViewController: UIViewController{
    override func viewDidLoad() {
       super.viewDidLoad()
        view.backgroundColor = .blue
    }
}

class PodcastViewController: UIViewController{
    override func viewDidLoad() {
       super.viewDidLoad()
        view.backgroundColor = .systemYellow
    }
}


class TitleBarController: UIViewController {
    
    var musicBarButtonItem : UIBarButtonItem!
    var podCastBarButtonItem : UIBarButtonItem!
    
    let container = Container()
    let viewControllers : [UIViewController] = [HomeController(), PodcastViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavBar()
        // Do any additional setup after loading the view.
    }
    
    
    func setupViews(){
        guard let contaierView = container.view else { return }
        
        contaierView.translatesAutoresizingMaskIntoConstraints = false
        contaierView.backgroundColor = .systemPink
        view.addSubview(contaierView)
        
        NSLayoutConstraint.activate([
            contaierView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            contaierView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contaierView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contaierView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        musicTapped()
    }
    
    func setupNavBar(){
        navigationItem.leftBarButtonItems = [musicBarButtonItem, podCastBarButtonItem]
        
        let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        self.navigationController?.navigationBar.isTranslucent = false
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil : Bundle?) {
        super.init(nibName: nil, bundle: nil)
        musicBarButtonItem = makeBarButtonItem(text: "Music", selector: #selector(musicTapped))
        podCastBarButtonItem = makeBarButtonItem(text: "Podcast", selector: #selector(podcastTapped))
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func makeBarButtonItem(text: String, selector: Selector) -> UIBarButtonItem {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: selector, for: .primaryActionTriggered)
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .largeTitle).withTraits(traits: [.traitBold]),
            NSAttributedString.Key.foregroundColor: UIColor.label]
        let attributeText = NSMutableAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])
        
        button.setAttributedTitle(attributeText, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }
    
    
    
    @objc func musicTapped(){
        if container.children.first == viewControllers[0] { return }
        
        container.add(viewControllers[0])
        
        animateTransition(fromVC: viewControllers[1], toVC: viewControllers[0]) { succes in
            self.viewControllers[1].remove()
        }
        
        UIView.animate(withDuration: 0.5) {
            self.musicBarButtonItem.customView?.alpha = 1.0
            self.podCastBarButtonItem.customView?.alpha = 0.5
        }
    }
    
    @objc func podcastTapped(){
        if container.children.first == viewControllers[1] { return }
        
        container.add(viewControllers[1])
        
        animateTransition(fromVC: viewControllers[0], toVC: viewControllers[1]) { succes in
            self.viewControllers[0].remove()
        }
        
        UIView.animate(withDuration: 0.5) {
            self.musicBarButtonItem.customView?.alpha = 0.5
            self.podCastBarButtonItem.customView?.alpha = 1.0
        }
    }
    
    func animateTransition(fromVC: UIViewController, toVC: UIViewController, comletion: @escaping ((Bool) -> Void)){
        guard
            let fromView = fromVC.view,
            let fromIndex = getIndex(forViewController: fromVC),
            let toView = toVC.view,
            let toIndex = getIndex(forViewController: toVC)
        else {
            return
        }
        
        let frame = fromVC.view.frame
        var fromFrameEnd = frame
        var toFrameStart = frame
        fromFrameEnd.origin.x = toIndex > fromIndex ? frame.origin.x - frame.width : frame.origin.x + frame.width
        toFrameStart.origin.x = toIndex > fromIndex ? frame.origin.x + frame.width : frame.origin.x - frame.width
        toView.frame = toFrameStart
        
        UIView.animate(withDuration: 0.5) {
            fromView.frame = fromFrameEnd
            toView.frame = frame
        } completion: { succes in
            comletion(succes)
        }
    }
    
    func getIndex(forViewController vc: UIViewController) -> Int? {
        for (index, thisVC) in viewControllers.enumerated(){
            if thisVC == vc { return index}
        }
        return nil
    }
    
    
}


extension UIFont {
    func withTraits(traits : UIFontDescriptor.SymbolicTraits) -> UIFont{
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func bold() -> UIFont{
        return withTraits(traits: .traitBold)
    }
    
}

extension UIViewController{
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

