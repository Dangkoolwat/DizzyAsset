import SwiftUI

struct AssetDetailView: View {
    let selectedIds: Set<Int64>
    @StateObject private var previewViewModel = PreviewViewModel()
    @StateObject private var hubViewModel = AssetInformationHubViewModel()
    @StateObject private var batchViewModel = BatchEditViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            if selectedIds.isEmpty {
                emptyState
            } else if selectedIds.count == 1 {
                content(for: selectedIds.first!)
            } else {
                batchEditView
            }
        }
        .navigationTitle(selectedIds.count > 1 ? "Batch Edit (\(selectedIds.count))" : "Details")
        .frame(minWidth: 300)
        .onChange(of: selectedIds) { newIds in
            if newIds.count == 1, let id = newIds.first {
                previewViewModel.loadPreview(for: id)
                hubViewModel.loadAssetDetails(for: id)
            } else if newIds.count > 1 {
                previewViewModel.previewService.stop()
                batchViewModel.setup(ids: newIds)
            } else {
                previewViewModel.previewService.stop()
            }
        }
    }
    
    private func content(for id: Int64) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Preview Section
                PreviewView(viewModel: previewViewModel)
                    .frame(height: 250)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .padding(.bottom, 10)
                
                // Status Section
                HStack {
                    statusSection
                    Spacer()
                    Button(action: { hubViewModel.analyzeAsset() }) {
                        if hubViewModel.isAnalyzing {
                            ProgressView().controlSize(.small)
                        } else {
                            Label("Smart Analyze", systemImage: "sparkles")
                        }
                    }
                    .buttonStyle(.bordered)
                    .disabled(hubViewModel.isAnalyzing)
                }
                
                Divider()
                
                // Metadata Section
                AssetInfoSection(title: "Technical Metadata", details: hubViewModel.technicalMetadata)
                
                Divider()
                
                // Category Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Category")
                        .font(.system(.headline, design: .rounded))
                    Text(hubViewModel.categoryName)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.primary)
                }
                
                if let silence = hubViewModel.silenceInfo {
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Silence Analysis")
                            .font(.system(.headline, design: .rounded))
                        Text(silence)
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
                
                if let derivation = hubViewModel.derivationInfo {
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Lineage")
                            .font(.system(.headline, design: .rounded))
                        Text(derivation)
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
                
                Divider()
                
                // Tags Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Tags")
                        .font(.system(.headline, design: .rounded))
                    
                    if hubViewModel.tags.isEmpty {
                        Text("No tags assigned")
                            .font(.system(.caption, design: .rounded))
                            .italic()
                            .foregroundColor(.secondary)
                    } else {
                        FlowLayout(spacing: 6) {
                            ForEach(hubViewModel.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.system(size: 10, weight: .bold, design: .rounded))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.accentColor.opacity(0.12))
                                    .foregroundColor(.accentColor)
                                    .cornerRadius(6)
                            }
                        }
                    }
                }
                
                if !hubViewModel.suggestedTags.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("AI Suggestions")
                                .font(.system(.headline, design: .rounded))
                                .foregroundColor(.purple)
                            Spacer()
                            Image(systemName: "sparkles")
                                .foregroundColor(.purple)
                        }
                        
                        FlowLayout(spacing: 8) {
                            ForEach(hubViewModel.suggestedTags, id: \.self) { tag in
                                HStack(spacing: 4) {
                                    Text(tag)
                                    Button(action: { hubViewModel.acceptSuggestion(tag) }) {
                                        Image(systemName: "plus.circle.fill")
                                    }
                                    .buttonStyle(.plain)
                                    .foregroundColor(.green)
                                    
                                    Button(action: { hubViewModel.rejectSuggestion(tag) }) {
                                        Image(systemName: "xmark.circle")
                                    }
                                    .buttonStyle(.plain)
                                    .foregroundColor(.secondary)
                                }
                                .font(.system(size: 10, weight: .medium, design: .rounded))
                                .padding(.leading, 8)
                                .padding(.trailing, 4)
                                .padding(.vertical, 4)
                                .background(Color.purple.opacity(0.1))
                                .cornerRadius(6)
                            }
                        }
                    }
                    .padding(12)
                    .background(Color.purple.opacity(0.05))
                    .cornerRadius(10)
                }
            }
            .padding(20)
        }
        .background(.thinMaterial)
    }
    
    private var statusSection: some View {
        HStack(spacing: 16) {
            HStack(spacing: 4) {
                Label(hubViewModel.isOnline ? "Online" : "Offline", 
                      systemImage: hubViewModel.isOnline ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .foregroundColor(hubViewModel.isOnline ? .green : .red)
                
                if !hubViewModel.isOnline {
                    Text("(\(hubViewModel.locationStatus))")
                        .foregroundColor(.red)
                }
            }
            
            if hubViewModel.isDuplicate {
                Label("Duplicate", systemImage: "doc.on.doc.fill")
                    .foregroundColor(.orange)
            }
            
            Spacer()
        }
        .font(.caption)
        .padding(.horizontal, 4)
    }
    
    private var emptyState: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "info.circle.fill")
                .font(.system(size: 64))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Asset Selected")
                    .font(.system(.title3, design: .rounded))
                    .bold()
                Text("Select items to view details or perform batch edits.")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.thinMaterial)
    }
    
    private var batchEditView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(selectedIds.count) Assets Selected")
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.bold)
                    Text("Metadata changes will be applied to all selected items.")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                // Batch Tagging
                VStack(alignment: .leading, spacing: 16) {
                    Label("Batch Tagging", systemImage: "tag.fill")
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.purple)
                    
                    HStack {
                        TextField("New tag...", text: $batchViewModel.newTagName)
                            .textFieldStyle(.roundedBorder)
                        
                        Button("Add") {
                            batchViewModel.addTagToAll()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(batchViewModel.newTagName.isEmpty)
                    }
                }
                
                Divider()
                
                // Batch Category
                VStack(alignment: .leading, spacing: 16) {
                    Label("Batch Category", systemImage: "folder.fill")
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.blue)
                    
                    Picker("Category", selection: $batchViewModel.selectedCategoryId) {
                        Text("Select Category").tag(Int64?.none)
                        ForEach(batchViewModel.categories) { cat in
                            Text(cat.name).tag(Int64?.some(cat.id))
                        }
                    }
                    .pickerStyle(.menu)
                    
                    HStack(spacing: 12) {
                        Button(action: { batchViewModel.applyCategoryToAll() }) {
                            Label("Apply Category", systemImage: "folder.badge.plus")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .disabled(batchViewModel.selectedCategoryId == nil)
                        
                        Button(action: { batchViewModel.clearCategoriesFromAll() }) {
                            Label("Clear", systemImage: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                    }
                }
                
                Spacer()
            }
            .padding(24)
        }
        .background(.thinMaterial)
    }
}
