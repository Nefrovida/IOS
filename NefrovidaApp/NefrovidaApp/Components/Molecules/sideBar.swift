//
//  sideBar.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 03/12/25.
//

import SwiftUI

struct Sidebar<Content: View>: View {
    @Binding var isOpen: Bool
    let width: CGFloat
    let content: Content
    let userName: String?
    let onLogout: (() -> Void)?
    
    init(
        isOpen: Binding<Bool>,
        width: CGFloat = 280,
        userName: String? = nil,
        onLogout: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self._isOpen = isOpen
        self.width = width
        self.content = content()
        self.userName = userName
        self.onLogout = onLogout
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                if isOpen {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                isOpen = false
                            }
                        }
                        .transition(.opacity)
                        .zIndex(0)
                }
                Spacer()
                VStack(spacing: 0) {
                    Spacer()
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("NefrovidaApp")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                            
                            Text("Menú Principal")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.top, 60)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                    
                    Divider()
                        .padding(.horizontal, 20)
                    
                    ScrollView(showsIndicators: false) {
                        content
                            .padding(.top, 16)
                    }
                    
                    Spacer()
                    
                    if userName != nil {
                        Divider()
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 8) {
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .font(.title3)
                                    .foregroundStyle(.blue)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(userName ?? "Usuario")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .lineLimit(1)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.secondary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal, 16)
                        }
                        .padding(.vertical, 16)
                    }
                    
                    if onLogout != nil {
                        Divider()
                            .padding(.horizontal, 20)
                        
                        Button(action: {
                            withAnimation {
                                isOpen = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                onLogout?()
                            }
                        }) {
                            HStack(spacing: 16) {
                                Image(systemName: "arrow.backward.square.fill")
                                    .font(.title3)
                                    .foregroundStyle(.red)
                                    .frame(width: 28)
                                
                                Text("Cerrar sesión")
                                    .font(.body)
                                    .foregroundStyle(.red)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            .background(Color.red.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal, 16)
                        }
                        .buttonStyle(.plain)
                        .padding(.vertical, 12)
                        .padding(.bottom, 30)
                    }
                }
                .frame(width: width)
                .frame(maxHeight: .infinity)
                .background {
                    LinearGradient(
                        colors: [
                            Color(.systemBackground),
                            Color(.systemBackground).opacity(0.95)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .overlay(alignment: .trailing) {
                    Rectangle()
                        .fill(LinearGradient(
                            colors: [.blue.opacity(0.3), .purple.opacity(0.2)],
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .frame(width: 3)
                }
                .clipShape(RoundedRectangle(cornerRadius: 0))
                .shadow(color: .black.opacity(0.2), radius: 10, x: 2, y: 0)
                .offset(x: isOpen ? 0 : -width)
                .ignoresSafeArea()
                .zIndex(1)
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isOpen)
        }
        .allowsHitTesting(isOpen)
    }
}
