//
//  LikeCounterView.swift
//  VKClient
//
//  Created by Дмитрий Скок on 26.10.2021.
//

import UIKit


protocol LikeCounterProtocol: AnyObject {
    func likeCounterIncrement(counter: Int)
    func likeCounterDecrement(counter: Int)
}


@IBDesignable class LikeCounterView: UIView {

    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var likeCounterLabel: UILabel!
    
    var likeEnable = false
    @IBInspectable var counter: Int = 0

    
    weak var delegate: LikeCounterProtocol?
    
    private var view: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    private func loadFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LikeCounterView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {return UIView()}
        return view
    }
    
    
    private func setup() {
        view = loadFromNib()
        guard let view = view else {return}
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        likeCounterLabel.text = String(counter)
        addSubview(view)
    }
 

    
    @IBAction func pressHeartButton(_ sender: Any) {
        
        
        guard let button = sender as? UIButton else {return}
        if likeEnable {
            button.setImage(UIImage(systemName: "heart"), for: .normal)
            counter -= 1
            likeCounterLabel.text = String(counter)
            delegate?.likeCounterDecrement(counter: counter)
        }
        else {
            button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            counter += 1
            likeCounterLabel.text = String(counter)
            delegate?.likeCounterIncrement(counter: counter)
        }
        
        UIView.transition(with: likeCounterLabel,
                          duration: 0.3,
                          options: .transitionFlipFromTop,
                          animations: { [unowned self] in
                            self.likeCounterLabel.text = String(counter)
        })
        
        likeEnable = !likeEnable
        
    }
    
}
