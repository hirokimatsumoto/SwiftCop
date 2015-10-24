//
//  SwiftCopTests.swift
//  SwiftCopTests
//
//  Created by Andres on 10/16/15.
//  Copyright © 2015 Andres Canal. All rights reserved.
//

import XCTest
@testable import SwiftCop

class SwiftCopTests: XCTestCase {
	var nameTextField: UITextField!

    override func setUp() {
        super.setUp()

		self.nameTextField = UITextField()
		self.nameTextField.text = "Billy Joel"
    }

    override func tearDown() {
        super.tearDown()
    }

    func testCustomTrialNoGuilties() {
		let swiftCop = SwiftCop()
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "More than five characters") {
			return $0.characters.count >= 5
		})

		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Two words") {
			return $0.componentsSeparatedByString(" ").count >= 2
		})

		XCTAssert(!swiftCop.anyGuilty())
    }
	
	func testCustomTrialGuilties() {
		let swiftCop = SwiftCop()
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Two characters") {
			return $0.characters.count == 2
		})

		XCTAssert(swiftCop.anyGuilty())
	}
	
	func testCustomTrialAllGuilties() {
		let swiftCop = SwiftCop()
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "More than five characters") {
			return $0.characters.count >= 5
			})
		
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Two words") {
			return $0.componentsSeparatedByString(" ").count >= 2
			})
		
		let guilties = swiftCop.allGuilties()
		XCTAssert(guilties.count == 0)
	}
	
	func testCustomTrialAllGuiltiesOneFail() {
		let swiftCop = SwiftCop()
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "More than five characters") {
			return $0.characters.count >= 5
			})
		
		swiftCop.addSuspect(Suspect(view: self.nameTextField, sentence: "Three words") {
			return $0.componentsSeparatedByString(" ").count >= 3
			})
		
		let guilties = swiftCop.allGuilties()
		XCTAssert(guilties.count == 1)
		XCTAssertEqual(guilties.first!.view, self.nameTextField)
		XCTAssertEqual(guilties.first!.sentence, "Three words")
	}
}
