//
//  SettingsView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 11.11.2020.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("ArtworkEnabled") private var isArtworkEnabled = true
    @EnvironmentObject var iconSettings : IconNamesObservableObject
    
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    
    func setIcon(selectedIconName: String) {
        let selectedIndex = self.iconSettings.iconNames.firstIndex(of: selectedIconName) ?? 0
        let index = self.iconSettings.iconNames.firstIndex(of: UIApplication.shared.alternateIconName) ?? 0
        
        if index != selectedIndex {
            UIApplication.shared.setAlternateIconName(self.iconSettings.iconNames[selectedIndex]){ error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    iconSettings.refreshCurrentIcon()
                }
            }
        }
    }
    
    func getIconImage(uiImage: UIImage, isActive: Bool) -> some View {
        var image = AnyView(
            Image(uiImage: uiImage)
                .resizable()
                .frame(width: 50, height: 50)
                
                .cornerRadius(10)
                .padding(4)
                
                .cornerRadius(10)
        )
        
        if isActive {
            image = AnyView(
                image.overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(UIColor(named: "BaseColor")!), lineWidth: 2))
                    .shadow(radius: 2)
            );
        }
        
        return image;
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Toggle(isOn: $isArtworkEnabled) {
                        Text("Обкладинки альбомів")
                    }
                    
                    HStack {
                        Text("Іконка")
                        Spacer()
                        
                        ForEach(0..<iconSettings.iconNames.count) {
                            if let iconName = self.iconSettings.iconNames[$0] {
                                self.getIconImage(uiImage: UIImage(named: iconName)!, isActive: iconSettings.currentIndex == $0)
                                    .onTapGesture{
                                        setIcon(selectedIconName: iconName)
                                    }
                            } else {
                                self.getIconImage(uiImage: UIImage.appIcon!, isActive: iconSettings.currentIndex == $0)
                                    .onTapGesture{
                                        setIcon(selectedIconName: "AppIcon")
                                    }
                            }
                        }
                    }
                    
                }
                
                Section(header: Text("Для ідей та пропозицій ❤️")) {
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(Contacts.Email).foregroundColor(.gray)
                    }
                    .onTapGesture {
                        if let url = URL(string: "mailto:\(Contacts.Email)") {
                            UIApplication.shared.open(url)
                        }
                    }
                    HStack {
                        Text("Телеграм")
                        Spacer()
                        Text("@\(Contacts.Telegram)").foregroundColor(.gray)
                    }
                    .onTapGesture {
                        if let url = URL(string: "tg://resolve?domain=\(Contacts.Telegram)") {
                            UIApplication.shared.open(url)
                        }
                    }
                }
                
                Section {
                    HStack {
                        Text("Версія")
                        Spacer()
                        Text(version).font(.subheadline).foregroundColor(.gray)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Налаштування")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(IconNamesObservableObject())
    }
}
