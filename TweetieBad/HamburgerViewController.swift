//
//  HamburgerViewController.swift
//  TweetieBad
//
//  Created by Davis Wamola on 4/20/17.
//  Copyright © 2017 Davis Wamola. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

  @IBOutlet weak var menuView: UIView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!

  var originalLeftMargin: CGFloat!
  var contentViewWidth: CGFloat!

  var menuViewController: UIViewController! {
    didSet(oldContentViewController) {

      if oldContentViewController != nil {
        oldContentViewController.willMove(toParentViewController: nil)
        oldContentViewController.view.removeFromSuperview()
        oldContentViewController.didMove(toParentViewController: nil)
      }

      view.layoutIfNeeded()
      menuViewController.willMove(toParentViewController: self)
      menuView.addSubview(menuViewController.view)
      menuViewController.didMove(toParentViewController: self)
    }
  }

  var contentViewController: UIViewController!{
    didSet(oldContentViewController) {

      if oldContentViewController != nil {
        oldContentViewController.willMove(toParentViewController: nil)
        oldContentViewController.view.removeFromSuperview()
        oldContentViewController.didMove(toParentViewController: nil)
      }

      view.layoutIfNeeded()
      contentViewController.willMove(toParentViewController: self)
      contentView.addSubview(contentViewController.view)
      contentViewController.didMove(toParentViewController: self)

      UIView.animate(withDuration: 0.3) {
        self.leftMarginConstraint.constant = 0
        self.view.layoutIfNeeded()
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    contentViewWidth = self.view.frame.size.width

    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: view)
    let velocity = sender.velocity(in: view)

    if sender.state == .began {
      originalLeftMargin = leftMarginConstraint.constant
    } else if sender.state == .changed {
      leftMarginConstraint.constant = originalLeftMargin + translation.x
    } else if sender.state == .ended {
      UIView.animate(withDuration: 0.3, animations: {
        if velocity.x > 0 {
          // Opening menu
          self.leftMarginConstraint.constant = self.contentViewWidth/2
        } else {
          // Closing
          self.leftMarginConstraint.constant = 0
        }
        self.view.layoutIfNeeded()
      })
    }
  }
}
