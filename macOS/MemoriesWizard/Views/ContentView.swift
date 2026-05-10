import SwiftUI

struct ContentView: View {
    @State private var sourceURL: URL?
    @State private var destinationURL: URL?
    @State private var mediaFiles: [URL] = []
    @State private var currentIndex = 0
    @State private var isSorting = false
    @State private var offset = CGSize.zero
    @State private var indicatorText = ""
    @State private var indicatorColor = Color.white
    @State private var scanSubfolders = true
    @State private var jumpIndexText = ""
    
    private let mediaService = MediaService()
    
    var body: some View {
        ZStack {
            // Background Layer
            LinearGradient(gradient: Gradient(colors: [Color(nsColor: .windowBackgroundColor), Color("SageGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            if !isSorting {
                setupView
            } else if currentIndex < mediaFiles.count {
                sortingView
            } else {
                successView
            }
        }
        .frame(minWidth: 800, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity)
    }
    
    // MARK: - Setup View
    var setupView: some View {
        VStack(spacing: 30) {
            Text("Memories Wizard")
                .font(.custom("Georgia", size: 40))
                .fontWeight(.bold)
                .foregroundStyle(Color("DeepForest"))
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Source Library").font(.headline).opacity(0.6)
                VStack(alignment: .leading) {
                    HStack {
                        Text(sourceURL?.path ?? "No folder selected")
                        Spacer()
                        Button("Browse") { selectFolder(isSource: true) }
                    }
                    Toggle("Scan Subfolders", isOn: $scanSubfolders)
                        .padding(.top, 5)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
            }
            .frame(maxWidth: 500)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Destination Collection").font(.headline).opacity(0.6)
                HStack {
                    Text(destinationURL?.path ?? "No folder selected")
                    Spacer()
                    Button("Browse") { selectFolder(isSource: false) }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
            }
            .frame(maxWidth: 500)
            
            Button("Begin Journey") {
                startSorting()
            }
            .buttonStyle(.borderedProminent)
            .tint(Color("DeepForest"))
            .disabled(sourceURL == nil || destinationURL == nil)
        }
    }
    
    // MARK: - Sorting View
    var sortingView: some View {
        VStack {
            ZStack {
                CardView(url: mediaFiles[currentIndex])
                    .offset(offset)
                    .rotationEffect(.degrees(Double(offset.width / 20)))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset = gesture.translation
                                updateIndicator(offset: offset)
                            }
                            .onEnded { _ in
                                finalizeSwipe()
                            }
                    )
                
                if !indicatorText.isEmpty {
                    Text(indicatorText)
                        .font(.system(size: 80, weight: .black))
                        .foregroundColor(indicatorColor)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                }
            }
            .padding(40)
            
            HStack(alignment: .center) {
                Text(mediaFiles[currentIndex].lastPathComponent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button("Complete Now") {
                    withAnimation { currentIndex = mediaFiles.count }
                }
                .buttonStyle(.bordered)
                
                HStack(spacing: 5) {
                    TextField("", text: $jumpIndexText, onCommit: {
                        jumpToIndex()
                    })
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.center)
                    .frame(width: 50)
                    .onAppear { jumpIndexText = "\(currentIndex + 1)" }
                    .onChange(of: currentIndex) { newValue in jumpIndexText = "\(newValue + 1)" }
                    
                    Text("/ \(mediaFiles.count)")
                        .opacity(0.6)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
        }
    }
    
    func jumpToIndex() {
        if let newIndex = Int(jumpIndexText), newIndex >= 1 && newIndex <= mediaFiles.count {
            withAnimation {
                currentIndex = newIndex - 1
                offset = .zero
                indicatorText = ""
            }
        } else {
            jumpIndexText = "\(currentIndex + 1)"
        }
    }
    
    // MARK: - Success View
    var successView: some View {
        VStack(spacing: 20) {
            Text("Journey Organized").font(.custom("Georgia", size: 32)).bold()
            Text("All memories are in their place.").opacity(0.7)
            
            HStack(spacing: 20) {
                Button("Restart") { isSorting = false; currentIndex = 0 }
                Button("View Destination") { openDestination() }
            }
        }
    }
    
    // MARK: - Logic
    func selectFolder(isSource: Bool) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        if panel.runModal() == .OK {
            if isSource {
                sourceURL = panel.url
            } else {
                destinationURL = panel.url
            }
        }
    }
    
    func startSorting() {
        guard let source = sourceURL else { return }
        mediaFiles = mediaService.getMediaFiles(from: source, recursive: scanSubfolders)
        if !mediaFiles.isEmpty {
            isSorting = true
        }
    }
    
    func updateIndicator(offset: CGSize) {
        if abs(offset.width) > abs(offset.height) {
            if offset.width > 100 {
                indicatorText = "KEEP"
                indicatorColor = .green
            } else if offset.width < -100 {
                indicatorText = "SKIP"
                indicatorColor = .gray
            } else {
                indicatorText = ""
            }
        } else {
            if offset.height > 100 {
                indicatorText = "TRASH"
                indicatorColor = .red
            } else {
                indicatorText = ""
            }
        }
    }
    
    func finalizeSwipe() {
        if offset.width > 150 {
            withAnimation(.easeIn(duration: 0.3)) { offset.width = 1000 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { processDecision(.keep) }
        } else if offset.width < -150 {
            withAnimation(.easeIn(duration: 0.3)) { offset.width = -1000 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { processDecision(.skip) }
        } else if offset.height > 150 {
            withAnimation(.easeIn(duration: 0.3)) { offset.height = 1000 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { processDecision(.trash) }
        } else {
            withAnimation(.spring()) {
                offset = .zero
                indicatorText = ""
            }
        }
    }
    
    enum Decision { case keep, skip, trash }
    
    func processDecision(_ decision: Decision) {
        let file = mediaFiles[currentIndex]
        do {
            switch decision {
            case .keep:
                try mediaService.moveToDestination(file: file, to: destinationURL!)
            case .trash:
                try mediaService.sendToTrash(file: file)
            case .skip:
                break
            }
        } catch {
            print("Error: \(error)")
        }
        
        currentIndex += 1
        offset = .zero
        indicatorText = ""
    }
    
    func openDestination() {
        if let url = destinationURL {
            NSWorkspace.shared.open(url)
        }
    }
}
