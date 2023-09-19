//
//  WeatherManager.swift
//  brightsky
//
//  Created by Afraz Siddiqui on 9/18/23.
//

import CoreLocation
import WeatherKit
import Foundation

final class WeatherManager {
    static let shared = WeatherManager()

    let service = WeatherService.shared

    public private(set) var currentWeather: CurrentWeather?
    public private(set) var hourlyWeather: [HourWeather] = []
    public private(set) var dailyWeather: [DayWeather] = []

    private init() {}

    public func getWeather(for location: CLLocation, completion: @escaping () -> Void) {
        Task {
            do {
                let result = try await service.weather(for: location)

                self.currentWeather = result.currentWeather
                self.dailyWeather = result.dailyForecast.forecast
                self.hourlyWeather = result.hourlyForecast.forecast

                completion()
            } catch {
                print("\n\nError:"+String(describing: error))
            }
        }
    }
}
