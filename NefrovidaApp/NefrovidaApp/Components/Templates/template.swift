//
//  template.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 28/10/25.
//

import SwiftUI

// MARK: - Base Page Template
struct BasePageTemplate<Content: View>: View {
  let title: String
  let content: Content
  var showBackButton: Bool = false
  var onBack: (() -> Void)? = nil

  init(title: String, showBackButton: Bool = false, onBack: (() -> Void)? = nil, @ViewBuilder content: () -> Content) {
    self.title = title
    self.showBackButton = showBackButton
    self.onBack = onBack
    self.content = content()
  }

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading, spacing: AppSpacing.xl) {
          content
        }
        .padding(AppSpacing.lg)
      }
      .navigationTitle(title)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        if showBackButton {
          ToolbarItem(placement: .cancellationAction) {
            Button("Cancelar") {
              onBack?()
            }
          }
        }
      }
    }
  }
}

// MARK: - List Page Template
struct ListPageTemplate<Content: View>: View {
  let title: String
  let content: Content
  var searchText: Binding<String>? = nil
  var searchPrompt: String = "Buscar"
  var onAppear: (() -> Void)? = nil

  init(title: String, searchText: Binding<String>? = nil, searchPrompt: String = "Buscar", onAppear: (() -> Void)? = nil, @ViewBuilder content: () -> Content) {
    self.title = title
    self.searchText = searchText
    self.searchPrompt = searchPrompt
    self.onAppear = onAppear
    self.content = content()
  }

  var body: some View {
    NavigationStack {
      Group {
        content
      }
      .navigationTitle(title)
      .toolbar {
        #if os(iOS)
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {} label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
          }
          .accessibilityLabel("Filtros")
        }
        #endif
      }
    }
    #if os(iOS)
    .searchable(text: searchText ?? .constant(""), placement: .navigationBarDrawer(displayMode: .always), prompt: searchPrompt)
    #endif
    .onAppear { onAppear?() }
  }
}

// MARK: - Modal Template
struct ModalTemplate<Content: View>: View {
  let title: String
  let content: Content
  @Environment(\.dismiss) private var dismiss
  var onCancel: (() -> Void)? = nil

  init(title: String, onCancel: (() -> Void)? = nil, @ViewBuilder content: () -> Content) {
    self.title = title
    self.onCancel = onCancel
    self.content = content()
  }

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading, spacing: AppSpacing.xl) {
          content
        }
        .padding(AppSpacing.lg)
      }
      .navigationTitle(title)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancelar") {
            onCancel?()
            dismiss()
          }
        }
      }
    }
  }
}
