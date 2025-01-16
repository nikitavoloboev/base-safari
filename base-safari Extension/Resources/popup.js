// Get initial state when popup opens
browser.runtime.sendMessage({ command: "getBlockStatus" }).then((response) => {
  updateButtonText(response.isBlocked)
})

function updateButtonText(isBlocked) {
  const button = document.getElementById("toggleBlock")
  button.textContent = isBlocked ? "Blocking Active" : "Blocking Inactive"
  button.style.backgroundColor = isBlocked ? "#ff4444" : "#44ff44"
}

document.getElementById("toggleBlock").addEventListener("click", () => {
  browser.runtime.sendMessage({ command: "toggleBlock" }).then((response) => {
    updateButtonText(response.isBlocked)
  })
})
