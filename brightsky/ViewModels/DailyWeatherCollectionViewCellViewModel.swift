//
//  DailyWeatherCollectionViewCellViewModel.swift
//  brightsky
//
//  Created by Afraz Siddiqui on 9/18/23.
//

import WeatherKit
import Foundation

struct DailyWeatherCollectionViewCellViewModel {
    private let model: DayWeather

    init(model: DayWeather) {
        self.model = model
    }

    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()

    public var iconName: String {
        return model.symbolName
    }

    public var temperature: String {
        return "\(string(for: model.lowTemperature)) – \(string(for: model.highTemperature))"
    }

    private func string(for temp: Measurement<UnitTemperature>) -> String {
        return "\(Int(temp.converted(to: .fahrenheit).value)) °F"
    }

    public var day: String {
        let day = Calendar.current.component(.weekday, from: model.date)
        return string(from: day)
    }

    private func string(from day: Int) -> String {
        switch (day) {
        case 1:
            return "Monday"
        case 2:
            return "Tuesday"
        case 3:
            return "Wednesday"
        case 4:
            return "Thursday"
        case 5:
            return "Friday"
        case 6:
            return "Saturday"
        case 7:
            return "Sunday"
        default:
            return "Unavailable"
        }
    }
}
