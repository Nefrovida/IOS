//
//  AppointmentDetailPage.swift
//  NefrovidaApp
//
//  Created by Iván FV on 06/11/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct AppointmentDetailPage: View {
    let appointment: Appointment
    @StateObject private var vm: UploadResultVM

    @State private var showImporter = false

    init(appointment: Appointment) {
        self.appointment = appointment
        _vm = StateObject(wrappedValue: UploadResultVM(appointment: appointment))
    }

    var body: some View {
        VStack(spacing: 24) {
            VStack {
                Image(systemName: "person.crop.circle").font(.largeTitle)
                Text(appointment.patientName).font(.title3)
                Text(appointment.analysisName).font(.subheadline)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Adjuntar archivo").font(.title3).bold()
                Button {
                    showImporter = true
                } label: {
                    HStack {
                        Text("Archivo seleccionado")
                        Spacer()
                        Text(vm.fileName)
                            .lineLimit(1)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
            }

            Button {
                Task { await vm.upload() }
            } label: {
                Text("Subir resultados")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue, in: Capsule())
                    .foregroundStyle(.white)
            }
            .disabled(vm.pickedData == nil || vm.uploading)

            Spacer()
        }
        .padding()
        .fileImporter(
            isPresented: $showImporter,
            allowedContentTypes: [UTType.pdf, UTType.png],
            allowsMultipleSelection: false
        ) { result in
            guard case .success(let urls) = result, let url = urls.first,
                  let data = try? Data(contentsOf: url) else { return }
            vm.pick(data: data, name: url.lastPathComponent)
        }
        .overlay { if vm.uploading { ProgressView().scaleEffect(1.4) } }
        .alert("Listo", isPresented: $vm.success) { } message: {
            Text("Resultados subidos y cita actualizada.")
        }
        .navigationTitle("Detalle de cita")
        .navigationBarTitleDisplayMode(.inline)
    }
}
