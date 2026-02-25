// Finly-iOS/Modules/Dashboard/Protocols/DashboardViewModelProtocol.swift
import Foundation

protocol DashboardViewModelProtocol {
    func didLoad()
    
    func didPullToRefresh()
    
    func didUpdateFilter(_ filter: PatternsFilter)
    func didChangeMinMatches(_ value: Int)
    func didChangePatternType(_ type: PatternType)
    func didChangeSortBy(_ sortBy: PatternsSortBy)
    func didToggleSortOrder()
    
    func didSelectPattern(_ patternId: String)
    
    func didTapRetry()
}
