//
//  BookList.swift
//  CalibreSync2
//
//  Created by Sumanth Peddamatham on 11/24/19.
//  Copyright © 2019 Sumanth Peddamatham. All rights reserved.
//

import SwiftUI

struct BookList: View {
    let books = {
        try! dbQueue.read { db in
            return try Book.fetchAll(db)
        }
    }
    
    var body: some View {
        List(books(), id: \.id) { book in
            BooksRow(book: book)
        }
    }
}

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        BookList()
    }
}
