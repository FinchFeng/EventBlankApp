//
//  SpeakerDetailsModel.swift
//  EventBlank2-iOS
//
//  Created by Marin Todorov on 2/25/16.
//  Copyright © 2016 Underplot ltd. All rights reserved.
//

import UIKit
import RealmSwift

import RxSwift

class SpeakerDetailsModel {

    let speaker: Speaker
    let bag = DisposeBag()
    
    init(speaker: Speaker) {
        self.speaker = speaker
        
    }
}