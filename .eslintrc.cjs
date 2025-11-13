/* Global ESLint config enforcing “no inline styles” and React a11y basics.
   Note: Requires eslint + eslint-plugin-react (and optionally @typescript-eslint) to run. */
module.exports = {
  root: true,
  env: { browser: true, es2022: true, node: true },
  parserOptions: { ecmaVersion: 2022, sourceType: 'module', ecmaFeatures: { jsx: true } },
  settings: { react: { version: 'detect' } },
  plugins: ['react'],
  extends: [],
  overrides: [
    {
      files: ['**/*.{js,jsx,ts,tsx}'],
      rules: {
        // Absolutely forbid inline styles in markup
        'react/forbid-dom-props': ['error', { forbid: ['style'] }],
      },
    },
  ],
};

