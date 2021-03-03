//
//  ContentView.swift
//  YoungSt
//
//  Created by tichenko.r on 22.12.2020.
//

import SwiftUI
import ComposableArchitecture

struct TranslateView: View {
	let store: Store<TranslateState, TranslateAction>
	
	var body: some View {
		ScrollView {
			TranslationView(store: store)
				.padding()
			TranslationResultView(store: store)
				.padding()
		}
	}
}

//struct ClearView: View {
//	let store: Store<TranslateState, TranslateAction>
//
//	var body: some View {
//		WithViewStore(self.store) {  viewStore in
//			Button.init("Clear", action: { viewStore.send(.clearButtonTapped) })
//				.font(.title)
//		}
//	}
//}
//
//struct WordListView: View {
//	let store: Store<TranslateState, TranslateAction>
//
//	var body: some View {
//		WithViewStore(self.store) { viewStore in
//			LazyVStack(spacing: 5) {
//				Section(header: Text("Vocabulary").font(.title).bold()) {
//					SectionView()
//					ForEach(viewStore.wordList) { word in
//						HStack {
//							Text("\(word.fromText)")
//								.frame(maxWidth: .infinity, maxHeight: .infinity)
//								.padding(.vertical, 2)
//								.border(Color.black, width: 1)
//							Text("\(word.toText)")
//								.frame(maxWidth: .infinity, maxHeight: .infinity)
//								.padding(.vertical, 2)
//								.border(Color.black, width: 1)
//						}
//					}
//				}
//			}
//		}
//	}
//}
//
//struct SectionView: View {
//	var body: some View {
//		HStack {
//			Text("English")
//				.bold()
//				.frame(maxWidth: .infinity, maxHeight: .infinity)
//				.padding(.vertical)
//				.border(Color.black, width: 2)
//
//			Text("Russian")
//				.bold()
//				.frame(maxWidth: .infinity, maxHeight: .infinity)
//				.padding(.vertical)
//				.border(Color.black, width: 2)
//		}
//	}
//}
//
//struct TranslateView: View {
//	let store: Store<TranslateState, TranslateAction>
//
//	var body: some View {
//		VStack {
//			VStack(alignment: .leading, spacing: 5) {
//				WithViewStore(store) { viewStore in
//					TitleView(text: viewStore.from.viewModelValue)
//
//					FromView(text: viewStore.binding(get: \.value, send: TranslateAction.inputTextChanged))
//						.frame(height: 200)
//				}
//			}
//			.padding()
//
//			WithViewStore(store.stateless) { viewStore in
//				Button("Switch", action: { viewStore.send(.switchButtonTapped) })
//					.padding()
//			}
//
//
//			VStack(alignment: .leading, spacing: 5) {
//				WithViewStore(self.store) { viewStore in
//					TitleView(text: viewStore.to.viewModelValue)
//					ToView(text: viewStore.translationResult ?? "")
//						.frame(height: 200)
//				}
//			}
//			.padding()
//
//			WithViewStore(self.store) { viewStore in
//				VStack {
//					Button("Translate", action: { viewStore.send(.translateButtonTapped) })
//					Button("Save", action: { viewStore.send(.addWordButtonTapped) })
//						.padding(.top)
//				}
//				.font(.title)
//				.padding()
//			}
//		}
//	}
//}
//
//struct FromView: View {
//	var text: Binding<String>
//
//	var body: some View {
//		ZStack {
//			RoundedRectangle(cornerRadius: 10)
//				.stroke()
//			TextEditor(text: text)
//				.padding()
//		}
//	}
//}
//
//struct ToView: View {
//	let text: String
//
//	var body: some View {
//		ZStack {
//			RoundedRectangle(cornerRadius: 10)
//				.stroke()
//			Text(text)
//				.padding()
//		}
//	}
//}
//
//struct TitleView: View {
//	var text: String
//
//	var body: some View {
//		Text(text)
//			.font(.largeTitle)
//	}
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TranslateView(store: .init(initialState: .init(), reducer: .empty, environment: ()))
    }
}
