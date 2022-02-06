//
//  GoalSettingView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 06/02/2022.
//

import SwiftUI

struct GoalSettingView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Set your Goal")
                    .font(Fonts.TITLE_SEMIBOLD)
                Spacer(minLength: 35)
            }
            .padding(.top, SCREEN_SIZE.height * 0.2)
            .frame(width: SCREEN_SIZE.width * 0.86)
            HStack {
                Text("🐷🐷存钱就是blahblah")
                    .font(Fonts.BODY_CHINESE_NORMAL)
                Spacer(minLength: 26)
            }
            .padding(.top, SCREEN_SIZE.height * 0.13)
            .frame(width: SCREEN_SIZE.width * 0.86)
            Spacer()
        }
    }
}

struct GoalSettingView_Previews: PreviewProvider {
    static var previews: some View {
        GoalSettingView()
    }
}
