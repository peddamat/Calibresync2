//
//  FilePickerPresentedView.swift
//  flysight-grapher
//  Reference: https://gist.github.com/richo/61f308f5e4ba1fe7eefb8035aaa7817a
//
//  Created by richö butts on 7/8/19.
//  Copyright © 2019 richö butts. All rights reserved.
//

import Foundation
import SwiftUI
import MobileCoreServices

struct FilePickerController: UIViewControllerRepresentable {
    var callback: (URL) -> ()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<FilePickerController>) {
        // Update the controller
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        print("Making the picker")
        let controller = UIDocumentPickerViewController(documentTypes: [kUTTypeFolder as String], in: .open)
        
        controller.delegate = context.coordinator
        print("Setup the delegate \(context.coordinator)")
        
        return controller
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: FilePickerController
        
        init(_ pickerController: FilePickerController) {
            self.parent = pickerController
            print("Setup a parent")
            print("Callback: \(parent.callback)")
        }
       
        public func documentPicker(_ picker: UIDocumentPickerViewController, didPickDocumentsAt: [URL]) {
            print("Selected a document: \(didPickDocumentsAt[0])")
            parent.callback(didPickDocumentsAt[0])
        }
        
        func documentPickerWasCancelled(_ picker: UIDocumentPickerViewController) {
            print("Document picker was thrown away :(")
        }
        
        deinit {
            print("Coordinator going away")
        }
    }
}

struct PickerView: View {
    var callback: (URL) -> ()

    var body: some View {
        FilePickerController(callback: callback)
    }
}

#if DEBUG
struct PickerView_Preview: PreviewProvider {
    static var previews: some View {
        func filePicked(_ url: URL) {
            print("Filename: \(url)")
        }
        return PickerView(callback: filePicked)
            .aspectRatio(3/2, contentMode: .fit)
    }
}
#endif
