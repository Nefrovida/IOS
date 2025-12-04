//
//  filterableCardList.swift
//  NefrovidaApp
//
//  Created by Iván FV on 11/11/25.
//
// Components/Organism/filterableCardList.swift

import Foundation
import SwiftUI

struct filterableCardList<Item, Content: View>: View where Item: Identifiable {
    let title: String
    let items: [Item]
    let searchableText: (Item) -> String
    let content: (Item) -> Content
    var onFilterTap: (() -> Void)? = nil

    @State private var searchShown = false
    @State private var query = ""
    @FocusState private var searchFocused: Bool

    private var filtered: [Item] {
        if !searchShown { return items }
        guard !query.isEmpty else { return items }
        return items.filter { searchableText($0).localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(.system(size: 26, weight: .heavy))
                    .foregroundStyle(Color.nvBrand)

                Spacer(minLength: 8)

                Button {
                    withAnimation {
                        searchShown.toggle()
                    }
                    if searchShown {
                        DispatchQueue.main.async {
                            searchFocused = true
                        }
                    } else {
                        query = ""
                        searchFocused = false
                    }
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                .buttonStyle(.plain)
                .padding(.trailing, 4)

                if let onFilterTap {
                    Button(action: onFilterTap) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)

            if searchShown {
                HStack(spacing: 8) {
                    TextField("Buscar…", text: $query)
                        .textFieldStyle(.roundedBorder)
                        .focused($searchFocused)
                        .submitLabel(.search)

                    if !query.isEmpty {
                        Button {
                            query = ""
                            searchFocused = true
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filtered) { item in
                        content(item)
                    }
                }
                .padding()
                .padding(.bottom, 24)
            }
        }
    }
}

// Previews de uso del organism

private struct ForumItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

private struct AnalysisItem: Identifiable {
    let id = UUID()
    let name: String
    let desc: String
}

#Preview("Con ForumCard") {
    let forums: [ForumItem] = [
        .init(title: "Foro 1", description: "Pacientes Nefrovida."),
        .init(title: "Foro de Nutrición", description: "Recetas y consejos."),
        .init(title: "Comunidad", description: "Anuncios generales.")
    ]

    return filterableCardList<ForumItem, ForumCardMolecule>(
        title: "Foros",
        items: forums,
        searchableText: { "\($0.title) \($0.description)" },
        content: { item in
            ForumCardMolecule(
                title: item.title,
                description: item.description,
                onTap: { print("Abrir \(item.title)") }
            )
        },
        onFilterTap: { print("Filtrar foros…") }
    )
    .padding(.top, 16)
}

#Preview("Con AnalysisTypeCard") {
    let analyses: [AnalysisItem] = [
        .init(name: "Biometría Hemática (BM)", desc: "Descripción corta del estudio."),
        .init(name: "QS", desc: "Química sanguínea de 35 elementos."),
        .init(name: "EGO", desc: "Examen general de orina.")
    ]

    filterableCardList(
        title: "Tipos de análisis",
        items: analyses,
        searchableText: { "\($0.name) \($0.desc)" },
        content: { a in
            AnalysisTypeCard(
                title: a.name,
                description: a.desc,
                costoComunidad: "$150",
                costoGeneral: "$250",
                onSettings: { print("Editar \(a.name)") }
            )
        },
        onFilterTap: { print("Filtrar análisis…") }
    )
    .padding(.top, 16)
}
