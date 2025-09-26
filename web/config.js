/* eslint-disable no-unused-vars, no-var, max-len */
/* eslint sort-keys: ["error", "asc", {"caseSensitive": false}] */

var config = {
    // Connection
    hosts: {
        domain: 'jitsi.riverlearn.co.ke',
        muc: 'conference.jitsi.riverlearn.co.ke'
    },

    // Service URLs
    serviceUrl: 'https://jitsi.riverlearn.co.ke/http-bind',

    // Bosh URL
    bosh: 'https://jitsi.riverlearn.co.ke/http-bind',

    // Websocket URL
    websocket: 'wss://jitsi.riverlearn.co.ke/xmpp-websocket',

    // Enable/disable features
    enableWelcomePage: true,
    enableClosePage: false,
    enableInsecureRoomNameWarning: false,
    enableNoisyMicDetection: true,
    enableTalkWhileMuted: true,
    enableLayerSuspension: true,
    channelLastN: -1,
    startScreenSharing: false,
    enableRemb: true,
    enableTcc: true,
    useRoomAsSharedDocumentName: true,
    enableIceRestart: true,
    useStunTurn: true,
    enableOpusRed: true,
    opusMaxAverageBitrate: 64000,
    enableRtx: true,
    enableSdpSemantics: 'unified-plan',
    enableNoAudioDetection: true,
    enableLipSync: false,
    enableFaceExpressions: false,
    enableP2P: false,

    // P2P configuration
    p2p: {
        enabled: false,
        stunServers: [
            { urls: 'stun:meet-jit-si-turnrelay.jitsi.net:443' }
        ]
    },

    // Analytics
    analytics: {
        disabled: true
    },

    // Recording
    recordingService: {
        enabled: false
    },

    // Live streaming
    liveStreamingEnabled: false,

    // File sharing
    enableFileUpload: false,
    enableFileDownload: false,

    // Chat
    enableChat: true,
    enablePrivateMessages: true,

    // Whiteboard
    enableWhiteboard: false,
    enableCollaborativeDocument: false,

    // Transcription
    enableTranscription: false,
    enableClosedCaptions: false,

    // Lobby
    enableLobby: false,
    enableKnockingLobby: false,

    // Other settings
    requireDisplayName: false,
    enableEmailInStats: false,
    disableDeepLinking: false,
    startAudioOnly: false,
    startWithAudioMuted: false,
    startWithVideoMuted: false,

    // Resolution
    resolution: 720,
    maxBitrate: 2500000,

    // Room configuration
    roomPasswordNumberOfDigits: 10,

    // Performance
    enableLayerSuspension: true,
    channelLastN: -1,

    // Disable third party requests
    disableThirdPartyRequests: true
};