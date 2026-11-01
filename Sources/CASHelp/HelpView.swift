/*-------------------------------------------------------------------------------------------------------------------------
     File: HelpView.swift
   Author: Kevin Messina
  Created: 6/10/24
 Modified: 11/01/2026 11:54 AM EST
  Version: 6
   Source: CODEX: (GPT-5) 🤖AI Code a portion or all of this code.

©2026 Creative App Solutions, LLC. - All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------
NOTES:
-------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI
import UIKit
import GRDB
import CASExternalFoundations
import CASThemeSupport

private struct HelpTextSizePopover: View {
    let CT = CurrentTheme().getThemeFromUserStds()
    @Binding var textSize: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Text Size")
                .font(.headline)
                .foregroundStyle(CT.title)

            HStack {
                Text("A")
                    .font(.caption)

                Slider(value: $textSize, in: 12...32, step: 1)

                Text("A")
                    .font(.title3)
            }
            .foregroundStyle(CT.lightest)

            Text("\(Int(textSize)) pt")
                .font(.caption)
                .foregroundStyle(CT.fair)
        }
        .padding()
        .frame(width: 260)
    }
}

// MARK: - *** Extension ***
public struct HelpView: View {
    @Environment(\.dismiss) private var dismiss
    let CT = CurrentTheme().getThemeFromUserStds()
    private let dbQueue: DatabaseQueue?
    private let appVersion: String
    private let companyURL: String
    @AppStorage("app.settings.helpTextSize") private var storedTextSize: Double = 18.0

    // Records
    @State var helpItems:[HelpItem] = []
    @State var headerItems:[HelpItem] = []
    @State var bodyItems:[HelpItem] = []
    @State var footerItems:[HelpItem] = []
    @State var sections:[String] = []

    private enum ScrollDestination: Hashable { case header, subject(String), footer }
    @State private var scrollTarget: ScrollDestination = .header
    @State private var scrollRequest = 0
    @State private var loadError: String?
    @State private var hasLoaded = false
    @State private var textSize: CGFloat = 18.0
    @State private var isShowingPopover = false

    public init(
        dbQueue: DatabaseQueue? = nil,
        appVersion: String = "",
        companyURL: String = ""
    ) {
        self.dbQueue = dbQueue
        self.appVersion = appVersion
        self.companyURL = companyURL
    }

    func loadBasicData() -> Void {
        loadError = nil
        hasLoaded = false
        guard let dbQueue else {
            loadError = "A database queue must be supplied to display help."
            hasLoaded = true
            return
        }
        defer { hasLoaded = true }

        helpItems.removeAll()
        headerItems.removeAll()
        bodyItems.removeAll()
        footerItems.removeAll()
        sections.removeAll()

        do {
            try dbQueue.read { dbTable in
                helpItems = HelpItem.ordered(try HelpItem.fetchAll(dbTable))

                //filter sections
                headerItems = helpItems.filter({ $0.section == "Header" })
                bodyItems = helpItems.filter({ $0.section == "Body" })
                footerItems = helpItems.filter({ $0.section == "Footer" })

                //filter section titles
                for item in bodyItems {
                   if !sections.contains(item.title) {
                       sections.append(item.title)
                   }
                }
            }
        } catch {
            loadError = error.localizedDescription
            print("\(error)")
        }
    }

    var headerView: some View {
        VStack {
            ForEach(headerItems, id: \.id) { item in
                VStack {
                    Text(item.subTitle).font(.system(size: textSize, weight: .regular))

                        .foregroundStyle(CT.title)
                    Text(item.detail).font(.system(size: textSize + 10, weight: .semibold))
                        .foregroundStyle(CT.fair)
                    Text(item.notes).font(.system(size: textSize - 3, weight: .light)).italic()
                        .foregroundStyle(CT.medium)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            }
        }//End VStack
        .id(ScrollDestination.header)
        .font(.system(size: textSize))
    }

    var regularDivider: some View {
        HStack {
            Rectangle().fill(CT.accent)
                .frame(height: 1.5)
        }
        .frame(height: 25)
        .padding(.vertical,10)
        .padding(.horizontal,50)
    }

    var fancyDivider: some View {
        HStack {
            Rectangle().fill(CT.accent)
                .frame(height: 1.5)

            Image(systemName: "fleuron")
                .resizable()
                .imageScale(.small)
                .scaledToFit()
                .foregroundStyle(CT.fair)

            Rectangle().fill(CT.accent)
                .frame(height: 1.5)
        }
        .frame(height: 25)
        .padding(.vertical,10)
    }

    var bodyView: some View {
        VStack(alignment: .leading, spacing:0) {
            ForEach(sections, id: \.self) { sectionTitle in
                Section(header:
                    HStack {
                        Text(sectionTitle)
                        .font(.system(size: textSize + 10, weight: .medium))
                        .foregroundStyle(CT.title)
                        .id(ScrollDestination.subject(sectionTitle))
                        Spacer()
                    }
                ) {
                    let sectionItems = bodyItems.filter({ $0.title == sectionTitle  })

                    ForEach(sectionItems, id: \.id) { item in
                        VStack(alignment: .leading) {
                            Text(item.subTitle).font(.system(size: textSize + 7, weight: .regular))
                                .foregroundStyle(CT.light)
                            Text(item.detail).font(.system(size: textSize, weight: .regular))
                                .foregroundStyle(CT.lightest)
                            if !item.notes.isEmpty {
                                Text("Notes: ").font(.system(size: textSize - 3, weight: .medium))
                                    .foregroundStyle(CT.title)
                                    .padding(.top,8)
                                Text(item.notes).font(.system(size: textSize - 3, weight: .regular)).italic()
                                    .foregroundStyle(CT.fair)
                            }

                            if sectionItems.last?.id == item.id {
                                fancyDivider
                            }else{
                                regularDivider
                            }
                        }//End VStack
                    }//End ForEach
                }//End Section
            }//End ForEach
        }//End VStack
        .foregroundStyle(CT.lightest)
        .padding(.vertical,20)
    }

    var footerView: some View {
        VStack {
            ForEach(footerItems, id: \.id) { item in
                VStack(alignment: .leading, spacing:textSize) {
                    Text(item.subTitle)


                    Text(item.detail)

                    HStack {
                        Spacer()

                        Button("Visit our website") {
                            if let url = URL(string: companyURL) {
                                UIApplication.shared.open(url)
                            }
                        }
                        .foregroundStyle(.white)
                        .buttonStyle(.glass) // Applies the native iOS 26 glass framework
                        .glassEffect(
                            .clear
                                .tint(CT.isLight ? .indigo : .cyan) // Adapts tint dynamically
                                .interactive()                      // Restores rich iOS 26 hover/press scaling
                        )

                        Spacer()
                    }
                }
            }
        }//End VStack
        .id(ScrollDestination.footer)
        .font(.system(size: textSize, weight: .regular))
        .foregroundStyle(CT.lightest)
        .padding(.vertical,20)
    }

    public var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    CT.Colors.backgroundArr[0],
                    CT.Colors.backgroundArr[0],
                    .black
                ]),
                startPoint: .top,endPoint: .bottom
            )
            .ignoresSafeArea()

            //titleView
            VStack {
                if let loadError {
                    ContentUnavailableView {
                        Label("Unable to Load Help", systemImage: "exclamationmark.triangle")
                    } description: {
                        Text(loadError)
                    } actions: {
                        Button("Retry") { loadBasicData() }
                    }
                    .foregroundStyle(CT.fair)
                } else if !hasLoaded {
                    ProgressView("Loading Help...")
                        .tint(CT.fair)
                } else if helpItems.isEmpty {
                    ContentUnavailableView("No Help Available", systemImage: "questionmark.circle")
                        .foregroundStyle(CT.fair)
                } else {
                ScrollViewReader { SR in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing:textSize) {
                            headerView

                            bodyView

                            footerView
                                .padding(.top,-30)
                        }//End VStack
                        .padding(.horizontal,10)
                    }//End ScrollView
                    .onChange(of: scrollRequest) {
                        withAnimation {
                            SR.scrollTo(scrollTarget,anchor: .top)
                        }
                    }
                }//End Scrollview Reader
                }
            }//End ZStack
            .padding(.horizontal,10)
            .zIndex(1)
        }//End Body
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("App Help".uppercased())
                    .foregroundStyle(CT.lightest)
            }

            ToolbarItem(placement: .subtitle) {
                Text(appVersion.isEmpty ?"v--" :"v\(appVersion)")
                    .fontWeight(.light)
                    .italic()
                    .foregroundStyle(CT.lightest)
            }

            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(action: {
                    isShowingPopover = true
                }) {
                    Image(systemName: "textformat.size")
                        .foregroundStyle(CT.accent)
                }
                .popover(isPresented: $isShowingPopover) {
                    HelpTextSizePopover(textSize: $textSize)
                        .presentationCompactAdaptation(.popover) // Optional: Force popover on compact sizes
                }
                .onChange(of: textSize) {
                    storedTextSize = Double(textSize)
                }

                Menu {
                    Text("Jump To Subject")

                    Button {
                        scrollTarget = .header
                        scrollRequest += 1
                    } label: {
                        Label("Top", systemImage: "arrowshape.up.fill")
                    }

                    ForEach(sections, id: \.self) { section in
                        Button {
                            scrollTarget = .subject(section)
                            scrollRequest += 1
                        } label: {
                            Label("\( section )", systemImage: "arrow.turn.down.right")
                        }
                    }

                    Button {
                        scrollTarget = .footer
                        scrollRequest += 1
                    } label: {
                        Label("Bottom", systemImage: "arrowshape.down.fill")
                    }
                } label: {
                    Label("", systemImage: "line.3.horizontal")
                }//End Menu
            }
        }
        .onAppear {
            textSize = storedTextSize.isFinite ? CGFloat(min(max(storedTextSize, 12), 32)) : 18

            loadBasicData()
        }
    }

}

#Preview {
    HelpView()
}
