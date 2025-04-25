import SwiftUI
import MapKit

struct MapLocationPickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: NewEventViewModel
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var searchText = ""
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var locationName = ""
    @State private var isSearching = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Text("Select Location")
                        .font(.system(size: 18, weight: .medium))
                    
                    Spacer()
                    
                    Button(action: {
                        if let selectedLocation = selectedLocation {
                            viewModel.setLocation(
                                name: locationName,
                                latitude: selectedLocation.latitude,
                                longitude: selectedLocation.longitude
                            )
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Done")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(selectedLocation != nil ? .white : .gray)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8)
                            .background(selectedLocation != nil ? Color.blue : Color.gray.opacity(0.3))
                            .cornerRadius(8)
                    }
                    .disabled(selectedLocation == nil)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(Color.white)
                
                SearchBar(text: $searchText, onSearch: searchLocation)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                ZStack {
                    Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: selectedLocation != nil ? [MapAnnotation(coordinate: selectedLocation!)] : []) { annotation in
                        MapMarker(coordinate: annotation.coordinate, tint: .red)
                    }
                    .gesture(
                        LongPressGesture(minimumDuration: 0.5)
                            .onEnded { _ in
                                let location = region.center
                                selectedLocation = location
                                getLocationName(for: location)
                            }
                    )
                    
                    if selectedLocation != nil {
                        VStack {
                            Spacer()
                            
                            HStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.system(size: 24))
                                
                                Text(locationName)
                                    .font(.system(size: 16, weight: .medium))
                                    .lineLimit(2)
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                            .padding()
                        }
                    }
                    
                    if isSearching {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(8)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private func searchLocation() {
        guard !searchText.isEmpty else { return }
        
        isSearching = true
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            isSearching = false
            
            guard let response = response, let item = response.mapItems.first else {
                return
            }
            
            let coordinate = item.placemark.coordinate
            selectedLocation = coordinate
            locationName = item.name ?? item.placemark.title ?? "Selected Location"
            
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
    }
    
    private func getLocationName(for coordinate: CLLocationCoordinate2D) {
        isSearching = true
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            isSearching = false
            
            guard let placemark = placemarks?.first else {
                locationName = "Unknown Location"
                return
            }
            
            let name = [placemark.name, placemark.thoroughfare, placemark.subThoroughfare, placemark.locality, placemark.subLocality]
                .compactMap { $0 }
                .filter { !$0.isEmpty }
                .joined(separator: ", ")
            
            locationName = name.isEmpty ? "Unknown Location" : name
        }
    }
}


struct SearchBar: View {
    @Binding var text: String
    var onSearch: () -> Void
    
    var body: some View {
        HStack {
            TextField("Search location", text: $text)
                .padding(8)
                .padding(.horizontal, 24)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !text.isEmpty {
                            Button(action: {
                                text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .onSubmit {
                    onSearch()
                }
            
            Button(action: {
                onSearch()
            }) {
                Text("Search")
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
    }
}
