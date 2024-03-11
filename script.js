fetch('https://lundgren_hud/ready', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({
        show: true
    })
})
    .then(resp => resp.json())
    .then(resp => console.log(resp));

window.addEventListener('message', (event) => {
    const action = event.data.action;
    const value = event.data[action];

    if (action === 'show') {
        toggleHudDisplay(true);
    } else if (action === 'hide' && (value || value === 0)) {
        setHudOpacity(value);
    } else if (['health', 'armour', 'food', 'water'].includes(action) && (value || value === 0)) {
        updateStatBar(action, value);
    } else if (action === 'voiceSpeaking') {
        const isSpeaking = event.data.isSpeaking;
        updateVoiceBox(isSpeaking);
    }
});

function toggleHudDisplay(show) {
    const hudElement = document.querySelector('.hud');
    hudElement.style.display = show ? 'flex' : 'none';
}

function setHudOpacity(opacity) {
    const hudElement = document.querySelector('.hud');
    hudElement.style.opacity = opacity;
}

function updateStatBar(stat, value) {
    const statElement = document.querySelector(`.${stat} .fill`);
    statElement.style.height = value + '%';

    const opacityValue = value <= 0 ? 0.502 : 1;
    const iconElement = document.querySelector(`.${stat} i`);
    iconElement.style.opacity = opacityValue;
}

function updateVoiceBox(isSpeaking) {
    const voiceFillElement = document.querySelector('.voice .fill');
    voiceFillElement.style.height = isSpeaking ? '100%' : '0%';
}