browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    console.log("Received request: ", request);

    if (request.greeting === "hello")
        return Promise.resolve({ farewell: "goodbye" });

    if (request.command === 'toggleBlock') {
        // Forward the toggle request to Swift code
        browser.runtime.sendNativeMessage({ command: 'toggleBlock' })
          .then(response => {
            // Broadcast new status to all content scripts
            browser.tabs.query({}).then(tabs => {
              tabs.forEach(tab => {
                browser.tabs.sendMessage(tab.id, {
                  command: 'checkBlockStatus',
                  isBlocked: response.isBlocked
                })
              })
            })
          })
    }
    else if (request.command === 'getBlockStatus') {
        // Forward the status request to Swift code
        browser.runtime.sendNativeMessage({ command: 'getBlockStatus' })
          .then(response => {
            sendResponse(response)
          })
        return true // Required for async response
    }
});
