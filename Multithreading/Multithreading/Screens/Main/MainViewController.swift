//
//  ViewController.swift
//  Multithreading
//
//  Created by Kirill Khudiakov on 06/03/2019.
//  Copyright © 2019 Kirill Khudiakov. All rights reserved.
//

import UIKit


class ViewModel {
    var value: Float = 0
    
    let concurrentQueue = DispatchQueue.init(label: "concurrent_queue_for_value", attributes: DispatchQueue.Attributes.concurrent)
    
    @objc func increaseBy1000() {
        concurrentQueue.async(flags: .barrier) {
            for _ in 0..<1000 {
                let v = self.value + 1
                self.value = v
                print("value->\(self.value)")
            }
        }
    }
    
    func resetValue() {
        value = 0
    }
}

class MainViewController: UIViewController {

    var startButton = UIButton(frame: .zero)
    
    var progressBarA = UIProgressView(frame: .zero)
    var progressBarB = UIProgressView(frame: .zero)
    var barsStackView = UIStackView(frame: .zero)
    
    var model: Float = 0
    var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addUI()
        setupConstraints()
    }
    
    func addUI() {
        progressBarA.progress = 0.0
        progressBarB.progress = 0.0
        progressBarA.trackTintColor = .clear
        progressBarB.trackTintColor = .clear
        progressBarA.progressTintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        progressBarB.progressTintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        
        barsStackView.backgroundColor = .orange
        barsStackView.axis = .vertical
        barsStackView.alignment = .center
        
        barsStackView.addArrangedSubview(progressBarA)
        barsStackView.addArrangedSubview(progressBarB)
        
        view.addSubview(barsStackView)
        
        startButton.setTitle("Start tasks", for: .normal)
        startButton.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        startButton.setTitleColor(.white, for: .normal)
        startButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        view.addSubview(startButton)
        
        startButton.addTarget(self, action: #selector(startTasks), for: .touchUpInside)
    }
    
    func setupConstraints() {
        
        progressBarA.translatesAutoresizingMaskIntoConstraints = false
        progressBarA.widthAnchor.constraint(equalTo: barsStackView.widthAnchor).isActive = true
        progressBarA.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        progressBarB.translatesAutoresizingMaskIntoConstraints = false
        progressBarB.widthAnchor.constraint(equalTo: barsStackView.widthAnchor).isActive = true
        progressBarB.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        barsStackView.translatesAutoresizingMaskIntoConstraints = false
        barsStackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        barsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        barsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

extension MainViewController {
    
    @objc func startTasks() {
        model = 0
        viewModel.resetValue()
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            self.viewModel.increaseBy1000()
        }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            self.viewModel.increaseBy1000()
        }

        
//        Thread.detachNewThreadSelector(#selector(ViewModel.increaseBy1000), toTarget: viewModel, with: nil)
//        Thread.detachNewThreadSelector(#selector(ViewModel.increaseBy1000), toTarget: viewModel, with: nil)
       
    }
    
    func updateProgressBarB() {
        progressBarB.progress = model
    }
}
