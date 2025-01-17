browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.command === "getBlockStatus") {
    return browser.runtime.sendNativeMessage({ command: "getBlockStatus" })
  }

  if (request.command === "toggleBlock") {
    return browser.runtime
      .sendNativeMessage({ command: "toggleBlock" })
      .then((response) => {
        // Notify all tabs about the state change
        browser.tabs.query({}).then((tabs) => {
          tabs.forEach((tab) => {
            browser.tabs.sendMessage(tab.id, {
              command: "checkBlockStatus",
              isBlocked: response.isBlocked,
            })
          })
        })
        return response
      })
  }
})

// When extension starts, check all tabs
browser.runtime
  .sendNativeMessage({ command: "getBlockStatus" })
  .then((response) => {
    browser.tabs.query({}).then((tabs) => {
      tabs.forEach((tab) => {
        browser.tabs.sendMessage(tab.id, {
          command: "checkBlockStatus",
          isBlocked: response.isBlocked,
        })
      })
    })
  })
