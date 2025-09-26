/* eslint-disable no-unused-vars, no-var, max-len */
/* eslint sort-keys: ["error", "asc", {"caseSensitive": false}] */

/**
 * !!!IMPORTANT!!!
 *
 * This file is considered deprecated. All options will eventually be moved to
 * config.js, and no new options should be added here.
 */

var interfaceConfig = {
    APP_NAME: 'Jitsi Meet',
    AUDIO_LEVEL_PRIMARY_COLOR: 'rgba(255,255,255,0.4)',
    AUDIO_LEVEL_SECONDARY_COLOR: 'rgba(255,255,255,0.2)',

    /**
     * A UX mode where the last screen share participant is automatically
     * pinned. Valid values are the string "remote-only" so that only remote
     * screen share participants are pinned, and the string "local-only" so that
     * only local screen share participants are pinned. Any other truthy value
     * pins all participants with screen share. Any falsy value disables the
     * feature.
     *
     * Note: this feature is not supported on all browsers.
     */
    AUTO_PIN_LATEST_SCREEN_SHARE: 'remote-only',

    BRAND_WATERMARK_LINK: '',

    CLOSE_PAGE_GUEST_HINT: false, // A html text to be shown to guests on the close page, false disables it

    DEFAULT_BACKGROUND: '#040404',
    DEFAULT_WELCOME_PAGE_LOGO_URL: 'images/watermark.svg',

    DISABLE_DOMINANT_SPEAKER_INDICATOR: false,

    /**
     * If true, notifications regarding joining/leaving are no longer displayed.
     */
    DISABLE_JOIN_LEAVE_NOTIFICATIONS: false,

    DISABLE_PRESENCE_STATUS: false,

    /**
     * Whether the ringing sound in the call/ring overlay is disabled. If
     * {@code undefined}, defaults to {@code false}.
     *
     * @type {boolean}
     */
    DISABLE_RINGING: false,

    /**
     * Whether the speech to text transcription subtitles panel is disabled.
     * If {@code undefined}, defaults to {@code false}.
     *
     * @type {boolean}
     */
    DISABLE_TRANSCRIPTION_SUBTITLES: false,

    DISABLE_VIDEO_BACKGROUND: false,

    DISPLAY_WELCOME_FOOTER: true,

    DISPLAY_WELCOME_PAGE_ADDITIONAL_CARD: true,

    DISPLAY_WELCOME_PAGE_CONTENT: true,

    DISPLAY_WELCOME_PAGE_TOOLBAR_ADDITIONAL_CONTENT: true,

    ENABLE_DIAL_OUT: true,

    ENABLE_FEEDBACK_ANIMATION: false, // Enables feedback star animation.

    ENABLE_FOCUS_INDICATOR: true,

    ENABLE_WELCOME_PAGE: true,

    ENABLE_WELCOME_PAGE_WHITELIST: false,

    FILM_STRIP_MAX_HEIGHT: 120,

    GENERATE_ROOMNAMES_ON_WELCOME_PAGE: true,

    HIDE_DEEP_LINKING_LOGO: false,

    HIDE_INVITE_MORE_HEADER: false,

    INITIAL_TOOLBAR_TIMEOUT: 20000,

    JITSI_WATERMARK_LINK: 'https://jitsi.org',

    LANG_DETECTION: true, // Allow i18n to detect the system language
    LIVE_STREAMING_HELP_LINK: 'https://jitsi.org/live', // Documentation reference for the live streaming feature.
    LOCAL_THUMBNAIL_RATIO: 16 / 9, // 16:9

    /**
     * Maximum coefficient of the ratio of the large video to the visible area
     * after the large video is scaled to fit the window.
     *
     * @type {number}
     */
    MAXIMUM_ZOOMING_COEFFICIENT: 1.3,

    /**
     * Whether the mobile app Jitsi Meet is to be promoted to participants
     * attempting to join a conference in a mobile Web browser. If
     * {@code undefined}, defaults to {@code true}.
     *
     * @type {boolean}
     */
    MOBILE_APP_PROMO: true,

    /**
     * Specify custom URL for downloading ffdj.
     * @type {string}
     */
    // OPTIMAL_BROWSERS: [ 'chrome', 'chromium', 'firefox', 'nwjs', 'electron', 'safari', 'webkit' ],

    POLICY_LOGO: null,
    PROVIDER_NAME: 'Jitsi',

    /**
     * If true, will display recent list
     *
     * @type {boolean}
     */
    RECENT_LIST_ENABLED: true,
    REMOTE_THUMBNAIL_RATIO: 1, // 1:1

    SETTINGS_SECTIONS: [
        'devices',
        'language',
        'moderator',
        'profile',
        'calendar',
        'sounds',
        'more'
    ],

    SHOW_BRAND_WATERMARK: false,

    /**
     * Decides whether the chrome extension banner should be rendered on the welcome page and during the meeting.
     * If this is set to false, the banner will not be rendered at all. If set to true, the check for extension(s)
     * being already installed is done before rendering.
     */
    SHOW_CHROME_EXTENSION_BANNER: false,

    SHOW_DEEP_LINKING_IMAGE: false,
    SHOW_JITSI_WATERMARK: true,
    SHOW_POWERED_BY: false,
    SHOW_WATERMARK_FOR_GUESTS: true,

    /*
     * If indicated some of the error dialogs may point to the support URL for
     * help.
     */
    SUPPORT_URL: 'https://community.jitsi.org/',

    TOOLBAR_ALWAYS_VISIBLE: false,

    TOOLBAR_BUTTONS: [
        'microphone', 'camera', 'closedcaptions', 'desktop', 'embedmeeting',
        'fullscreen', 'fodeviceselection', 'hangup', 'profile', 'chat', 'recording',
        'livestreaming', 'etherpad', 'sharedvideo', 'settings', 'raisehand',
        'videoquality', 'filmstrip', 'invite', 'feedback', 'stats', 'shortcuts',
        'tileview', 'videobackgroundblur', 'download', 'help', 'mute-everyone', 'e2ee'
    ],

    TOOLBAR_TIMEOUT: 4000,

    TOOLBAR_LOGO: null,

    UNSUPPORTED_BROWSERS: [],

    /**
     * Whether to show thumbnails in filmstrip as a column instead of as a row.
     */
    VERTICAL_FILMSTRIP: true,

    // Determines how the video would fit the screen. 'both' would fit the whole
    // screen, 'height' would fit the original video height to the height of the
    // screen, 'width' would fit the original video width to the width of the
    // screen respecting the aspect ratio.
    VIDEO_LAYOUT_FIT: 'both',

    /**
     * If true, hides the video quality label indicating the resolution status
     * of the current large video.
     *
     * @type {boolean}
     */
    VIDEO_QUALITY_LABEL_DISABLED: false,

    /**
     * How many columns the tile view can expand to. The respected range is
     * between 1 and 5.
     */
    // TILE_VIEW_MAX_COLUMNS: 5,

    /**
     * Specify Firebase dynamic link properties for the mobile apps.
     */
    // MOBILE_DYNAMIC_LINK: {
    //    APN: 'org.jitsi.meet',
    //    APP_CODE: 'w2atb',
    //    CUSTOM_DOMAIN: undefined,
    //    IBI: 'com.atlassian.JitsiMeet.ios',
    //    ISI: '1165103905'
    // },

    /**
     * Specify mobile app scheme for opening the app from the mobile browser.
     */
    // APP_SCHEME: 'org.jitsi.meet',

    // NATIVE_APP_NAME: 'Jitsi Meet',

    /**
     * Hide the logo on the deep linking pages.
     */
    // HIDE_DEEP_LINKING_LOGO: false,

    /**
     * Specify the Android app package name.
     */
    // ANDROID_APP_PACKAGE: 'org.jitsi.meet',

    /**
     * Override the behavior of some notifications to remain displayed until
     * explicitly dismissed through a user action. The value is how long, in
     * milliseconds, those notifications should remain displayed.
     */
    // ENFORCE_NOTIFICATION_AUTO_DISMISS_TIMEOUT: 15000,

    // Please use defaultLocalDisplayName from config.js
    // DEFAULT_LOCAL_DISPLAY_NAME: 'me',

    // Please use defaultLogoUrl from config.js
    // DEFAULT_LOGO_URL: 'images/watermark.svg',

    // Please use defaultRemoteDisplayName from config.js
    // DEFAULT_REMOTE_DISPLAY_NAME: 'Fellow Jitster',

    // Moved to config.js as `toolbarConfig.initialTimeout`.

    // Please use toolbarConfig.initialTimeout from config.js
    // INITIAL_TOOLBAR_TIMEOUT: 20000,
};