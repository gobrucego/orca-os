/* Global Stylelint config enforcing token usage via CSS variables and banning utilities. 
   Note: Requires stylelint and (optionally) stylelint-declaration-strict-value plugin to run. */
module.exports = {
  extends: [],
  plugins: [
    // 'stylelint-declaration-strict-value' // optional if available
  ],
  rules: {
    // Only allow var(--token-*) or safe keywords for color-like props
    'declaration-property-value-allowed-list': {
      '/^(color|background(-color)?|border(-.*)?-color)$/': [
        'transparent',
        'currentColor',
        '/^var\\(/',
      ],
      '/^(margin|padding|gap)$/': ['/^var\\(/'],
      'font-size': ['/^var\\(/'],
      'z-index': ['/^var\\(/'],
      'box-shadow': ['/^var\\(/', 'none'],
    },
    // Disallow !important and keep selectors sane
    'declaration-no-important': true,
    'selector-max-id': 0,
    // Encourage variables (don’t error on custom props)
    'property-no-unknown': [true, { ignoreProperties: [/^--/] }],
    'value-no-unknown-custom-properties': [false],
  },
};

