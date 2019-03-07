//
//  ViewController.swift
//  Multithreading
//
//  Created by Kirill Khudiakov on 06/03/2019.
//  Copyright © 2019 Kirill Khudiakov. All rights reserved.
//

import UIKit


class Model {
    var value: Float = 0
    var progressPercent: Float = 0
    
    @objc func increase(with count: Float = 10000000, onProgress: @escaping (Float)->Void, onFinished: ()->Void = {}) {
        for _ in 0..<Int(count) {
            value += 1
            progressPercent = (value / count)
            if Int(value) % 1000 == 0 {
                onProgress(self.progressPercent)
            }
        }
        onFinished()
    }
    
    func resetValue() {
        value = 0
    }
    
    func printValue() {
        print("result value->\(value)")
    }
}

class MainViewController: UIViewController {

    var startButton = UIButton(frame: .zero)
    
    var progressBarA = UIProgressView(frame: .zero)
    var progressBarB = UIProgressView(frame: .zero)
    var barsStackView = UIStackView(frame: .zero)
    
    var models: [Model] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addUI()
        setupConstraints()
    }
    
    func addUI() {
        progressBarA.progress = 0.0
        progressBarB.progress = 0.0
        progressBarA.trackTintColor = .lightGray
        progressBarB.trackTintColor = .lightGray
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
        let model1 = Model()
        let model2 = Model()
        models.append(model1)
        models.append(model2)
        
       let semaphore = DispatchSemaphore(value: 0)
    
       let globalQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        
       globalQueue.async {
            model1.increase(onProgress: { progress in
                print("1️⃣semaphore \(progress) value -> \(semaphore.debugDescription)")
                self.updateProgressBarA(with: progress)
            }, onFinished: {
                semaphore.signal()
            }
            )
        }
        
        semaphore.wait()
       
        globalQueue.async {
            model2.increase(onProgress: { progress in
                print("2️⃣semaphore \(progress) value -> \(semaphore.debugDescription)")
                self.updateProgressBarB(with: progress)
            }, onFinished: {
                semaphore.signal()
            }
            )
        }
        
        semaphore.wait()
        
        
    }
    
    
    
    func updateProgressBarA(with progress: Float) {
        DispatchQueue.main.async {
            self.progressBarA.progress = progress
        }
    }
    
    func updateProgressBarB(with progress: Float) {
        DispatchQueue.main.async {
            self.progressBarB.progress = progress
            self.progressBarB.setNeedsDisplay()
        }
    }
}
