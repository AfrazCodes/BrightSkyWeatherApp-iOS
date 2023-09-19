//
//  CurrentWeatherView.swift
//  brightsky
//
//  Created by Afraz Siddiqui on 9/18/23.
//

import UIKit

final class CurrentWeatherView: UIView {

    private var viewModel: [WeatherViewModel] = []

    private var collectionView: UICollectionView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

        createCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    public func configure(with viewModel: [WeatherViewModel]) {
        self.viewModel = viewModel
        collectionView?.reloadData()
    }

    private func createCollectionView() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.layout(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.register(CurrentWeatherCollectionViewCell.self,
                                forCellWithReuseIdentifier: CurrentWeatherCollectionViewCell.cellIdentifier)
        collectionView.register(HourlyWeatherCollectionViewCell.self,
                                forCellWithReuseIdentifier: HourlyWeatherCollectionViewCell.cellIdentifier)
        collectionView.register(DailyWeatherCollectionViewCell.self,
                                forCellWithReuseIdentifier: DailyWeatherCollectionViewCell.cellIdentifier)
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        self.collectionView =  collectionView
    }

    private func layout(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let section = CurrentWeatherSection.allCases[sectionIndex]

        switch section {
        case .current:
            let item = NSCollectionLayoutItem(layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            ))

            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.75)),
                subitems: [item]
            )

            return NSCollectionLayoutSection(group: group)
        case .hourly:
            let item = NSCollectionLayoutItem(layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            ))


            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(widthDimension: .fractionalWidth(0.25),
                                  heightDimension: .absolute(150)),
                subitems: [item]
            )
            group.contentInsets = .init(top: 1, leading: 2, bottom: 1, trailing: 2)

            let section =  NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            return section
        case .daily:
            let item = NSCollectionLayoutItem(layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            ))

            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                  heightDimension: .absolute(100)),
                subitems: [item]
            )
            group.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)

            return NSCollectionLayoutSection(group: group)
        }
    }
}

extension CurrentWeatherView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewModel[section] {
        case .current:
            return 1
        case .hourly(let viewModels):
            return viewModels.count
        case .daily(let viewModels):
            return viewModels.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel[indexPath.section] {
        case .current(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CurrentWeatherCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? CurrentWeatherCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell

        case .daily(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DailyWeatherCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? DailyWeatherCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell

        case .hourly(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HourlyWeatherCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? HourlyWeatherCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
    }
}
