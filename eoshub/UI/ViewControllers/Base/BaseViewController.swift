//
//  BaseViewController.swift
//  eoshub
//
//  Created by kein on 2018. 7. 8..
//  Copyright © 2018년 EOS Hub. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    let bag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func showNavigationBar(with tintColor: Color, animated: Bool = true, largeTitle: Bool = false) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
//        navigationController?.navigationBar.barTintColor = UIColor.clear
        navigationController?.view.backgroundColor = UIColor.clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true        
        navigationController?.navigationBar.tintColor = tintColor.uiColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: tintColor.uiColor]
        
        
        navigationController?.navigationBar.prefersLargeTitles = largeTitle
        switch tintColor {
        case .white:
            navigationController?.navigationBar.barStyle = .black
        case .basePurple, .darkGray:
            navigationController?.navigationBar.barStyle = .default
        default:
            break
        }
    }
    
}


extension BaseViewController {
    //Validate PIN
    func authentication(showAt vc: UIViewController) -> Observable<Bool> {
        let config = FlowConfigure(container: vc, parent: nil, flowType: .modal)
        let fc = ValidatePinFlowController(configure: config)
        fc.start(animated: true)
        
        return fc.validated.asObservable()
    }
    
    func unlockWallet(pinTarget vc: UIViewController, pubKey: String) -> Observable<Wallet> {
        
        return authentication(showAt: vc)
                .flatMap({ (validate) -> Observable<Wallet> in
                    if validate {
                        let wallet = Wallet(key: pubKey)
                        return Observable.just(wallet)
                    } else {
                        return Observable.error(EOSErrorType.authenticationFailed)
                    }
                })
    }
}
