var config = {
    hosts: {
        domain: 'evalynx-meet.duckdns.org',
        muc: 'conference.evalynx-meet.duckdns.org'
    },
    bosh: '//evalynx-meet.duckdns.org/http-bind',
    websocket: 'wss://evalynx-meet.duckdns.org/xmpp-websocket',
    
    // Completely disable prejoin
    prejoinPageEnabled: false,
    
    // CRITICAL: Completely disable lobby at every level
    enableLobby: false,
    disableLobbyPassword: true,
    
    // Hide lobby button from toolbar to prevent isLobbySupported() call
    toolbarButtons: [
        'microphone', 'camera', 'desktop', 'fullscreen',
        'fodeviceselection', 'hangup', 'profile', 'chat', 'recording',
        'livestreaming', 'etherpad', 'sharedvideo', 'settings', 'raisehand',
        'videoquality', 'filmstrip', 'feedback', 'stats', 'shortcuts',
        'tileview', 'download', 'help', 'mute-everyone', 'mute-video-everyone',
        'security'
        // NOTE: 'lobby-mode' is explicitly REMOVED from this list
    ],
    
    // Disable all lobby-related features
    lobby: {
        autoKnock: false,
        enableChat: false
    },
    
    // Hide lobby UI elements
    securityUi: {
        hideLobbyButton: true,
        disableLobbyPassword: true
    },
    
    // Disable features that might check lobby
    disableModeratorIndicator: false,
    
    // Disable visitors (which use lobby)
    visitors: {
        enabled: false
    },
    
    // Force P2P off for better server-based control
    p2p: {
        enabled: false
    },
    
    // Disable other unnecessary features
    enableClosePage: false,
    enableWelcomePage: false,
    disableInviteFunctions: false,
    
    // Basic conference settings
    openBridgeChannel: true,
    enableNoAudioDetection: true,
    enableNoisyMicDetection: true,
    
    // Recording
    fileRecordingsEnabled: true,
    liveStreamingEnabled: false,
    
    // Resolution settings
    resolution: 720,
    constraints: {
        video: {
            height: { ideal: 720, max: 1080, min: 360 }
        }
    },
    
    // Disable analytics
    analytics: {
        disabled: true
    },
    
    // Disable all third-party integrations
    deploymentInfo: {
        environment: 'production',
        region: 'default'
    }
};
