//
//  MainTabViewController.swift
//  eoshub
//
//  Created by kein on 2018. 7. 8..
//  Copyright © 2018년 EOS Hub. All rights reserved.
//

import Foundation
import UIKit

class MainTabViewController: TabBarViewController {
  
    var flowDelegate: MainTabFlowEventDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindActions()
    }
    
    private func setupUI() {
        setupMenus()
    }
    
    private func bindActions() {
        menuTabBar.selected
            .bind { [weak self](menu) in
                guard let strongSelf = self, let menu = menu as? MainMenu else { return }
                strongSelf.flowDelegate?.go(from: strongSelf, to: menu)
            }
            .disposed(by: bag)
    }
    
    private func setupMenus() {
        menuTabBar.configure(menus: [MainMenu.wallet, MainMenu.vote, MainMenu.airdrop])
        menuTabBar.selectMenu(menu: MainMenu.wallet)
    }
    
    
}
