function updateUI(isBlocked) {
  const button = document.getElementById("toggleBlock")
  button.textContent = isBlocked ? "In Focus" : "In Break"
  button.style.backgroundColor = isBlocked ? "#ff4444" : "#44ff44"
}

// Get initial state when popup opens
browser.runtime.sendMessage({ command: "getBlockStatus" }).then((response) => {
  updateUI(response.isBlocked)
})

document.getElementById("toggleBlock").addEventListener("click", () => {
  browser.runtime.sendMessage({ command: "toggleBlock" }).then((response) => {
    updateUI(response.isBlocked)
  })
})
