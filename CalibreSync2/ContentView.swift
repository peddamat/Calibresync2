//
//  ContentView.swift
//  CalibreSync2
//
//  Created by Sumanth Peddamatham on 11/24/19.
//  Copyright © 2019 Sumanth Peddamatham. All rights reserved.
//

import SwiftUI

let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

struct ContentView: View {
    @State private var showSettings = false
    @ObservedObject var settings = UserSettings()
    
    var profileButton: some View {
        Button(action: { self.showSettings.toggle() }) {
            Image(systemName: "person.crop.circle")
                .imageScale(.large)
                .accessibility(label: Text("User Profile"))
                .padding()
        }
    }

    var body: some View {
        NavigationView {
            CategoryHome()
                .navigationBarTitle("CalibreSync")
                .navigationBarItems(trailing: profileButton)
                .sheet(isPresented: $showSettings) {
                    SettingsView()
            }
        }
    }
//    var body: some View {
//        NavigationView {
//            TabView {
//                CategoryHome()
//                    .tabItem {
//                        Image(systemName: "star.fill")
//                        Text("Home")
//                    }
//                Text("Library")
//                    .tabItem {
//                        Image(systemName: "book.circle")
//                        Text("Library")
//                    }
//            }
//            .navigationBarTitle("CalibreSync")
//            .navigationBarItems(trailing: profileButton)
//                .sheet(isPresented: $showSettings) {
//                    SettingsView()
//            }
//        }
//    }
}

struct SettingsView: View {
    @State private var show_modal: Bool = false
    @State var bookmarkData: Data?
    
    func pickerCallback(_ url: URL) {
        print(url.path)
        saveBookmark(url: url)
    }
    
    func saveBookmark(url: URL) {
        do {
            let shouldStopAccessing = url.startAccessingSecurityScopedResource()
            defer { if shouldStopAccessing { url.stopAccessingSecurityScopedResource() } }
            
            let fuck = try url.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil)
            
            bookmarkData = fuck
        } catch let error {
            
        }
    }
    
    func fetchBooks() {
        do {
            try dbQueue.read { db in
                let books = try Book.fetchAll(db)
                
                for book in books {
                    print(book.title)
                }
            }
        } catch { }
    }
    
    func getFileSize(filePath: URL) {
        //        var filePath = readBookmark(url: bookmarkData!)
        var fileSize : UInt64
        
        print(filePath)
        
        do {
            let shouldStopAccessing = filePath.startAccessingSecurityScopedResource()
            defer { if shouldStopAccessing { filePath.stopAccessingSecurityScopedResource() } }
            
            //return [FileAttributeKey : Any]
            let attr = try FileManager.default.attributesOfItem(atPath: filePath.path)
            fileSize = attr[FileAttributeKey.size] as! UInt64
            
            //if you convert to NSDictionary, you can get file size old way as well.
            let dict = attr as NSDictionary
            fileSize = dict.fileSize()
            
            print(fileSize)
        } catch {
            print("Error: \(error)")
        }
    }
    
    func readBookmark(url: Data) -> URL {
        var urlResult = false
        
        let folderURL = try! URL(resolvingBookmarkData: url, options: [], relativeTo: nil, bookmarkDataIsStale: &urlResult)
        return folderURL
    }
    
    func readDirectory() {
        let error: NSErrorPointer = nil
        let filePath = readBookmark(url: bookmarkData!).path
        //        let filePath = readBookmark(url: bookmarkData!).deletingLastPathComponent().path
        let pickedFolderURL = URL(fileURLWithPath: filePath)
        let shouldStopAccessing = pickedFolderURL.startAccessingSecurityScopedResource()
        defer { if shouldStopAccessing { pickedFolderURL.stopAccessingSecurityScopedResource() }}
        
        NSFileCoordinator().coordinate(readingItemAt: pickedFolderURL, error: error) { (folderURL) in
            do {
                print("hi.")
                print(folderURL.path)
                let keys : [URLResourceKey] = [.nameKey, .isDirectoryKey]
                let fileList = try FileManager.default.enumerator(at: folderURL, includingPropertiesForKeys: keys)
                for file  in fileList! {
                    //                    let h: URL = file
                    //                    print(file)
                    getFileSize(filePath: file as! URL)
                }
                //                for case let file as URL in fileList! {
                //                    print(".")
                //                }
            } catch let error {
                print("fucked")
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            List {
                Button(action: {
                    self.show_modal = true
                }) {
                    Text("Select file")
                }.sheet(isPresented: self.$show_modal) {
                    PickerView(callback: self.pickerCallback)
                }

                Button(action: {
                    self.fetchBooks()
                }) {
                    Text("Fetch books")
                }

                Button(action: {
    //                self.getFileSize()
                }) {
                    Text("Get file size")
                }

                Button(action: {
                    self.readDirectory()
                }) {
                    Text("Read directory")
                }
            }
        }
    }
}

struct CircleButton: View {

   var icon = "person.crop.circle"

   var body: some View {
      return HStack {
         Image(systemName: icon)
            .foregroundColor(.primary)
      }
      .frame(width: 44, height: 44)
      .background(Color("button"))
      .cornerRadius(30)
      .shadow(color: Color("buttonShadow"), radius: 20, x: 0, y: 20)
   }
}

struct MenuButton: View {
   @Binding var show: Bool

   var body: some View {
      return ZStack(alignment: .topLeading) {
         Button(action: { self.show.toggle() }) {
            HStack {
               Spacer()

               Image(systemName: "list.dash")
                  .foregroundColor(.primary)
            }
            .padding(.trailing, 18)
            .frame(width: 90, height: 60)
            .background(Color("button"))
            .cornerRadius(30)
            .shadow(color: Color("buttonShadow"), radius: 20, x: 0, y: 20)
         }
         Spacer()
      }
   }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
