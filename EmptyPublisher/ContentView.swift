//
//  ContentView.swift
//  EmptyPublisher
//
//  Created by sss on 11.05.2023.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @StateObject private var viewModel = EmptyFailurePublishersViewModel()
    
    var isVisible = false
    
    var body: some View {
        VStack(spacing: 20){
            List(viewModel.dataToView, id: \.self) { item in
                Text(item)
            }
            .font(.title)
        }
        .onAppear{
            viewModel.fetch()
        }
    }
}

class EmptyFailurePublishersViewModel: ObservableObject {
    
    @Published var dataToView: [String] = []
    
    let data = ["Value 1", "Value 2", "Value 3", nil, "Value 5", "Value 6"]
    
    func fetch() {
        _ = data.publisher
            .flatMap{ item -> AnyPublisher<String, Never> in
                if let item = item {
                    return Just(item)
                        .eraseToAnyPublisher()
                } else {
                     return Empty(completeImmediately: true)
                        .eraseToAnyPublisher()
                }
            }
            .sink{ [unowned self] item in
                dataToView.append(item)
            }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
