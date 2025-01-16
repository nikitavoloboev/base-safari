let isBlocked = true // Start with blocking enabled

browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.command === "getBlockStatus") {
    return Promise.resolve({ isBlocked })
  }

  if (request.command === "toggleBlock") {
    isBlocked = !isBlocked
    // Notify all tabs about the state change
    browser.tabs.query({}).then((tabs) => {
      tabs.forEach((tab) => {
        browser.tabs.sendMessage(tab.id, {
          command: "checkBlockStatus",
          isBlocked,
        })
      })
    })
    return Promise.resolve({ isBlocked })
  }
})

// When extension starts, check all tabs
browser.tabs.query({}).then((tabs) => {
  tabs.forEach((tab) => {
    browser.tabs.sendMessage(tab.id, {
      command: "checkBlockStatus",
      isBlocked: true,
    })
  })
})
