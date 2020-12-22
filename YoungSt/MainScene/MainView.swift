//
//  ContentView.swift
//  YoungSt
//
//  Created by tichenko.r on 22.12.2020.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
	let store: Store<TranslateState, TranslateAction>
	
    var body: some View {
		WithViewStore(self.store) { viewStore in
			VStack {
				VStack(alignment: .leading, spacing: 5) {
					WithViewStore(store) { viewStore in
						TitleView(text: viewStore.from.viewModelValue)
						
						FromView(text: viewStore.binding(get: \.value, send: TranslateAction.textChanged))
							.frame(height: 200)
					}
				}
				.padding()
				
				WithViewStore(store.stateless) { viewStore in
					Button("Switch", action: { viewStore.send(.switchButtonTapped) })
						.padding()
				}
				
				
				VStack(alignment: .leading, spacing: 5) {
					TitleView(text: viewStore.to.viewModelValue)
					ToView(text: viewStore.translationResult ?? "")
						.frame(height: 200)
				}
				.padding()
				
				Button("Translate", action: { viewStore.send(.translateButtonTapped) })
					.font(.title)
					.padding()
				
				Spacer()
			}
			.padding()
		}

    }
}

struct FromView: View {
	var text: Binding<String>
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 10)
				.stroke()
			TextEditor(text: text)
				.padding()
		}
	}
}

struct ToView: View {
	let text: String
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 10)
				.stroke()
			Text(text)
				.padding()
		}
	}
}

struct TitleView: View {
	var text: String
	
	var body: some View {
		Text(text)
			.font(.largeTitle)
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		MainView(store: .init(initialState: .init(), reducer: .empty, environment: ()))
    }
}
