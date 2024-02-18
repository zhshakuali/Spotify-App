//
//  ActionLabelView.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 14.02.2024.
//

import UIKit

struct ActionLabelViewViewModel {
    let text: String
    let actionTitle: String
}
protocol ActionLabelViewDelegate: AnyObject {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView)
}

class ActionLabelView: UIView {
    
    weak var delegate: ActionLabelViewDelegate?
    
    private let label: UILabel = {
       let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    private let button: UIButton = {
       let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        addSubview(button)
        clipsToBounds = true
        isHidden = true
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc func didTapButton() {
        delegate?.actionLabelViewDidTapButton(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 0, y: 0, width: width, height: height - 45)
        button.frame = CGRect(x: 0, y: height - 40, width: width, height: 40)
    }

    func configure(with viewModel: ActionLabelViewViewModel) {
        label.text = viewModel.text
        button.setTitle(viewModel.actionTitle, for: .normal)
    }
}
