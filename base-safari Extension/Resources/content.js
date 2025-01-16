const urls = [
  "https://news.ycombinator.com",
  "https://hckrnews.com",
  "https://reddit.com",
  "https://lobste.rs",
  "https://youtube.com",
  "https://github.com/dashboard-feed",
].map(
  (url) =>
    url
      .replace(/\/$/, "") // Remove trailing slash if present
      .replace(/^https?:\/\/(www\.)?/, "https://") // Normalize protocol and remove www if present
)

const currentUrl = window.location.href
  .replace(/\/$/, "") // Remove trailing slash if present
  .replace(/^https?:\/\/(www\.)?/, "https://") // Normalize protocol and remove www if present

function hideBodyAndAddText() {
  const style = document.createElement("style")
  style.innerHTML = `
      html {
        background-color: black !important;
      }
      body {
        display: none;
      }
    `
  document.head.appendChild(style)
}

if (urls.includes(currentUrl)) {
  browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    if (request.command === 'checkBlockStatus') {
      if (request.isBlocked) {
        hideBodyAndAddText()
        // opens `Things` app in `Today` view
        window.location.href = "things:///show?id=today"
      }
    }
  })

  browser.runtime.sendMessage({ command: 'getBlockStatus' })
}

// TODO: improve

// TODO: needed?
// browser.runtime.sendMessage({ greeting: "hello" }).then((response) => {
//   console.log("Received response: ", response)
// })

// browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
//   console.log("Received request: ", request)
// })

// Use a self-invoking function to wrap the code
// ;(function () {
//   if (document.readyState === "loading") {
//     // If the document is still loading, add an event listener for DOMContentLoaded
//     document.addEventListener("DOMContentLoaded", hideBodyAndAddText)
//   } else {
//     // If the document is already loaded, call the hideBodyAndAddText function directly
//     hideBodyAndAddText()
//   }
// })()

// TODO: was here by default, make use of it?
// browser.runtime.sendMessage({ greeting: "hello" }).then((response) => {
//     console.log("Received response: ", response);
// });

// browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
//     console.log("Received request: ", request);
// });
