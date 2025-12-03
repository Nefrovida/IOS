//
//  ForumView.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos on 2025.
//

import SwiftUI

struct ForumView: View {
    @StateObject private var vm: ForumViewModel
    let forumId: Int
    let rootMessageId: Int

    @FocusState private var isInputFocused: Bool

    init(forumId: Int, rootMessageId: Int) {
        let repo = ForumRemoteRepository(
            baseURL: AppConfig.apiBaseURL,
            tokenProvider: AppConfig.tokenProvider
        )
        
        _vm = StateObject(
            wrappedValue: ForumViewModel(
                replyToMessageUC: ReplyToMessageUseCase(repository: repo),
                getRepliesUC: GetRepliesUseCase(repository: repo)
            )
        )

        self.forumId = forumId
        self.rootMessageId = rootMessageId
    }

    var body: some View {
        VStack(spacing: 0) {
            UpBar()
            if let error = vm.errorMessage {
                ErrorMessage(
                    message: error,
                    onDismiss: {}
                )
            }

            // --- Replies list ---
            if vm.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if vm.errorMessage != nil {
                VStack(spacing: 8) {
                    Button("Reintentar") {
                        Task {
                            await vm.loadThread(forumId: forumId, rootId: rootMessageId)
                        }
                    }
                    .buttonStyle(.bordered)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            } else if vm.messages.isEmpty {
                Text("Aún no hay respuestas en este hilo")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture { isInputFocused = false }

            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 0) {
                            ForEach(vm.messages) { reply in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(reply.createdBy)
                                        .font(.caption)
                                        .foregroundColor(.secondary)

                                    Text(reply.content)
                                        .font(.body)
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .id(reply.id)

                                Divider()
                                    .padding(.leading)
                            }
                        }
                        .padding(.bottom, isInputFocused ? 80 : 0)
                    }
                    .onAppear {
                        guard let last = vm.messages.last else { return }
                        DispatchQueue.main.async {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                    .onChange(of: vm.messages.count) { _ in
                        guard let last = vm.messages.last else { return }
                        DispatchQueue.main.async {
                            withAnimation {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                    .simultaneousGesture(
                        TapGesture().onEnded { isInputFocused = false }
                    )
                }
            }
        }

        // --- INPUT BAR ---
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 6) {
                VStack(alignment: .trailing, spacing: 4) {
                    TextField(
                        "Escribe una respuesta...",
                        text: $vm.replyContent,
                        axis: .vertical
                    )
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(1...3)
                    .focused($isInputFocused)

                    Text("\(vm.replyContent.count)/700")
                        .font(.caption)
                        .foregroundColor(vm.characterCountColor)
                }

                HStack {
                    Spacer()
                    Button("Enviar") {
                        Task {
                            await vm.sendReply(forumId: forumId, rootId: rootMessageId)
                            await MainActor.run {
                                isInputFocused = false
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(
                        vm.replyContent
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .isEmpty
                        || vm.replyContent.count > 700
                        || vm.isLoading
                    )
                    .opacity(
                        vm.replyContent
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .isEmpty
                        || vm.replyContent.count > 700
                        || vm.isLoading ? 0.6 : 1
                    )
                }
            }
            .padding()
            .background(.ultraThinMaterial)
        }

        .task {
            await vm.loadThread(forumId: forumId, rootId: rootMessageId)
        }
        .navigationTitle("Respuestas")
        .navigationBarTitleDisplayMode(.inline)
    }
}
