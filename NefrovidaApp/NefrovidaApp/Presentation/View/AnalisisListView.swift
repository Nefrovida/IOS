//  AnalisisListView.swift
//  NefrovidaApp
//
//  Created by Enrique Ayala on 08/11/25.
//
//  Main screen for secretary to manage medical analyses.

import SwiftUI

struct AnalisisListView: View {
    @StateObject private var viewModel: AnalisisViewModel = AnalisisListView.makeViewModel()
    @State private var selectedTab: Int = 1 // 0: Inicio, 1: Analisis, 2: Foros, 3: Agenda

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                header
                sectionTitle
                contentList
                actionButton
                tabBar
            }
            .onAppear { viewModel.onAnalisisScreenLoaded() }

            if viewModel.showDeleteConfirmation, let selected = viewModel.selectedAnalisis {
                DeleteConfirmationDialog(
                    titulo: selected.titulo,
                    onModify: { /* Future modify action */ },
                    onDelete: { viewModel.onConfirmarEliminacion(idAnalisis: selected.id) },
                    onClose: { viewModel.dismissDialogs() }
                )
                .transition(.opacity)
            }

            if viewModel.showSuccessMessage {
                SuccessMessageDialog(
                    message: NSLocalizedString("delete_success_message", comment: "Deletion success"),
                    onClose: { viewModel.dismissDialogs() }
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: viewModel.showDeleteConfirmation)
        .animation(.easeInOut, value: viewModel.showSuccessMessage)
    }

    // MARK: - Subviews

    private var header: some View {
        HStack {
            Image(systemName: "person.crop.circle")
                .font(.system(size: 24))
                .foregroundColor(ColorPalette.textPrimary)
                .accessibilityLabel(Text(NSLocalizedString("acc_profile", comment: "Profile")))
            Spacer()
            Text("NEFRO Vida")
                .font(.title2.weight(.bold))
                .foregroundColor(ColorPalette.textPrimary)
                .accessibilityAddTraits(.isHeader)
            Spacer()
            Image(systemName: "bell")
                .font(.system(size: 22))
                .foregroundColor(ColorPalette.textPrimary)
                .accessibilityLabel(Text(NSLocalizedString("acc_notifications", comment: "Notifications")))
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.04), radius: 3, x: 0, y: 2)
    }

    private var sectionTitle: some View {
        HStack(alignment: .center) {
            Text(NSLocalizedString("title_analisis", comment: "Analisis"))
                .font(.title2.weight(.bold))
                .foregroundColor(ColorPalette.textPrimary)
            Spacer()
            Button(action: { /* Search action */ }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(ColorPalette.textPrimary)
            }
            .accessibilityLabel(Text(NSLocalizedString("acc_search", comment: "Search")))
            Button(action: { /* Filter action */ }) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .foregroundColor(ColorPalette.textPrimary)
            }
            .accessibilityLabel(Text(NSLocalizedString("acc_filter", comment: "Filter")))
        }
        .padding(.horizontal, Spacing.md)
        .padding(.top, Spacing.sm)
    }

    private var contentList: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(ColorPalette.danger)
                    .padding(Spacing.md)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.analisis.isEmpty {
                Text(NSLocalizedString("empty_analisis", comment: "No analyses"))
                    .foregroundColor(ColorPalette.textSecondary)
                    .padding(Spacing.md)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: Spacing.sm) {
                        ForEach(viewModel.analisis) { item in
                            AnalisisCardView(item: item) {
                                viewModel.onEliminarAnalisisClicked(idAnalisis: item.id)
                            }
                            .padding(.horizontal, Spacing.md)
                        }
                        .padding(.top, Spacing.sm)
                    }
                }
            }
        }
    }

    private var actionButton: some View {
        Button(action: { /* Create analysis action */ }) {
            Text(NSLocalizedString("btn_create_analisis", comment: "Create Analysis"))
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.white) // better contrast on primary
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(ColorPalette.primary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, Spacing.md)
                .padding(.top, Spacing.md)
        }
        .accessibilityHint(Text(NSLocalizedString("acc_create_hint", comment: "Create new analysis")))
    }

    private var tabBar: some View {
        HStack {
            tabBarItem(index: 0, titleKey: "tab_home", systemIcon: "house")
            tabBarItem(index: 1, titleKey: "tab_analisis", systemIcon: "doc.text")
            tabBarItem(index: 2, titleKey: "tab_foros", systemIcon: "bubble.left.and.bubble.right")
            tabBarItem(index: 3, titleKey: "tab_agenda", systemIcon: "calendar")
        }
        .padding(.vertical, 8)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.06), radius: 5, x: 0, y: -2)
    }

    private func tabBarItem(index: Int, titleKey: String, systemIcon: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: systemIcon)
                .font(.system(size: 18, weight: .semibold))
            Text(NSLocalizedString(titleKey, comment: "Tab label"))
                .font(.caption)
        }
        .foregroundColor(selectedTab == index ? ColorPalette.textPrimary : ColorPalette.textSecondary)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture { selectedTab = index }
        .accessibilityLabel(Text(NSLocalizedString(titleKey, comment: "Tab label")))
    }
}

// MARK: - DI Helper
extension AnalisisListView {
    static func makeViewModel() -> AnalisisViewModel {
        #if DEBUG
        let service = AnalisisMockService()
        return AnalisisViewModel(
            obtenerAnalisisUseCase: ObtenerAnalisisUseCase(service: service),
            eliminarAnalisisUseCase: EliminarAnalisisUseCase(service: service)
        )
        #else
        return AnalisisViewModel.live()
        #endif
    }
}

#Preview {
    AnalisisListView()
}
