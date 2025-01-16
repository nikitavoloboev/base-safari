document.getElementById('toggleBlock').addEventListener('click', () => {
    browser.runtime.sendMessage({ command: 'toggleBlock' })
})
