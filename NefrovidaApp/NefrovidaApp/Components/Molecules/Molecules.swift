//
//  Molecules.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 28/10/25.
//

import SwiftUI

// MARK: - Avatar Molecule
struct AvatarView: View {
  let urlString: String?
  let name: String
  var size: CGFloat = 56

  private var initials: String {
    let comps = name.split(separator: " ")
    let first = comps.first?.first.map(String.init) ?? "?"
    let last = comps.dropFirst().first?.first.map(String.init) ?? ""
    return (first + last).uppercased()
  }

  var body: some View {
    ZStack {
      Circle().fill(Theme.turquoiseLight)
      if let urlString, let url = URL(string: urlString) {
        AsyncImage(url: url) { phase in
          switch phase {
          case .empty:
            ProgressView()
          case .success(let image):
            image.resizable().scaledToFill()
          case .failure:
            Text(initials).font(.headline).foregroundColor(Theme.blueDark)
          @unknown default:
            Text(initials).font(.headline).foregroundColor(Theme.blueDark)
          }
        }
        .clipShape(Circle())
      } else {
        Text(initials).font(.headline).foregroundColor(Theme.blueDark)
      }
    }
    .frame(width: size, height: size)
    .accessibilityLabel("Avatar de \(name)")
  }
}

// MARK: - Primary Button Molecule
struct PrimaryButton: View {
  let title: String
  let action: () -> Void
  var isEnabled: Bool = true
  var accessibilityLabel: String?

  var body: some View {
    Button(action: action) {
      Text(title)
        .font(.headline)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.md)
        .padding(.horizontal, AppSpacing.lg)
        .background(isEnabled ? Theme.turquoisePrimary : Color.gray)
        .cornerRadius(AppCornerRadius.md)
    }
    .disabled(!isEnabled)
    .accessibilityLabel(accessibilityLabel ?? title)
  }
}

// MARK: - Secondary Button Molecule
struct SecondaryButton: View {
  let title: String
  let action: () -> Void
  var accessibilityLabel: String?

  var body: some View {
    Button(action: action) {
      Text(title)
        .font(.headline)
        .foregroundColor(Theme.turquoisePrimary)
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.md)
        .padding(.horizontal, AppSpacing.lg)
        .background(Theme.turquoiseLight.opacity(0.3))
        .cornerRadius(AppCornerRadius.md)
        .overlay(
          RoundedRectangle(cornerRadius: AppCornerRadius.md)
            .stroke(Theme.turquoisePrimary, lineWidth: 1)
        )
    }
    .accessibilityLabel(accessibilityLabel ?? title)
  }
}

// MARK: - Capsule Button Molecule
struct CapsuleButton: View {
  let title: String
  let action: () -> Void
  var isSelected: Bool = false
  var accessibilityLabel: String?

  var body: some View {
    Button(action: action) {
      Text(title)
        .font(.subheadline)
        .foregroundColor(isSelected ? .white : Theme.blueDark)
        .padding(.vertical, AppSpacing.sm)
        .padding(.horizontal, AppSpacing.md)
        .frame(maxWidth: .infinity)
        .background(isSelected ? Theme.blueDark : Theme.turquoiseLight)
        .clipShape(Capsule())
    }
    .accessibilityLabel(accessibilityLabel ?? title)
  }
}
