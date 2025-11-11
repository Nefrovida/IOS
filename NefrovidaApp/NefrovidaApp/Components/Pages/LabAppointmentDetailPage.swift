//
//  LabAppointmentDetailPage.swift
//  NefrovidaApp
//
//  Created by Iván FV on 06/11/25.
//
// Components/Pages/LabAppointmentDetailPage.swift

import SwiftUI
import UniformTypeIdentifiers

struct LabAppointmentDetailPage: View {
    let labappointment: LabAppointment
    @StateObject private var vm: UploadResultVM

    @State private var showImporter = false

    init(labappointment: LabAppointment) {
        self.labappointment = labappointment
        _vm = StateObject(wrappedValue: UploadResultVM(labappointment: labappointment))
    }

    var body: some View {
        VStack(spacing: 24) {
            VStack {
                Image(systemName: "person.crop.circle").font(.largeTitle)
                Text(labappointment.patientName).font(.title3)
                Text(labappointment.analysisName).font(.subheadline)
            }

            VStack(spacing: 8) {
                AvatarCircle()
                Text(labappointment.patientName).font(.title3).bold()
                Text(labappointment.analysisName).font(.subheadline).foregroundStyle(.secondary)
                Text(labappointment.date.formatted(date: .numeric, time: .omitted))
                    .font(.caption).foregroundStyle(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous).fill(NV.cardBG)
            )
            .nvShadow(NV.elevation(1))

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
