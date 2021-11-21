//
//  ContentView.swift
//  Swift Histogram (SwiftUICharts)
//
//  Created by Brad Brookfield on 11/14/21.
//

import SwiftUI
import SwiftUICharts

let fileName: String = "helloText"

struct ContentView: View {
    var body: some View {
        ScrollView {
            MainView()
        }
        .navigationTitle("Histograms")
        .frame(minWidth: 600, minHeight: 400)
    }
}

struct MainView: View {
    
    func readFile() -> String {
        var savedData = ""
        if let asset = NSDataAsset(name: fileName), let string = String(data: asset.data, encoding: String.Encoding.utf8) {
            savedData = string
        }
        return savedData
    }
    
    func wordCount(s: NSString) -> Dictionary<String, Int> {
        let words = s.components(separatedBy: NSCharacterSet.whitespaces)
        var wordDictionary = Dictionary<String, Int>()
        for word in words {
            if let count = wordDictionary[word] {
                wordDictionary[word] = count + 1
            } else {
                wordDictionary[word] = 1
            }
        }
        return wordDictionary
    }
    
    func retrieveGraphData() -> [DataPoint] {
        let str = readFile()
        let words = wordCount(s: str as NSString)

        var legends: [Legend] = []
        var datapoints: [DataPoint] = []

        for (word, count) in words {
            legends.append(Legend(color: .blue, label: LocalizedStringKey(word)))
            let datapoint: DataPoint = .init(value: Double(count), label: LocalizedStringKey(String(count)), legend: legends.last!)
            datapoints.append(datapoint)
        }
        return datapoints
    }
    
    var body: some View {
        VStack {
            let points: [DataPoint] = retrieveGraphData()
            Spacer()
            Section(header: Text("\"\(fileName)\" Word Frequency")) {
                HorizontalBarChartView(dataPoints: points)
                    .padding()
            }
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
