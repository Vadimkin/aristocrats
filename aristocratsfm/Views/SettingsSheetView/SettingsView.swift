//
//  SettingsView.swift
//  aristocratsfm
//
//  Created by Vadim Klimenko on 11.11.2020.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("ArtworkEnabled") private var isArtworkEnabled = true

    init() {
        UIScrollView.appearance().bounces = true
    }

    @EnvironmentObject var iconSettings: IconNamesObservableObject

    // swiftlint:disable:next force_cast
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    // swiftlint:disable:next force_cast
    let bundleVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String

    func setIcon(selectedIconName: String) {
        let selectedIndex = self.iconSettings.iconNames.firstIndex(of: selectedIconName) ?? 0
        let index = self.iconSettings.iconNames.firstIndex(of: UIApplication.shared.alternateIconName) ?? 0

        if index != selectedIndex {
            UIApplication.shared.setAlternateIconName(self.iconSettings.iconNames[selectedIndex]) { error in
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
                image
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(UIColor(named: "BaseColor")!), lineWidth: 2))
                    .shadow(radius: 2)
            )
        }

        return image
    }

    var body: some View {
        let noFavoritesString = NSLocalizedString("artworks", comment: "Artworks")
        let iconString = NSLocalizedString("icon", comment: "Icon")
        let ideasString = NSLocalizedString("ideasProposals", comment: "For ideas and proposals")
        let telegramString = NSLocalizedString("telegram", comment: "Telegram")
        let versionString = NSLocalizedString("version", comment: "Version")
        let settingsString = NSLocalizedString("settings", comment: "Settings")

        let communityTitleString = NSLocalizedString("community", comment: "Title for community sections")
        let communityTitleChannelString = NSLocalizedString("communityChannel", comment: "Telegram Public Channel")
        let communityTitleChatString = NSLocalizedString("communityChat", comment: "Chat Radio (A)")

        return NavigationView {
            List {
                Section {
                    Toggle(isOn: $isArtworkEnabled) {
                        Text(noFavoritesString)
                    }

                    HStack {
                        Text(iconString)
                        Spacer()

                        ForEach(iconSettings.iconNames, id: \.self) { iconName in
                            if let iconName = iconName {
                                let isActiveIcon = iconSettings.currentName == iconName
                                self.getIconImage(uiImage: UIImage(named: iconName)!, isActive: isActiveIcon)
                                    .onTapGesture {
                                        setIcon(selectedIconName: iconName)
                                    }
                            } else {
                                let isActiveIcon = iconSettings.currentName == "AppIcon"
                                self.getIconImage(uiImage: UIImage.appIcon!, isActive: isActiveIcon)
                                    .onTapGesture {
                                        setIcon(selectedIconName: "AppIcon")
                                    }
                            }
                        }
                    }
                }

                Section(header: Text(communityTitleString)) {
                    HStack {
                        Text(communityTitleChannelString)
                        Spacer()
                        Image(systemName: "chevron.right").font(.body)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        TelegramURI(type: .publicChannel, id: Contacts.TelegramPublicID).open()
                    }
                    HStack {
                        Text(communityTitleChatString)
                        Spacer()
                        Image(systemName: "chevron.right").font(.body)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        TelegramURI(type: .chat, id: Contacts.TelegramChatID).open()
                    }
                }

                Section(header: Text("\(ideasString) ❤️")) {
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(Contacts.Email).foregroundColor(.gray)
                        Image(systemName: "chevron.right").font(.body)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if let url = URL(string: "mailto:\(Contacts.Email)") {
                            UIApplication.shared.open(url)
                        }
                    }
                    HStack {
                        Text(telegramString)
                        Spacer()
                        Text("@\(Contacts.Telegram)").foregroundColor(.gray)
                        Image(systemName: "chevron.right").font(.body)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        TelegramURI(type: .person, id: Contacts.Telegram).open()
                    }
                }

                SettingsRadioStreamPickerView()

                Section {
                    HStack {
                        Text(versionString)
                        Spacer()
                        Text("\(version) (\(bundleVersion))").font(.subheadline).foregroundColor(.gray)
                    }
                    .contentShape(Rectangle())
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(settingsString)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(IconNamesObservableObject())
    }
}
