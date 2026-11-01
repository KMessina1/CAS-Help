/*-------------------------------------------------------------------------------------------------------------------------
     File: CASHelpTests.swift
   Author: Kevin Messina
  Created: 8/22/26
 Modified: 11/01/2026 11:56 AM EST
  Version: 2
   Source: CODEX: (GPT-5) 🤖AI Code a portion or all of this code.
 
©2026 Creative App Solutions, LLC. - All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------
NOTES:
-------------------------------------------------------------------------------------------------------------------------*/

import Testing
@testable import CASHelp

@Test func helpStepsRespectSubjectOrderAndID() {
    let items = [
        HelpItem(id: 3, section: "Body", sortOrder: 2, title: "A", subTitle: "Second", detail: "", notes: ""),
        HelpItem(id: 2, section: "Body", sortOrder: 1, title: "A", subTitle: "First", detail: "", notes: ""),
        HelpItem(id: 0, section: "Body", sortOrder: 1, title: "A", subTitle: "First tie", detail: "", notes: ""),
        HelpItem(id: 1, section: "Body", sortOrder: 0, title: "B", subTitle: "Other subject", detail: "", notes: "")
    ]
    #expect(HelpItem.ordered(items).map(\.id) == [0, 2, 3, 1])
    #expect(HelpItem.ordered([]).isEmpty)
}
