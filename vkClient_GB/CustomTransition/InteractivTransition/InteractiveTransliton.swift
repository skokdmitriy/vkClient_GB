//
//  InteractiveTransliton.swift
//  VKClient
//
//  Created by Дмитрий Скок on 14.11.2021.
//

import UIKit

final class InteractiveTransition: UIPercentDrivenInteractiveTransition {

    var viewController: UIViewController? {
        didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handle(_:)))
            recognizer.edges = [.left]
            viewController?.view.addGestureRecognizer(recognizer)
        }
    }

    var isStarted: Bool = false
    var shouldFinish: Bool = false

    @objc func handle(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            isStarted = true
            viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            let transition = recognizer.translation(in: recognizer.view)
            let relative = transition.x / (recognizer.view?.bounds.width ?? 1)
            let progress = max(0, min(1, relative))

            self.shouldFinish = progress > 0.4

            update(progress)
        case .ended:
            isStarted = false
            shouldFinish ? finish() : cancel()

        case .cancelled:
            isStarted = false
            cancel()
        default:
            return
        }
    }
}
